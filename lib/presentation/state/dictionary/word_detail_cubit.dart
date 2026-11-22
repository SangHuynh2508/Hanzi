import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/dictionary_repository.dart';
import 'word_detail_state.dart';

class WordDetailCubit extends Cubit<WordDetailState> {
  WordDetailCubit(this._repo, {DictEntry? preview})
      : super(WordDetailState(entry: preview));

  final DictionaryRepository _repo;

  Future<void> load(int id) async {
    try {
      final entry = await _repo.byId(id);
      if (entry == null) {
        emit(const WordDetailState(status: WordDetailStatus.notFound));
        return;
      }
      final chars = await _repo.breakdown(entry.simplified);
      emit(WordDetailState(
          status: WordDetailStatus.loaded, entry: entry, chars: chars));
    } catch (_) {
      emit(WordDetailState(status: WordDetailStatus.failure, entry: state.entry));
    }
  }
}
