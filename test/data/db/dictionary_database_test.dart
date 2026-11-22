import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/sample_dictionary.dart';

void main() {
  late DictionaryDatabase db;
  setUp(() async => db = await openSampleDictionary());
  tearDown(() => db.close());

  test('schema version matches the PRAGMA user_version the builder sets', () {
    expect(db.schemaVersion, 1);
  });

  test('学生 has Hán-Việt and plain pinyin', () async {
    final row = await db
        .customSelect(
          "SELECT han_viet, pinyin_plain FROM dict_entries WHERE simplified = '学生'",
        )
        .getSingle();
    expect(row.read<String>('han_viet'), 'học sinh');
    expect(row.read<String>('pinyin_plain'), 'xuesheng');
  });

  test('FTS prefix xue* finds 学生 and 学习', () async {
    final rows = await db
        .customSelect(
          "SELECT e.simplified FROM dict_fts f JOIN dict_entries e ON e.id = f.rowid "
          "WHERE dict_fts MATCH 'xue*'",
        )
        .get();
    final words = rows.map((r) => r.read<String>('simplified')).toSet();
    expect(words, containsAll(['学生', '学习']));
  });
}
