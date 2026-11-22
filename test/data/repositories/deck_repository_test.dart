import 'package:doanmonhoc_hanzi/data/repositories/card_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/repos.dart';

final _uuidV4 =
    RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');

void main() {
  late TestRepos r;
  setUp(() async => r = await TestRepos.open());
  tearDown(() => r.close());

  test('create gives a UUID v4 deck with no cards', () async {
    final id = await r.decks.create('Bộ của tôi', 'mô tả');
    expect(id, matches(_uuidV4));
    final d = (await r.decks.watchDecks().first).single;
    expect((d.name, d.description, d.cardCount, d.dueCount),
        ('Bộ của tôi', 'mô tả', 0, 0));
  });

  test('addHskDeck copies every HSK 1 word as a new card, once', () async {
    final id = await r.decks.addHskDeck(1);
    final d = (await r.decks.watchDecks().first).single;
    expect((d.id, d.name, d.hskLevel, d.cardCount), (id, 'HSK 1', 1, 20));
    expect(d.dueCount, 20, reason: 'new cards are due immediately');

    final cards = await r.cards.watchCards(id!).first;
    expect(cards.every((c) => c.srs.state == 1 && c.srs.stability == null),
        isTrue);
    expect(cards.every((c) => c.dictEntryId != null), isTrue);

    expect(await r.decks.addHskDeck(1), id);
    expect((await r.decks.watchDecks().first).single.cardCount, 20);
  });

  test('addHskDeck makes no empty deck when the dictionary has no words',
      () async {
    expect(await r.decks.addHskDeck(6), isNull); // sample has HSK 1 only
    expect(await r.decks.watchDecks().first, isEmpty);
  });

  test('delete hides the deck and its cards; restore brings them back',
      () async {
    final id = (await r.decks.addHskDeck(1))!;
    final before = await r.cards.watchCards(id).first;
    await r.cards.delete(before.first.id); // deleted on its own, earlier

    r.clock.now = r.clock.now.add(const Duration(minutes: 1));
    await r.decks.delete(id);
    expect(await r.decks.watchDecks().first, isEmpty);
    final rows = await r.app
        .customSelect('SELECT COUNT(*) n FROM cards WHERE deleted_at IS NOT NULL')
        .getSingle();
    expect(rows.read<int>('n'), 20);

    await r.decks.restore(id);
    final d = (await r.decks.watchDecks().first).single;
    expect(d.cardCount, 19, reason: 'the card deleted on its own stays gone');
  });

  test('rename stamps updatedAt and marks dirty', () async {
    final id = await r.decks.create('A', '');
    await r.app.customStatement('UPDATE decks SET dirty = 0');
    r.clock.now = DateTime.utc(2026, 11, 23);
    await r.decks.rename(id, 'B', 'mới');
    final row = await (r.app.select(r.app.decks)).getSingle();
    expect((row.name, row.description, row.dirty), ('B', 'mới', true));
    expect(row.updatedAt, DateTime.utc(2026, 11, 23));
  });

  test('watchDecks filter ignores case and Vietnamese accents', () async {
    await r.decks.create('Từ vựng du lịch', '');
    await r.decks.addHskDeck(1);
    expect((await r.decks.watchDecks(filter: 'tu vung').first).single.name,
        'Từ vựng du lịch');
    expect((await r.decks.watchDecks(filter: 'hsk').first).single.name,
        'HSK 1');
  });

  test('watchDeck follows one deck', () async {
    final id = await r.decks.create('A', '');
    await r.cards.create(
        id, const CardDraft(hanzi: '你', pinyin: 'nǐ', meaning: 'bạn'));
    expect((await r.decks.watchDeck(id).first)!.cardCount, 1);
    await r.decks.delete(id);
    expect(await r.decks.watchDeck(id).first, isNull);
  });
}
