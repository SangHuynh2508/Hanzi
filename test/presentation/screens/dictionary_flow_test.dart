import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/sample_dictionary.dart';
import '../../helpers/test_app.dart';

void main() {
  late DictionaryDatabase db;
  setUp(() async => db = await openSampleDictionary());
  tearDown(() => db.close());

  Future<void> search(WidgetTester tester, String q) async {
    await tester.enterText(find.byType(TextField), q);
    await tester.pump(const Duration(milliseconds: 350)); // debounce
    await tester.pumpAndSettle();
  }

  testAppWidgets('search by pinyin, open the word, see its characters',
      (tester) async {
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tra từ'));
    await tester.pumpAndSettle();

    await search(tester, 'xuesheng');
    expect(find.text('学生'), findsOneWidget);

    await tester.tap(find.text('学生'));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết từ'), findsOneWidget);
    expect(find.text('Hán-Việt: HỌC SINH'), findsOneWidget);
    expect(find.text('学'), findsOneWidget);
    expect(find.text('生'), findsOneWidget);
  });

  testAppWidgets('no match shows "Không tìm thấy"', (tester) async {
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tra từ'));
    await tester.pumpAndSettle();

    await search(tester, 'zzzz');
    expect(find.text('Không tìm thấy'), findsOneWidget);
  });
}
