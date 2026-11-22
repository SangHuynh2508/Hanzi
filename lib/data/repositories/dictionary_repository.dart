import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../../core/utils/pinyin.dart';
import '../../core/utils/text_normalize.dart';
import '../db/dictionary_database.dart' as db;

class DictEntry extends Equatable {
  const DictEntry({
    required this.id,
    required this.simplified,
    required this.traditional,
    required this.pinyin,
    required this.hanViet,
    required this.meaningVi,
    required this.meaningEn,
    this.hskLevel,
  });

  final int id;
  final String simplified, traditional, pinyin, hanViet, meaningVi, meaningEn;
  final int? hskLevel;

  // Dictionary rows are read-only, so the id identifies the entry.
  @override
  List<Object?> get props => [id];
}

class HanziInfo {
  const HanziInfo({
    required this.char,
    this.hanVietReadings = '',
    this.radical = '',
    this.decomposition = '',
    this.meaning = '',
  });

  final String char, hanVietReadings, radical, decomposition, meaning;
}

/// Read-only access to the bundled dictionary (spec §6).
class DictionaryRepository {
  DictionaryRepository(this._db);

  final db.DictionaryDatabase _db;

  /// Hanzi -> substring match on the characters. Anything else -> FTS prefix
  /// match on plain pinyin / Hán-Việt / Vietnamese meaning. Exact matches
  /// first, then words with an HSK level, then relevance.
  Future<List<DictEntry>> search(String query, {int limit = 50}) {
    final q = query.trim();
    if (q.isEmpty) return Future.value(const []);
    return containsHanzi(q) ? _searchHanzi(q, limit) : _searchText(q, limit);
  }

  Future<List<DictEntry>> _searchHanzi(String q, int limit) => _select(
        'SELECT * FROM dict_entries '
        'WHERE instr(simplified, ?1) > 0 OR instr(traditional, ?1) > 0 '
        'ORDER BY simplified = ?1 DESC, '
        'substr(simplified, 1, length(?1)) = ?1 DESC, '
        'hsk_level IS NULL, freq_rank IS NULL, freq_rank, length(simplified) '
        'LIMIT ?2',
        [Variable.withString(q), Variable.withInt(limit)],
      );

  Future<List<DictEntry>> _searchText(String q, int limit) {
    final plain = toPlain(q); // "xué shēng" / "xue2sheng1" -> "xuesheng"
    final vi = normalizeVi(q); // "Học  sinh" -> "hoc sinh"
    final tokens = vi
        .split(' ')
        .map((t) => t.replaceAll(RegExp('[^a-z0-9]'), ''))
        .where((t) => t.isNotEmpty);
    final match = [
      if (plain.isNotEmpty) 'pinyin_plain : "$plain"*',
      if (tokens.isNotEmpty) '(${tokens.map((t) => '"$t"*').join(' ')})',
    ].join(' OR ');
    if (match.isEmpty) return Future.value(const []);
    return _select(
      'SELECT e.* FROM dict_fts JOIN dict_entries e ON e.id = dict_fts.rowid '
      'WHERE dict_fts MATCH ?1 '
      'ORDER BY (e.pinyin_plain = ?2 OR e.han_viet_plain = ?3 '
      'OR e.meaning_vi_plain = ?3) DESC, '
      'e.hsk_level IS NULL, bm25(dict_fts) '
      'LIMIT ?4',
      [
        Variable.withString(match),
        Variable.withString(plain),
        Variable.withString(vi),
        Variable.withInt(limit),
      ],
    );
  }

  Future<DictEntry?> byId(int id) async {
    final r = await _select(
        'SELECT * FROM dict_entries WHERE id = ?1', [Variable.withInt(id)]);
    return r.isEmpty ? null : r.first;
  }

  /// One [HanziInfo] per distinct Chinese character of [word], in order.
  /// Characters missing from the hanzi table come back with empty fields.
  Future<List<HanziInfo>> breakdown(String word) async {
    final chars = word.runes
        .map(String.fromCharCode)
        .where(containsHanzi)
        .toSet()
        .toList();
    if (chars.isEmpty) return const [];
    final rows = await _db
        .customSelect(
          'SELECT * FROM hanzi WHERE char IN '
          '(${List.filled(chars.length, '?').join(',')})',
          variables: chars.map(Variable.withString).toList(),
          readsFrom: {_db.hanzi},
        )
        .get();
    final found = {
      for (final r in rows)
        r.read<String>('char'): HanziInfo(
          char: r.read<String>('char'),
          hanVietReadings: r.read<String>('han_viet_readings'),
          radical: r.read<String>('radical'),
          decomposition: r.read<String>('decomposition'),
          meaning: r.read<String>('meaning'),
        ),
    };
    return [for (final c in chars) found[c] ?? HanziInfo(char: c)];
  }

  Future<List<DictEntry>> byHskLevel(int level) => _select(
        'SELECT * FROM dict_entries WHERE hsk_level = ?1 '
        'ORDER BY freq_rank IS NULL, freq_rank, id',
        [Variable.withInt(level)],
      );

  /// Quiz distractors: [count] random entries of the same HSK level
  /// (null = unlevelled words), never one of [excludeIds].
  Future<List<DictEntry>> randomSameLevel(
    int? level, {
    required int count,
    required Set<int> excludeIds,
  }) =>
      _select(
        'SELECT * FROM dict_entries WHERE hsk_level IS ? '
        'AND id NOT IN (${List.filled(excludeIds.length, '?').join(',')}) '
        'ORDER BY random() LIMIT ?',
        [
          Variable<int>(level),
          ...excludeIds.map(Variable.withInt),
          Variable.withInt(count),
        ],
      );

  Future<List<DictEntry>> _select(String sql, List<Variable> vars) async {
    final rows = await _db
        .customSelect(sql, variables: vars, readsFrom: {_db.dictEntries})
        .get();
    return rows.map(_entry).toList();
  }

  static DictEntry _entry(QueryRow r) => DictEntry(
        id: r.read<int>('id'),
        simplified: r.read<String>('simplified'),
        traditional: r.read<String>('traditional'),
        pinyin: r.read<String>('pinyin'),
        hanViet: r.read<String>('han_viet'),
        meaningVi: r.read<String>('meaning_vi'),
        meaningEn: r.read<String>('meaning_en'),
        hskLevel: r.readNullable<int>('hsk_level'),
      );
}
