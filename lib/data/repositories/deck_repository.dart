import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../../core/utils/clock.dart';
import '../../core/utils/ids.dart';
import '../../core/utils/text_normalize.dart';
import '../db/app_database.dart' hide Deck;
import 'card_repository.dart';
import 'dictionary_repository.dart';

class Deck extends Equatable {
  const Deck({
    required this.id,
    required this.name,
    required this.description,
    required this.hskLevel,
    required this.cardCount,
    required this.dueCount,
  });

  final String id, name, description;
  final int? hskLevel;
  final int cardCount, dueCount;

  @override
  List<Object?> get props =>
      [id, name, description, hskLevel, cardCount, dueCount];
}

class DeckRepository {
  DeckRepository(
    this._db, {
    required this._cards,
    required this._dictionary,
    this._clock = const Clock(),
  });

  final AppDatabase _db;
  final CardRepository _cards;
  final DictionaryRepository _dictionary;
  final Clock _clock;

  /// Live decks with card counts. [filter] ignores case and accents.
  // ponytail: "due" is judged against the time the stream was opened;
  // screens re-subscribe when shown, add a ticker if that proves stale.
  Stream<List<Deck>> watchDecks({String filter = ''}) {
    final f = normalizeVi(filter);
    return _db
        .customSelect(
          'SELECT d.*, '
          '(SELECT COUNT(*) FROM cards c WHERE c.deck_id = d.id '
          'AND c.deleted_at IS NULL) AS card_count, '
          '(SELECT COUNT(*) FROM cards c WHERE c.deck_id = d.id '
          'AND c.deleted_at IS NULL AND c.due <= ?1) AS due_count '
          'FROM decks d WHERE d.deleted_at IS NULL '
          'ORDER BY d.created_at, d.rowid',
          variables: [Variable<DateTime>(_clock.nowUtc())],
          readsFrom: {_db.decks, _db.cards},
        )
        .watch()
        .map((rows) => rows
            .map(_deck)
            .where((d) => f.isEmpty || normalizeVi(d.name).contains(f))
            .toList());
  }

  Stream<Deck?> watchDeck(String id) => watchDecks()
      .map((decks) => decks.where((d) => d.id == id).firstOrNull);

  Future<String> create(String name, String description, {int? hskLevel}) async {
    final id = newId();
    final now = _clock.nowUtc();
    await _db.into(_db.decks).insert(DecksCompanion.insert(
          id: id,
          name: name.trim(),
          description: Value(description.trim()),
          hskLevel: Value(hskLevel),
          createdAt: now,
          updatedAt: now,
        ));
    return id;
  }

  Future<void> rename(String id, String name, String description) =>
      (_db.update(_db.decks)..where((d) => d.id.equals(id))).write(
        DecksCompanion(
          name: Value(name.trim()),
          description: Value(description.trim()),
          updatedAt: Value(_clock.nowUtc()),
          dirty: const Value(true),
        ),
      );

  /// Soft-deletes the deck and its live cards with the same timestamp, so
  /// [restore] can bring back exactly those cards.
  Future<void> delete(String id) => _db.transaction(() async {
        final now = _clock.nowUtc();
        final gone = DecksCompanion(
            deletedAt: Value(now), updatedAt: Value(now), dirty: const Value(true));
        await (_db.update(_db.decks)..where((d) => d.id.equals(id))).write(gone);
        await (_db.update(_db.cards)
              ..where((c) => c.deckId.equals(id) & c.deletedAt.isNull()))
            .write(CardsCompanion(
                deletedAt: Value(now),
                updatedAt: Value(now),
                dirty: const Value(true)));
      });

  Future<void> restore(String id) => _db.transaction(() async {
        final deck = await (_db.select(_db.decks)
              ..where((d) => d.id.equals(id)))
            .getSingleOrNull();
        final when = deck?.deletedAt;
        if (when == null) return;
        final now = _clock.nowUtc();
        await (_db.update(_db.decks)..where((d) => d.id.equals(id))).write(
            DecksCompanion(
                deletedAt: const Value(null),
                updatedAt: Value(now),
                dirty: const Value(true)));
        await (_db.update(_db.cards)
              ..where((c) => c.deckId.equals(id) & c.deletedAt.equals(when)))
            .write(CardsCompanion(
                deletedAt: const Value(null),
                updatedAt: Value(now),
                dirty: const Value(true)));
      });

  /// Creates "HSK [level]" with every dictionary word of that level as a new
  /// card. If such a deck already exists, returns it untouched. Null when the
  /// dictionary has no word of that level (no empty deck is created).
  Future<String?> addHskDeck(int level) async {
    final existing = await (_db.select(_db.decks)
          ..where((d) => d.hskLevel.equals(level) & d.deletedAt.isNull())
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    final entries = await _dictionary.byHskLevel(level);
    if (entries.isEmpty) return null;
    return _db.transaction(() async {
      final id = await create('HSK $level', 'Từ vựng HSK $level',
          hskLevel: level);
      await _cards.insertAll(id, entries.map(CardDraft.fromEntry));
      return id;
    });
  }

  static Deck _deck(QueryRow r) => Deck(
        id: r.read<String>('id'),
        name: r.read<String>('name'),
        description: r.read<String>('description'),
        hskLevel: r.readNullable<int>('hsk_level'),
        cardCount: r.read<int>('card_count'),
        dueCount: r.read<int>('due_count'),
      );
}
