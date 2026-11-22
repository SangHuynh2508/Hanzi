import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/text_normalize.dart';
import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/dictionary_repository.dart';
import 'card_editor_state.dart';

class CardEditorCubit extends Cubit<CardEditorState> {
  CardEditorCubit({
    required this._cards,
    required this._dictionary,
    required this.deckId,
    CardItem? existing,
  })  : _existingId = existing?.id,
        super(CardEditorState(
          draft: existing == null
              ? const CardDraft()
              : CardDraft.fromItem(existing),
          isEdit: existing != null,
        ));

  final CardRepository _cards;
  final DictionaryRepository _dictionary;
  final String deckId;
  final String? _existingId;

  /// Typing new hanzi drops the dictionary link and looks for suggestions.
  void hanziChanged(String v) {
    final d = state.draft;
    emit(state.copyWith(
      draft: CardDraft(
          hanzi: v,
          pinyin: d.pinyin,
          hanViet: d.hanViet,
          meaning: d.meaning,
          example: d.example),
      errors: Map.of(state.errors)..remove('hanzi'),
    ));
    _suggest(v);
  }

  Future<void> _suggest(String v) async {
    final q = v.trim();
    if (!containsHanzi(q)) {
      if (state.suggestions.isNotEmpty) {
        emit(state.copyWith(suggestions: const []));
      }
      return;
    }
    final found = await _dictionary.search(q, limit: 5);
    if (isClosed || state.draft.hanzi != v) return; // user kept typing
    emit(state.copyWith(suggestions: found));
  }

  void pickSuggestion(DictEntry e) => emit(state.copyWith(
        draft: CardDraft.fromEntry(e).copyWith(example: state.draft.example),
        suggestions: const [],
        errors: const {},
      ));

  void pinyinChanged(String v) =>
      emit(state.copyWith(draft: state.draft.copyWith(pinyin: v)));

  void hanVietChanged(String v) =>
      emit(state.copyWith(draft: state.draft.copyWith(hanViet: v)));

  void meaningChanged(String v) => emit(state.copyWith(
        draft: state.draft.copyWith(meaning: v),
        errors: Map.of(state.errors)..remove('meaning'),
      ));

  void exampleChanged(String v) =>
      emit(state.copyWith(draft: state.draft.copyWith(example: v)));

  Future<void> save() async {
    final d = state.draft;
    final errors = {
      if (d.hanzi.trim().isEmpty) 'hanzi': 'Nhập chữ Hán',
      if (d.meaning.trim().isEmpty) 'meaning': 'Nhập nghĩa',
    };
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return;
    }
    final id = _existingId;
    if (id == null) {
      await _cards.create(deckId, d);
    } else {
      await _cards.update(id, d);
    }
    if (!isClosed) emit(state.copyWith(saved: true));
  }
}
