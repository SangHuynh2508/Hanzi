import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/sample_dictionary.dart';
import '../../helpers/test_app.dart';

void main() {
  late DictionaryDatabase db;
  setUp(() async => db = await openSampleDictionary());
  tearDown(() => db.close());

  testAppWidgets('add HSK 1 deck, swipe a card away, undo', (tester) async {
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bộ từ'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chưa có bộ từ nào'), findsOneWidget);

    await tester.tap(find.text('Tạo bộ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HSK 1'));
    await tester.pumpAndSettle();

    // Lands on the new deck.
    expect(find.text('20 thẻ · 20 đến hạn'), findsOneWidget);
    expect(find.text('学生'), findsOneWidget);

    await tester.drag(find.text('学生'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('学生'), findsNothing);
    expect(find.text('19 thẻ · 19 đến hạn'), findsOneWidget);
    // The FAB must move up, not cover the snackbar's Hoàn tác button.
    expect(tester.getRect(find.byType(FloatingActionButton)).bottom,
        lessThanOrEqualTo(tester.getRect(find.byType(SnackBar)).top));

    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(find.text('学生'), findsOneWidget);
    expect(find.text('20 thẻ · 20 đến hạn'), findsOneWidget);
  });

  testAppWidgets('new card form rejects empty fields', (tester) async {
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bộ từ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tạo bộ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HSK 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Thêm thẻ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu thẻ'));
    await tester.pumpAndSettle();
    expect(find.text('Nhập chữ Hán'), findsOneWidget);
    expect(find.text('Nhập nghĩa'), findsOneWidget);
  });
}
