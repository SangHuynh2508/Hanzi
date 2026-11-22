import 'dart:async';

import 'package:doanmonhoc_hanzi/app.dart';
import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('splash shows copy progress, then opens Trang chủ',
      (tester) async {
    final release = Completer<void>();
    late void Function(double) report;
    final db = DictionaryDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(HanziApp(openDictionary: (onProgress) async {
      report = onProgress;
      await release.future;
      return db;
    }));

    report(0.5);
    await tester.pump();
    final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator));
    expect(bar.value, 0.5);
    expect(find.text('Trang chủ'), findsNothing);

    report(1.0);
    release.complete();
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Trang chủ'), findsOneWidget);
  });
}
