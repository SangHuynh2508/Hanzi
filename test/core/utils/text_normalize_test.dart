import 'dart:convert';
import 'dart:io';

import 'package:doanmonhoc_hanzi/core/utils/text_normalize.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeVi (shared samples)', () {
    final samples = (jsonDecode(
      File('test/fixtures/normalize_samples.json').readAsStringSync(),
    )['normalize_vi'] as List);
    for (final s in samples) {
      test('"${s[0]}" -> "${s[1]}"', () {
        expect(normalizeVi(s[0] as String), s[1]);
      });
    }
  });

  group('containsHanzi', () {
    test('学生 has hanzi', () => expect(containsHanzi('学生'), isTrue));
    test('xue has none', () => expect(containsHanzi('xue'), isFalse));
    test('mixed 学a has hanzi', () => expect(containsHanzi('学a'), isTrue));
    test('extension A 㐀 counts', () => expect(containsHanzi('㐀'), isTrue));
    test('Vietnamese học has none', () => expect(containsHanzi('học'), isFalse));
  });
}
