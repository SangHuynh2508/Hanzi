import 'dart:io';
import 'dart:typed_data';

import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('copyWithProgress writes every byte and reports progress up to 1.0',
      () async {
    final dir = await Directory.systemTemp.createTemp('hanzi_copy');
    addTearDown(() => dir.delete(recursive: true));
    final bytes = Uint8List.fromList(List.generate(10000, (i) => i % 251));
    final target = File('${dir.path}/out.sqlite');
    final progress = <double>[];

    await copyWithProgress(bytes, target, progress.add, chunkSize: 3000);

    expect(target.readAsBytesSync(), bytes);
    expect(progress, [0.3, 0.6, 0.9, 1.0]);
  });
}
