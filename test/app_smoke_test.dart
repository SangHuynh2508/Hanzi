import 'package:flutter_test/flutter_test.dart';
import 'package:doanmonhoc_hanzi/presentation/screens/decks/deck_list_screen.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/test_app.dart';

Future<void> pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(testApp());
  await tester.pumpAndSettle();
}

void main() {
  testAppWidgets('opens on Trang chủ and switches tabs', (tester) async {
    await pumpAt(tester, const Size(411, 891));
    expect(find.widgetWithText(AppBar, 'Trang chủ'), findsOneWidget);

    await tester.tap(find.text('Bộ từ'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Bộ từ'), findsOneWidget);

    await tester.tap(find.text('Trang chủ'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Trang chủ'), findsOneWidget);
    // StatefulShellRoute keeps the visited tab alive offstage.
    expect(find.byType(DeckListScreen, skipOffstage: false), findsOneWidget);
  });

  testAppWidgets('phone width uses NavigationBar', (tester) async {
    await pumpAt(tester, const Size(411, 891));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testAppWidgets('wide screen uses NavigationRail', (tester) async {
    await pumpAt(tester, const Size(800, 1280));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
