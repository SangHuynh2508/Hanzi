import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/dictionary_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repo) : super(const SearchState());

  final DictionaryRepository _repo;
  Timer? _debounce;

  void queryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      emit(SearchState(query: query));
      return;
    }
    emit(SearchState(
      query: query,
      status: SearchStatus.loading,
      results: state.results,
    ));
    _debounce = Timer(kSearchDebounce, () => _run(query));
  }

  Future<void> _run(String query) async {
    try {
      final results = await _repo.search(query);
      if (isClosed || state.query != query) return; // a newer query won
      emit(SearchState(
          query: query, status: SearchStatus.success, results: results));
    } catch (_) {
      if (isClosed || state.query != query) return;
      emit(SearchState(
        query: query,
        status: SearchStatus.failure,
        error: 'Không tra được từ, thử lại sau.',
      ));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
