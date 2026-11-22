import 'package:equatable/equatable.dart';

import '../../../data/repositories/deck_repository.dart';

class DeckListState extends Equatable {
  const DeckListState({
    this.decks = const [],
    this.filter = '',
    this.loading = true,
  });

  final List<Deck> decks;
  final String filter;
  final bool loading;

  @override
  List<Object?> get props => [decks, filter, loading];
}
