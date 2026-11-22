import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart'
    show DictionaryDatabase;
import 'package:doanmonhoc_hanzi/data/repositories/dictionary_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/sample_dictionary.dart';

void main() {
  late DictionaryDatabase db;
  late DictionaryRepository repo;

  setUp(() async {
    db = await openSampleDictionary();
    repo = DictionaryRepository(db);
  });
  tearDown(() => db.close());

  List<String> words(List<DictEntry> r) => r.map((e) => e.simplified).toList();

  group('search', () {
    test('hanzi query puts the exact word first', () async {
      final r = await repo.search('学生');
      expect(r.first.simplified, '学生');
    });

    test('hanzi query also finds words containing it', () async {
      expect(words(await repo.search('生')), contains('学生'));
    });

    for (final q in ['xuesheng', 'xué shēng', 'xue2sheng1', 'XueSheng']) {
      test('pinyin "$q" finds 学生', () async {
        expect(words(await repo.search(q)), contains('学生'));
      });
    }

    test('pinyin prefix "xue" finds both 学 words', () async {
      expect(words(await repo.search('xue')), containsAll(['学生', '学习']));
    });

    for (final q in ['hoc sinh', 'học sinh', 'HỌC SINH']) {
      test('Vietnamese "$q" finds 学生', () async {
        expect(words(await repo.search(q)), contains('学生'));
      });
    }

    test('exact Vietnamese match ranks first', () async {
      expect((await repo.search('hoc sinh')).first.simplified, '学生');
    });

    test('blank query returns nothing', () async {
      expect(await repo.search('   '), isEmpty);
    });

    test('FTS syntax characters do not throw', () async {
      expect(await repo.search('"xue* OR ('), isA<List<DictEntry>>());
    });
  });

  test('byId returns the entry, null when missing', () async {
    expect((await repo.byId(1))!.simplified, '学生');
    expect(await repo.byId(99999), isNull);
  });

  test('breakdown splits a word into its characters in order', () async {
    final r = await repo.breakdown('学生');
    expect(r.map((h) => h.char), ['学', '生']);
    expect(r.first.hanVietReadings, isNotEmpty);
  });

  test('breakdown keeps characters missing from the hanzi table', () async {
    final r = await repo.breakdown('你');
    expect(r.single.char, '你');
    expect(r.single.radical, '');
  });

  test('byHskLevel returns the level', () async {
    final r = await repo.byHskLevel(1);
    expect(r, hasLength(20));
    expect(r.every((e) => e.hskLevel == 1), isTrue);
  });

  test('randomSameLevel gives distinct entries and honours excludeIds',
      () async {
    final r = await repo.randomSameLevel(1, count: 3, excludeIds: {1});
    expect(r, hasLength(3));
    expect(r.map((e) => e.id).toSet(), hasLength(3));
    expect(r.map((e) => e.id), isNot(contains(1)));
  });
}
