import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Spec: UI must not talk to the database or Firestore directly.
/// screen -> cubit -> repository is the only allowed path.
void main() {
  test('presentation layer never imports data/db or data/remote', () {
    final dir = Directory('lib/presentation');
    expect(dir.existsSync(), isTrue, reason: 'lib/presentation missing');

    final violations = <String>[];
    for (final file in dir.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.startsWith('import') &&
            (line.contains('data/db/') || line.contains('data/remote/'))) {
          violations.add('${file.path}:${i + 1}: $line');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
