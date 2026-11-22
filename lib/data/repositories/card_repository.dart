import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../../core/utils/clock.dart';
import '../../core/utils/ids.dart';
import '../../core/utils/pinyin.dart';
import '../../core/utils/text_normalize.dart';
import '../db/app_database.dart';
import '../srs/srs_scheduler.dart';
import 'dictionary_repository.dart';

/// What the user typed (or picked from the dictionary) for one card.
class CardDraft extends Equatable {
  const CardDraft({
    this.hanzi = '',
    this.pinyin = '',
    this.hanViet = '',
    this.meaning = '',
    this.example = '',
    this.dictEntryId,
  });

  factory CardDraft.fromEntry(DictEntry e) => CardDraft(
        hanzi: e.simplified,
        pinyin: e.pinyin,
        hanViet: e.hanViet,
        meaning: e.meaningVi,
        dictEntryId: e.id,
      );

  factory CardDraft.fromItem(CardItem c) => CardDraft(
        hanzi: c.hanzi,
        pinyin: c.pinyin,
        hanViet: c.hanViet,
        meaning: c.meaning,
        example: c.example,
        dictEntryId: c.dictEntryId,
      );

  final String hanzi, pinyin, hanViet, meaning, example;
  final int? dictEntryId;

  CardDraft copyWith({
    String? hanzi,
    String? pinyin,
    String? hanViet,
    String? meaning,
    String? example,
  }) =>
      CardDraft(
        hanzi: hanzi ?? this.hanzi,
        pinyin: pinyin ?? this.pinyin,
        hanViet: hanViet ?? this.hanViet,
        meaning: meaning ?? this.meaning,
        example: example ?? this.example,
        dictEntryId: dictEntryId,
      );

  @override
  List<Object?> get props =>
      [hanzi, pinyin, hanViet, meaning, example, dictEntryId];
}

class CardItem extends Equatable {
  const CardItem({
    required this.id,
    required this.deckId,
    required this.hanzi,
    required this.pinyin,
    required this.hanViet,
    required this.meaning,
    required this.example,
    required this.dictEntryId,
    required this.srs,
  });

  final String id, deckId, hanzi, pinyin, hanViet, meaning, example;
  final int? dictEntryId;
  final SrsState srs;

  @override
  List<Object?> get props =>
      [id, hanzi, pinyin, hanViet, meaning, example, srs.state, srs.due];
}

class CardRepository {
  CardRepository(
    this._db, {
    required this._scheduler,
    this._clock = const Clock(),
  });

  final AppDatabase _db;
  final SrsScheduler _scheduler;
  final Clock _clock;

  /// Live cards of a deck, oldest first. [filter] matches hanzi, pinyin
  /// (any tone style), Hán-Việt or meaning, ignoring Vietnamese accents.
  Stream<List<CardItem>> watchCards(String deckId, {String filter = ''}) {
    final q = _db.select(_db.cards)
      ..where((c) => c.deckId.equals(deckId) & c.deletedAt.isNull())
      ..orderBy([
        (c) => OrderingTerm.asc(c.createdAt),
        (_) => OrderingTerm.asc(const CustomExpression<int>('rowid')),
      ]);
    return q.watch().map((rows) =>
        rows.map(_item).where((c) => _matches(c, filter)).toList());
  }

  Future<String> create(String deckId, CardDraft draft) async {
    final row = _row(deckId, draft, _clock.nowUtc());
    await _db.into(_db.cards).insert(row);
    return row.id.value;
  }

  /// Used by DeckRepository.addHskDeck.
  Future<void> insertAll(String deckId, Iterable<CardDraft> drafts) {
    final now = _clock.nowUtc();
    return _db.batch((b) =>
        b.insertAll(_db.cards, [for (final d in drafts) _row(deckId, d, now)]));
  }

  Future<void> update(String id, CardDraft d) => _write(
        id,
        CardsCompanion(
          hanzi: Value(d.hanzi.trim()),
          pinyin: Value(d.pinyin.trim()),
          hanViet: Value(d.hanViet.trim()),
          meaning: Value(d.meaning.trim()),
          example: Value(d.example.trim()),
          dictEntryId: Value(d.dictEntryId),
        ),
      );

  Future<void> delete(String id) =>
      _write(id, CardsCompanion(deletedAt: Value(_clock.nowUtc())));

  Future<void> restore(String id) =>
      _write(id, const CardsCompanion(deletedAt: Value(null)));

  Future<void> _write(String id, CardsCompanion changes) =>
      (_db.update(_db.cards)..where((c) => c.id.equals(id))).write(
          changes.copyWith(
              updatedAt: Value(_clock.nowUtc()), dirty: const Value(true)));

  CardsCompanion _row(String deckId, CardDraft d, DateTime now) {
    final s = _scheduler.newCard(now);
    return CardsCompanion.insert(
      id: newId(),
      deckId: deckId,
      dictEntryId: Value(d.dictEntryId),
      hanzi: d.hanzi.trim(),
      pinyin: d.pinyin.trim(),
      hanViet: d.hanViet.trim(),
      meaning: d.meaning.trim(),
      example: Value(d.example.trim()),
      srsState: s.state,
      srsStep: Value(s.step),
      stability: Value(s.stability),
      difficulty: Value(s.difficulty),
      due: s.due,
      lastReview: Value(s.lastReview),
      createdAt: now,
      updatedAt: now,
    );
  }

  static CardItem _item(Card r) => CardItem(
        id: r.id,
        deckId: r.deckId,
        hanzi: r.hanzi,
        pinyin: r.pinyin,
        hanViet: r.hanViet,
        meaning: r.meaning,
        example: r.example,
        dictEntryId: r.dictEntryId,
        srs: SrsState(
          state: r.srsState,
          step: r.srsStep,
          stability: r.stability,
          difficulty: r.difficulty,
          due: r.due,
          lastReview: r.lastReview,
        ),
      );

  // ponytail: filters in Dart, fine for a few thousand cards per deck;
  // move to SQL with *_plain columns if decks get much bigger.
  static bool _matches(CardItem c, String filter) {
    final f = filter.trim();
    if (f.isEmpty) return true;
    if (containsHanzi(f)) return c.hanzi.contains(f);
    final vi = normalizeVi(f);
    final plain = toPlain(f);
    return normalizeVi(c.hanViet).contains(vi) ||
        normalizeVi(c.meaning).contains(vi) ||
        (plain.isNotEmpty && toPlain(c.pinyin).contains(plain));
  }
}
