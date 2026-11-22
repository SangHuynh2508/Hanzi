import 'package:equatable/equatable.dart';

import '../../../data/repositories/dictionary_repository.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.status = SearchStatus.initial,
    this.results = const [],
    this.error,
  });

  final String query;
  final SearchStatus status;
  final List<DictEntry> results;
  final String? error;

  @override
  List<Object?> get props => [query, status, results, error];
}
