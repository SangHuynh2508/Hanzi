import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// User data (spec §6). Every synced table has updatedAt / deletedAt / dirty
// so SyncService (Dev 2) can push dirty rows and apply last-write-wins.
// Review logs are append-only: no deletedAt, never edited, merged by id.

class Decks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get hskLevel => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text().references(Decks, #id)();
  IntColumn get dictEntryId => integer().nullable()();
  TextColumn get hanzi => text()();
  TextColumn get pinyin => text()();
  TextColumn get hanViet => text()();
  TextColumn get meaning => text()();
  TextColumn get example => text().withDefault(const Constant(''))();
  // FSRS state, mirrors SrsState in lib/data/srs/srs_scheduler.dart.
  IntColumn get srsState => integer()();
  IntColumn get srsStep => integer().nullable()();
  RealColumn get stability => real().nullable()();
  RealColumn get difficulty => real().nullable()();
  DateTimeColumn get due => dateTime()();
  DateTimeColumn get lastReview => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class ReviewLogs extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text().references(Cards, #id)();
  IntColumn get rating => integer()();
  DateTimeColumn get reviewedAt => dateTime()();
  IntColumn get durationMs => integer()();

  /// flip | choice | typing | listening
  TextColumn get mode => text()();
  RealColumn get retrievabilityBefore => real()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single row, id = 1.
class Settings extends Table {
  IntColumn get id => integer()();
  RealColumn get desiredRetention => real().withDefault(const Constant(0.9))();
  IntColumn get newPerDay => integer().withDefault(const Constant(10))();
  IntColumn get reminderMinutes => integer().nullable()();

  /// system | light | dark
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single row, id = 1. Local only, never synced.
class SyncState extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get lastPulledAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Decks, Cards, ReviewLogs, Settings, SyncState])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.open() : super(driftDatabase(name: 'app'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(settings)
              .insert(SettingsCompanion.insert(id: const Value(1)));
          await into(syncState)
              .insert(SyncStateCompanion.insert(id: const Value(1)));
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
