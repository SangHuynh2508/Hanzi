import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/deck_repository.dart';
import 'deck_list_state.dart';

class DeckListCubit extends Cubit<DeckListState> {
  DeckListCubit(this._decks) : super(const DeckListState()) {
    _watch('');
  }

  final DeckRepository _decks;
  StreamSubscription<List<Deck>>? _sub;

  void filterChanged(String filter) => _watch(filter);

  void _watch(String filter) {
    _sub?.cancel();
    _sub = _decks.watchDecks(filter: filter).listen((decks) =>
        emit(DeckListState(decks: decks, filter: filter, loading: false)));
  }

  Future<String> create(String name, String description) =>
      _decks.create(name, description);
  Future<void> rename(String id, String name, String description) =>
      _decks.rename(id, name, description);
  /// Drops the deck from the list at once (a swiped Dismissible must leave
  /// the tree before the DB stream catches up), then deletes it.
  Future<void> delete(String id) {
    emit(DeckListState(
      decks: state.decks.where((d) => d.id != id).toList(),
      filter: state.filter,
      loading: false,
    ));
    return _decks.delete(id);
  }

  Future<void> restore(String id) => _decks.restore(id);
  Future<String?> addHsk(int level) => _decks.addHskDeck(level);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
