import 'dart:ui' show Offset;

import 'package:flutter_test/flutter_test.dart';
import 'package:one_stroke_flower_field/services/geometry.dart';

void main() {
  test('共享端点不算交叉', () {
    const a = Offset(0, 0);
    const b = Offset(1, 0);
    const c = Offset(1, 1);
    expect(segmentsCross(a, b, b, c), isFalse);
  });

  test('明显交叉', () {
    const a = Offset(0, 0);
    const b = Offset(1, 1);
    const c = Offset(0, 1);
    const d = Offset(1, 0);
    expect(segmentsCross(a, b, c, d), isTrue);
  });

  test('平行不相交', () {
    const a = Offset(0, 0);
    const b = Offset(1, 0);
    const c = Offset(0, 1);
    const d = Offset(1, 1);
    expect(segmentsCross(a, b, c, d), isFalse);
  });

  test('正方形四点存在不交叉解', () {
    const pts = [
      Offset(0, 0),
      Offset(1, 0),
      Offset(1, 1),
      Offset(0, 1),
    ];
    final order = solveNonCrossingPath(pts);
    expect(order, isNotNull);
    expect(order, hasLength(4));
    expect(isNonCrossingPath(pts, order!), isTrue);
  });

  test('退化输入', () {
    expect(solveNonCrossingPath(const []), isEmpty);
    expect(solveNonCrossingPath(const [Offset(0.5, 0.5)]), const [0]);
  });
}