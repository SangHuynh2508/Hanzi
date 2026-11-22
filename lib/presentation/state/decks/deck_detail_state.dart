import 'package:equatable/equatable.dart';

import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/deck_repository.dart';

class DeckDetailState extends Equatable {
  const DeckDetailState({
    this.deck,
    this.cards = const [],
    this.filter = '',
    this.loading = true,
  });

  /// Null while loading, or after the deck was deleted.
  final Deck? deck;
  final List<CardItem> cards;
  final String filter;
  final bool loading;

  DeckDetailState copyWith({
    Deck? Function()? deck,
    List<CardItem>? cards,
    String? filter,
    bool? loading,
  }) =>
      DeckDetailState(
        deck: deck == null ? this.deck : deck(),
        cards: cards ?? this.cards,
        filter: filter ?? this.filter,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [deck, cards, filter, loading];
}
