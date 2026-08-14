import 'dart:ui' show Offset;

/// 一组同色花朵，坐标为归一化值（0..1），渲染时再映射到画布尺寸。
class FlowerGroup {
  /// 对应 [Palette.flowers] 的索引。
  final int colorIndex;

  /// 该颜色下所有花朵的归一化坐标。
  final List<Offset> points;

  const FlowerGroup(this.colorIndex, this.points);
}

class Level {
  final int id;
  final String name;

  /// 一关包含若干组颜色，通关需把每组颜色都用一笔连完。
  final List<FlowerGroup> groups;

  const Level({required this.id, required this.name, required this.groups});

  int get colorCount => groups.length;
}