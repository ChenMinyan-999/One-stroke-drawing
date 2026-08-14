import 'dart:ui' show Offset;

/// 线段相交判定（含共线重叠视为相交，共享端点不算相交）。
bool segmentsCross(Offset a, Offset b, Offset c, Offset d) {
  // 共享端点：一笔画中相邻线段天然共用端点，不应判为交叉。
  if (a == c || a == d || b == c || b == d) return false;

  final o1 = _orient(a, b, c);
  final o2 = _orient(a, b, d);
  final o3 = _orient(c, d, a);
  final o4 = _orient(c, d, b);

  // 一般情况：跨立。
  if (o1 != o2 && o3 != o4) return true;

  // 共线且重叠。
  if (o1 == 0 && _onSegment(a, b, c)) return true;
  if (o2 == 0 && _onSegment(a, b, d)) return true;
  if (o3 == 0 && _onSegment(c, d, a)) return true;
  if (o4 == 0 && _onSegment(c, d, b)) return true;

  return false;
}

/// 计算点集的一条不交叉哈密顿路径（一笔连线顺序）。
/// 返回点的索引顺序，若不存在则返回 null。
/// 仅用于小规模点集（<= 8），暴力枚举全排列。
List<int>? solveNonCrossingPath(List<Offset> points) {
  final n = points.length;
  if (n == 0) return const [];
  if (n == 1) return const [0];

  final indices = List<int>.generate(n, (i) => i);
  for (final order in _permutations(indices)) {
    if (isNonCrossingPath(points, order)) return order;
  }
  return null;
}

/// 给定点与顺序，判断该顺序连线是否全程不交叉。
bool isNonCrossingPath(List<Offset> points, List<int> order) {
  final segs = <(Offset, Offset)>[];
  for (var i = 0; i < order.length - 1; i++) {
    segs.add((points[order[i]], points[order[i + 1]]));
  }
  for (var i = 0; i < segs.length; i++) {
    for (var j = i + 1; j < segs.length; j++) {
      if (segmentsCross(segs[i].$1, segs[i].$2, segs[j].$1, segs[j].$2)) {
        return false;
      }
    }
  }
  return true;
}

/// 计算点集的一条不交叉哈密顿回路（首尾相连的一笔闭环顺序）。
/// 返回点的索引顺序，顺序中相邻点依次连线且最后一点连回第一点；不存在则返回 null。
/// 仅用于小规模点集（<= 8），暴力枚举全排列。
List<int>? solveNonCrossingCycle(List<Offset> points) {
  final n = points.length;
  if (n == 0) return const [];
  if (n == 1) return const [0];
  if (n == 2) return null; // 两点闭环退化为同一线段。

  final indices = List<int>.generate(n, (i) => i);
  for (final order in _permutations(indices)) {
    if (isNonCrossingCycle(points, order)) return order;
  }
  return null;
}

/// 给定点与顺序，判断该顺序连成的闭环（含最后一点连回第一点）是否全程不交叉。
bool isNonCrossingCycle(List<Offset> points, List<int> order) {
  final n = order.length;
  if (n == 0) return true;
  if (n == 1) return true;
  if (n == 2) return false;

  final segs = <(Offset, Offset)>[];
  for (var i = 0; i < n; i++) {
    segs.add((points[order[i]], points[order[(i + 1) % n]]));
  }
  for (var i = 0; i < segs.length; i++) {
    for (var j = i + 1; j < segs.length; j++) {
      if (segmentsCross(segs[i].$1, segs[i].$2, segs[j].$1, segs[j].$2)) {
        return false;
      }
    }
  }
  return true;
}

/// 0 共线、1 逆时针、2 顺时针。
int _orient(Offset a, Offset b, Offset c) {
  final v =
      (b.dx - a.dx) * (c.dy - a.dy) - (b.dy - a.dy) * (c.dx - a.dx);
  if (v.abs() < _eps) return 0;
  return v > 0 ? 1 : 2;
}

bool _onSegment(Offset a, Offset b, Offset c) {
  final minX = a.dx < b.dx ? a.dx : b.dx;
  final maxX = a.dx > b.dx ? a.dx : b.dx;
  final minY = a.dy < b.dy ? a.dy : b.dy;
  final maxY = a.dy > b.dy ? a.dy : b.dy;
  return c.dx >= minX - _eps &&
      c.dx <= maxX + _eps &&
      c.dy >= minY - _eps &&
      c.dy <= maxY + _eps;
}

const double _eps = 1e-9;

List<List<int>> _permutations(List<int> items) {
  final result = <List<int>>[];

  void permute(int k) {
    if (k == items.length) {
      result.add(List.of(items));
      return;
    }
    for (var i = k; i < items.length; i++) {
      final tmp = items[k];
      items[k] = items[i];
      items[i] = tmp;
      permute(k + 1);
      final back = items[k];
      items[k] = items[i];
      items[i] = back;
    }
  }

  permute(0);
  return result;
}