import 'package:doanmonhoc_hanzi/app.dart';
import 'package:doanmonhoc_hanzi/data/db/app_database.dart';
import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// HanziApp on in-memory databases.
///
/// The app DB is deliberately not closed: drift's stream cleanup waits on a
/// timer that FakeAsync never fires once the test body ends, so `close()`
/// in a tearDown hangs forever. An in-memory DB dies with the test process.
HanziApp testApp([DictionaryDatabase? dict]) => HanziApp(
      openDictionary: (_) async =>
          dict ?? DictionaryDatabase(NativeDatabase.memory()),
      openAppDatabase: () => AppDatabase(NativeDatabase.memory()),
    );

/// testWidgets that unmounts the app at the end and pumps once more, so
/// cubits cancel their drift streams and drift's zero-length cleanup timer
/// fires (otherwise: "A Timer is still pending after the tree was disposed").
void testAppWidgets(String name, WidgetTesterCallback body) =>
    testWidgets(name, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      // Cancelling reaches drift a few microtasks later; let its timer run.
      for (var i = 0; i < 3; i++) {
        await tester.pump(const Duration(milliseconds: 10));
      }
    });
