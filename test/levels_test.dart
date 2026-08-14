import 'package:flutter_test/flutter_test.dart';
import 'package:one_stroke_flower_field/data/levels.dart';
import 'package:one_stroke_flower_field/services/geometry.dart';
import 'package:one_stroke_flower_field/theme/palette.dart';

void main() {
  test('每个关卡每种颜色都存在不交叉的一笔画解', () {
    for (final level in levels) {
      for (final group in level.groups) {
        final order = solveNonCrossingPath(group.points);
        expect(
          order,
          isNotNull,
          reason: '关卡 ${level.id} 颜色 ${group.colorIndex} 无解',
        );
        expect(order!.length, group.points.length);
        expect(isNonCrossingPath(group.points, order), isTrue);
      }
    }
  });

  test('颜色索引不越界', () {
    for (final level in levels) {
      for (final group in level.groups) {
        expect(
          group.colorIndex,
          inInclusiveRange(0, Palette.flowers.length - 1),
        );
      }
    }
  });
}