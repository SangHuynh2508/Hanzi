import 'package:equatable/equatable.dart';

import '../../../data/repositories/dictionary_repository.dart';

enum WordDetailStatus { loading, loaded, notFound, failure }

class WordDetailState extends Equatable {
  const WordDetailState({
    this.status = WordDetailStatus.loading,
    this.entry,
    this.chars = const [],
  });

  final WordDetailStatus status;

  /// Set before loading finishes when the caller already has the entry
  /// (from the search list), so the Hero has something to fly to.
  final DictEntry? entry;
  final List<HanziInfo> chars;

  @override
  List<Object?> get props => [status, entry, chars];
}
