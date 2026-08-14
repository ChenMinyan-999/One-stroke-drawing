import 'dart:ui' show Offset;

/// 一组同色花朵，坐标为归一化值（0..1），渲染时再映射到画布尺寸。
class FlowerGroup {
  /// 对应 [Palette.flowers] 的索引。
  final int colorIndex;

  /// 该颜色下所有花朵的归一化坐标。
  final List<Offset> points;

  /// 预设道路：允许直接相连的点索引对。为 null 时表示任意两点都可相连。
  final List<(int, int)>? edges;

  const FlowerGroup(this.colorIndex, this.points, {this.edges});

  /// 判断点 [a]、[b] 之间是否存在预设道路（无预设道路时为任意相连）。
  bool allowsEdge(int a, int b) {
    final e = edges;
    if (e == null) return true;
    for (final (i, j) in e) {
      if ((i == a && j == b) || (i == b && j == a)) return true;
    }
    return false;
  }
}

class Level {
  final int id;
  final String name;

  /// 一关包含若干组颜色，通关需把每组颜色都用一笔连完。
  final List<FlowerGroup> groups;

  const Level({required this.id, required this.name, required this.groups});

  int get colorCount => groups.length;
}