import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const _seed = Color(0xFFC62828); // đỏ son, hợp chủ đề chữ Hán

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
  );
}
