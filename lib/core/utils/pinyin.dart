// Pinyin helpers: numbered <-> tone marks, plain form for search, and the
// answer checker for the "gõ pinyin" review mode.

const _marks = {
  'a': ['ā', 'á', 'ǎ', 'à'],
  'e': ['ē', 'é', 'ě', 'è'],
  'i': ['ī', 'í', 'ǐ', 'ì'],
  'o': ['ō', 'ó', 'ǒ', 'ò'],
  'u': ['ū', 'ú', 'ǔ', 'ù'],
  'ü': ['ǖ', 'ǘ', 'ǚ', 'ǜ'],
};

/// Marked vowel (lowercase) -> (base vowel, tone 1..4).
final Map<String, (String, int)> _unmark = {
  for (final e in _marks.entries)
    for (var t = 0; t < 4; t++) e.value[t]: (e.key, t + 1),
};

final _syllable = RegExp(r"([a-zA-ZüÜ:]+)([0-5])?");

/// "xue2 sheng1" -> "xué shēng", "lv4" / "lu:4" -> "lǜ", "ma5" -> "ma".
String numberedToMarked(String s) {
  return s.replaceAllMapped(_syllable, (m) {
    var syl = m[1]!;
    final tone = int.tryParse(m[2] ?? '') ?? 0;
    final capital = syl[0] != syl[0].toLowerCase();
    syl = syl.toLowerCase().replaceAll('u:', 'ü').replaceAll('v', 'ü');
    if (tone >= 1 && tone <= 4) syl = _placeMark(syl, tone);
    return capital ? syl[0].toUpperCase() + syl.substring(1) : syl;
  });
}

/// Standard rule: a or e takes the mark; in "ou" the o does; otherwise the
/// last vowel (so "gui" -> guì, "liu" -> liú).
String _placeMark(String syl, int tone) {
  int idx;
  if (syl.contains('a')) {
    idx = syl.indexOf('a');
  } else if (syl.contains('e')) {
    idx = syl.indexOf('e');
  } else if (syl.contains('ou')) {
    idx = syl.indexOf('o');
  } else {
    idx = syl.split('').lastIndexWhere(_marks.containsKey);
    if (idx < 0) return syl;
  }
  return syl.substring(0, idx) + _marks[syl[idx]]![tone - 1] + syl.substring(idx + 1);
}

/// Base letters only, for search and comparison: "Xué Shēng" / "xue2 sheng1"
/// -> "xuesheng", "lǜ" / "lu:4" -> "lv".
String toPlain(String s) => _split(s).base;

enum PinyinMatch { exact, wrongTone, wrong }

/// Checks a typed answer (numbered, marked, or toneless; any case/spacing)
/// against the expected marked pinyin.
PinyinMatch comparePinyin(String input, String expectedMarked) {
  final got = _split(input);
  final want = _split(expectedMarked);
  if (got.base.isEmpty || got.base != want.base) return PinyinMatch.wrong;
  return _sameTones(got.tones, want.tones)
      ? PinyinMatch.exact
      : PinyinMatch.wrongTone;
}

bool _sameTones(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Splits pinyin into its base letters (ü written as v) and the tones 1..4 in
/// order of appearance. Neutral tone (5, 0 or no mark) contributes no tone.
({String base, List<int> tones}) _split(String s) {
  final base = StringBuffer();
  final tones = <int>[];
  final lower = s.toLowerCase().replaceAll('u:', 'ü');
  for (final ch in lower.split('')) {
    final unmarked = _unmark[ch];
    if (unmarked != null) {
      base.write(unmarked.$1 == 'ü' ? 'v' : unmarked.$1);
      tones.add(unmarked.$2);
    } else if (ch == 'ü') {
      base.write('v');
    } else if ('1234'.contains(ch)) {
      tones.add(int.parse(ch));
    } else if (RegExp('[a-z]').hasMatch(ch)) {
      base.write(ch);
    }
    // spaces, apostrophes, 0, 5 and anything else are dropped
  }
  return (base: base.toString(), tones: tones);
}
