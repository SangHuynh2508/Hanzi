import 'package:doanmonhoc_hanzi/presentation/widgets/hanzi_breakdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('readableDecomposition drops IDS operators, keeps components', () {
    expect(readableDecomposition('⿱⺍⿱冖子'), '⺍ + 冖 + 子');
    expect(readableDecomposition('⿱𠂉土'), '𠂉 + 土'); // astral char kept whole
    expect(readableDecomposition(''), '');
  });
}
