import 'package:material_ui/material_ui.dart';

/// "Đã xoá …" with a Hoàn tác button that hides itself after a few seconds.
void showUndoSnackBar(
  ScaffoldMessengerState messenger,
  String message,
  VoidCallback onUndo,
) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      persist: false,
      action: SnackBarAction(label: 'Hoàn tác', onPressed: onUndo),
    ));
}
