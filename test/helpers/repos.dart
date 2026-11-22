import 'package:doanmonhoc_hanzi/data/db/app_database.dart';
import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:doanmonhoc_hanzi/data/repositories/card_repository.dart';
import 'package:doanmonhoc_hanzi/data/repositories/deck_repository.dart';
import 'package:doanmonhoc_hanzi/data/repositories/dictionary_repository.dart';
import 'package:doanmonhoc_hanzi/data/srs/srs_scheduler.dart';
import 'package:drift/native.dart';

import 'fixed_clock.dart';
import 'sample_dictionary.dart';

/// In-memory app DB + sample dictionary with every repository wired up.
class TestRepos {
  TestRepos._(this.app, this.dict, this.clock)
      : dictionary = DictionaryRepository(dict) {
    cards = CardRepository(app,
        scheduler: SrsScheduler(desiredRetention: 0.9), clock: clock);
    decks = DeckRepository(app,
        cards: cards, dictionary: dictionary, clock: clock);
  }

  static Future<TestRepos> open() async => TestRepos._(
        AppDatabase(NativeDatabase.memory()),
        await openSampleDictionary(),
        FixedClock(DateTime.utc(2026, 11, 22, 10)),
      );

  final AppDatabase app;
  final DictionaryDatabase dict;
  final FixedClock clock;
  final DictionaryRepository dictionary;
  late final CardRepository cards;
  late final DeckRepository decks;

  Future<void> close() async {
    await app.close();
    await dict.close();
  }
}
