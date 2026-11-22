// Dart has no built-in Unicode NFD, so accents are mapped by table.
// tools/build_dictionary.py must produce the same output; both sides are
// checked against test/fixtures/normalize_samples.json.

const _viGroups = {
  'a': 'àáạảãâầấậẩẫăằắặẳẵ',
  'e': 'èéẹẻẽêềếệểễ',
  'i': 'ìíịỉĩ',
  'o': 'òóọỏõôồốộổỗơờớợởỡ',
  'u': 'ùúụủũưừứựửữ',
  'y': 'ỳýỵỷỹ',
  'd': 'đ',
};

final Map<String, String> _viMap = {
  for (final e in _viGroups.entries)
    for (final ch in e.value.split('')) ch: e.key,
};

/// "Học Sinh" -> "hoc sinh", "ĐẠI" -> "dai"; collapses whitespace.
String normalizeVi(String s) {
  final lower = s.toLowerCase();
  final buf = StringBuffer();
  for (final ch in lower.split('')) {
    buf.write(_viMap[ch] ?? ch);
  }
  return buf.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
}

final _hanzi = RegExp(r'[㐀-䶿一-鿿]');

bool containsHanzi(String s) => _hanzi.hasMatch(s);
