import 'package:doanmonhoc_hanzi/data/repositories/card_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/repos.dart';

void main() {
  late TestRepos r;
  late String deck;
  setUp(() async {
    r = await TestRepos.open();
    deck = await r.decks.create('A', '');
  });
  tearDown(() => r.close());

  const xuesheng = CardDraft(
    hanzi: '学生',
    pinyin: 'xué shēng',
    hanViet: 'học sinh',
    meaning: 'học sinh',
    example: '我是学生。',
    dictEntryId: 1,
  );

  test('create stores the draft as a new, dirty card', () async {
    final id = await r.cards.create(deck, xuesheng);
    final c = (await r.cards.watchCards(deck).first).single;
    expect((c.id, c.hanzi, c.pinyin, c.hanViet, c.meaning, c.example),
        (id, '学生', 'xué shēng', 'học sinh', 'học sinh', '我是学生。'));
    expect(c.dictEntryId, 1);
    expect(c.srs.state, 1);
    expect(c.srs.due, r.clock.now);
    final row = await r.app.select(r.app.cards).getSingle();
    expect((row.dirty, row.updatedAt), (true, r.clock.now));
  });

  test('update changes the fields and stamps updatedAt', () async {
    final id = await r.cards.create(deck, xuesheng);
    r.clock.now = DateTime.utc(2026, 11, 23);
    await r.cards.update(id, xuesheng.copyWith(meaning: 'sinh viên'));
    expect((await r.cards.watchCards(deck).first).single.meaning, 'sinh viên');
    final row = await r.app.select(r.app.cards).getSingle();
    expect(row.updatedAt, DateTime.utc(2026, 11, 23));
  });

  group('watchCards filter', () {
    setUp(() async {
      await r.cards.create(deck, xuesheng);
      await r.cards.create(deck,
          const CardDraft(hanzi: '老师', pinyin: 'lǎo shī', hanViet: 'lão sư',
              meaning: 'giáo viên'));
    });

    Future<List<String>> hanzi(String f) async =>
        (await r.cards.watchCards(deck, filter: f).first)
            .map((c) => c.hanzi)
            .toList();

    test('by Hán-Việt without accents', () async {
      expect(await hanzi('hoc'), ['学生']);
    });
    test('by hanzi', () async => expect(await hanzi('学'), ['学生']));
    test('by pinyin', () async => expect(await hanzi('laoshi'), ['老师']));
    test('by meaning', () async => expect(await hanzi('giao vien'), ['老师']));
    test('blank filter shows all', () async {
      expect(await hanzi('  '), hasLength(2));
    });
  });

  test('delete hides the card, restore shows it again', () async {
    final id = await r.cards.create(deck, xuesheng);
    await r.cards.delete(id);
    expect(await r.cards.watchCards(deck).first, isEmpty);
    await r.cards.restore(id);
    expect(await r.cards.watchCards(deck).first, hasLength(1));
  });
}
