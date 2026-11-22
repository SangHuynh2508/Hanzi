import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/deck_repository.dart';
import 'deck_detail_state.dart';

class DeckDetailCubit extends Cubit<DeckDetailState> {
  DeckDetailCubit(this._decks, this._cards, this.deckId)
      : super(const DeckDetailState()) {
    _deckSub = _decks
        .watchDeck(deckId)
        .listen((d) => emit(state.copyWith(deck: () => d, loading: false)));
    _watchCards('');
  }

  final DeckRepository _decks;
  final CardRepository _cards;
  final String deckId;
  StreamSubscription<Deck?>? _deckSub;
  StreamSubscription<List<CardItem>>? _cardSub;

  void filterChanged(String filter) => _watchCards(filter);

  void _watchCards(String filter) {
    _cardSub?.cancel();
    _cardSub = _cards
        .watchCards(deckId, filter: filter)
        .listen((c) => emit(state.copyWith(cards: c, filter: filter)));
  }

  Future<void> rename(String name, String description) =>
      _decks.rename(deckId, name, description);
  Future<void> deleteDeck() => _decks.delete(deckId);
  Future<void> restoreDeck() => _decks.restore(deckId);
  /// Removes the card from the list at once (see DeckListCubit.delete).
  Future<void> deleteCard(String id) {
    emit(state.copyWith(
        cards: state.cards.where((c) => c.id != id).toList()));
    return _cards.delete(id);
  }
  Future<void> restoreCard(String id) => _cards.restore(id);

  @override
  Future<void> close() {
    _deckSub?.cancel();
    _cardSub?.cancel();
    return super.close();
  }
}
