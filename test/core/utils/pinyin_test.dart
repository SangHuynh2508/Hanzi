import 'dart:convert';
import 'dart:io';

import 'package:doanmonhoc_hanzi/core/utils/pinyin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('numberedToMarked', () {
    const cases = {
      'ni3 hao3': 'nǐ hǎo',
      'lv4': 'lǜ',
      'lu:4': 'lǜ',
      'nu:3': 'nǚ',
      'ma5': 'ma',
      'er2': 'ér',
      'xian1': 'xiān', // a wins
      'gui4': 'guì', // "ui": mark the last vowel
      'liu2': 'liú', // "iu": mark the last vowel
      'zhou1': 'zhōu', // "ou": mark o
      'xue2 sheng1': 'xué shēng',
      'Bei3 jing1': 'Běi jīng',
    };
    cases.forEach((input, expected) {
      test('$input -> $expected', () {
        expect(numberedToMarked(input), expected);
      });
    });
  });

  group('toPlain (shared samples)', () {
    final samples = (jsonDecode(
      File('test/fixtures/normalize_samples.json').readAsStringSync(),
    )['to_plain'] as List);
    for (final s in samples) {
      test('${s[0]} -> ${s[1]}', () => expect(toPlain(s[0] as String), s[1]));
    }
  });

  group('comparePinyin against "xué shēng"', () {
    const expected = 'xué shēng';
    const cases = {
      'xue2sheng1': PinyinMatch.exact,
      'xue2 sheng1': PinyinMatch.exact,
      'XUÉ SHĒNG': PinyinMatch.exact,
      'xuéshēng': PinyinMatch.exact,
      'xuesheng': PinyinMatch.wrongTone,
      'xue1sheng1': PinyinMatch.wrongTone,
      'xie2sheng1': PinyinMatch.wrong,
      '': PinyinMatch.wrong,
      '   ': PinyinMatch.wrong,
    };
    cases.forEach((input, match) {
      test('"$input" -> $match', () {
        expect(comparePinyin(input, expected), match);
      });
    });
  });

  group('comparePinyin neutral tone', () {
    for (final input in ['ma', 'ma5', 'ma0', 'MA']) {
      test('"$input" vs "ma" is exact', () {
        expect(comparePinyin(input, 'ma'), PinyinMatch.exact);
      });
    }
    test('"lv4" vs "lǜ" is exact', () {
      expect(comparePinyin('lv4', 'lǜ'), PinyinMatch.exact);
    });
    test('"lu:4" vs "lǜ" is exact', () {
      expect(comparePinyin('lu:4', 'lǜ'), PinyinMatch.exact);
    });
  });
}
