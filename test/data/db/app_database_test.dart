import 'package:doanmonhoc_hanzi/data/db/app_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  final t0 = DateTime.utc(2026, 1, 1, 8, 30, 15, 123);

  test('fresh database has default settings and an empty sync state', () async {
    final s = await db.select(db.settings).getSingle();
    expect(s.desiredRetention, 0.9);
    expect(s.newPerDay, 10);
    expect(s.reminderMinutes, isNull);
    expect(s.themeMode, 'system');
    final sync = await db.select(db.syncState).getSingle();
    expect(sync.lastPulledAt, isNull);
  });

  test('deck, card and review log round-trip with UTC times', () async {
    await db.into(db.decks).insert(DecksCompanion.insert(
          id: 'd1', name: 'HSK 1', createdAt: t0, updatedAt: t0));
    await db.into(db.cards).insert(CardsCompanion.insert(
          id: 'c1', deckId: 'd1', hanzi: '学生', pinyin: 'xué shēng',
          hanViet: 'học sinh', meaning: 'học sinh', srsState: 1,
          due: t0, createdAt: t0, updatedAt: t0));
    await db.into(db.reviewLogs).insert(ReviewLogsCompanion.insert(
          id: 'l1', cardId: 'c1', rating: 3, reviewedAt: t0,
          durationMs: 4000, mode: 'flip', retrievabilityBefore: 0));

    final card = await db.select(db.cards).getSingle();
    expect(card.due, t0);
    expect(card.due.isUtc, isTrue, reason: 'UTC must survive storage');
    expect(card.dirty, isTrue, reason: 'new rows must be pushed by sync');
    expect(card.stability, isNull);
    final log = await db.select(db.reviewLogs).getSingle();
    expect(log.reviewedAt.isUtc, isTrue);
    expect(log.dirty, isTrue);
  });

  test('soft-deleted deck keeps its row with deletedAt set', () async {
    await db.into(db.decks).insert(DecksCompanion.insert(
          id: 'd1', name: 'HSK 1', createdAt: t0, updatedAt: t0));
    await (db.update(db.decks)..where((d) => d.id.equals('d1')))
        .write(DecksCompanion(deletedAt: Value(t0)));
    final deck = await db.select(db.decks).getSingle();
    expect(deck.deletedAt, t0);
  });
}
