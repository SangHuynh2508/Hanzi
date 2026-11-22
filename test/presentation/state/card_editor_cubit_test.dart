import 'package:doanmonhoc_hanzi/data/repositories/card_repository.dart';
import 'package:doanmonhoc_hanzi/presentation/state/decks/card_editor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/repos.dart';

void main() {
  late TestRepos r;
  late String deck;
  late CardEditorCubit cubit;

  setUp(() async {
    r = await TestRepos.open();
    deck = await r.decks.create('A', '');
    cubit = CardEditorCubit(
        cards: r.cards, dictionary: r.dictionary, deckId: deck);
  });
  tearDown(() async {
    await cubit.close();
    await r.close();
  });

  Future<int> cardCount() async =>
      (await r.cards.watchCards(deck).first).length;

  test('empty hanzi is rejected and nothing is written', () async {
    cubit.meaningChanged('học sinh');
    await cubit.save();
    expect(cubit.state.errors.keys, ['hanzi']);
    expect(cubit.state.saved, isFalse);
    expect(await cardCount(), 0);
  });

  test('empty meaning is rejected and nothing is written', () async {
    cubit.hanziChanged('学生');
    await cubit.save();
    expect(cubit.state.errors.keys, ['meaning']);
    expect(await cardCount(), 0);
  });

  test('typing hanzi suggests dictionary words; picking one fills the form',
      () async {
    cubit.hanziChanged('学生');
    final withSuggestions =
        await cubit.stream.firstWhere((s) => s.suggestions.isNotEmpty);
    final hit = withSuggestions.suggestions.first;
    expect(hit.simplified, '学生');

    cubit.pickSuggestion(hit);
    final d = cubit.state.draft;
    expect((d.hanzi, d.pinyin, d.hanViet, d.meaning, d.dictEntryId),
        ('学生', 'xué shēng', 'học sinh', 'học sinh', 1));
    expect(cubit.state.suggestions, isEmpty);

    await cubit.save();
    expect(cubit.state.saved, isTrue);
    expect((await r.cards.watchCards(deck).first).single.dictEntryId, 1);
  });

  test('editing an existing card updates it instead of adding one', () async {
    final id = await r.cards.create(
        deck, const CardDraft(hanzi: '你', pinyin: 'nǐ', meaning: 'bạn'));
    final existing = (await r.cards.watchCards(deck).first).single;
    final edit = CardEditorCubit(
        cards: r.cards, dictionary: r.dictionary, deckId: deck,
        existing: existing);
    addTearDown(edit.close);

    expect(edit.state.draft.hanzi, '你');
    edit.meaningChanged('anh, chị');
    await edit.save();
    final cards = await r.cards.watchCards(deck).first;
    expect((cards.single.id, cards.single.meaning), (id, 'anh, chị'));
  });
}
