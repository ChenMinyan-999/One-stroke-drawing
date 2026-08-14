import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../theme/palette.dart';

/// 花朵画板：绘制草地、连线、花朵，并处理“拖拽吸附”的一笔画手势。
class FlowerBoard extends StatelessWidget {
  const FlowerBoard({super.key, required this.state, this.hint});

  final GameState state;

  /// 提示：每组颜色一条解（点索引顺序），非空时以虚线显示。
  final Map<int, List<int>>? hint;

  static const double _snapRadius = 30;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (d) => _onStart(size, d.localPosition),
          onPanUpdate: (d) => _onUpdate(size, d.localPosition),
          onPanEnd: (_) => state.endStroke(),
          onPanCancel: () => state.endStroke(),
          child: CustomPaint(
            size: size,
            painter: _FlowerBoardPainter(state: state, hint: hint),
          ),
        );
      },
    );
  }

  void _onStart(Size size, Offset local) {
    final hit = _nearestFlower(size, local, allowHead: true);
    if (hit == null) return;
    state.beginStroke(hit.$1, hit.$2);
  }

  void _onUpdate(Size size, Offset local) {
    if (!state.hasActive) return;
    state.updateDrag(_toNormalized(size, local));
    final hit = _nearestFlower(
      size,
      local,
      onlyGroup: state.activeGroup,
      allowClose: true,
    );
    if (hit == null) return;
    if (!state.tryClose(hit.$1, hit.$2)) {
      state.tryExtend(hit.$1, hit.$2);
    }
  }

  /// 命中检测：返回 (颜色组索引, 花朵索引)。
  ///
  /// [onlyGroup] 限定某颜色；[allowHead] 允许命中该组头部（用于接续一笔）；
  /// [allowClose] 允许命中待闭合组的起点（用于首尾相连）。
  (int, int)? _nearestFlower(
    Size size,
    Offset local, {
    int? onlyGroup,
    bool allowHead = false,
    bool allowClose = false,
  }) {
    (int, int)? best;
    var bestDist = _snapRadius;

    for (var g = 0; g < state.level.groups.length; g++) {
      if (onlyGroup != null && g != onlyGroup) continue;

      final points = state.level.groups[g].points;
      final path = state.pathOf(g);

      for (var p = 0; p < points.length; p++) {
        final isHead = path.isNotEmpty && path.last == p;
        final isTail = path.isNotEmpty && path.first == p;
        final isUnvisited = !path.contains(p);

        final selectable = isUnvisited ||
            (allowHead && isHead) ||
            (allowClose && isTail && state.canClose(g));
        if (!selectable) continue;

        final pos = Offset(points[p].dx * size.width, points[p].dy * size.height);
        final dist = (pos - local).distance;
        if (dist <= bestDist) {
          bestDist = dist;
          best = (g, p);
        }
      }
    }
    return best;
  }

  Offset _toNormalized(Size size, Offset local) =>
      Offset(local.dx / size.width, local.dy / size.height);
}

class _FlowerBoardPainter extends CustomPainter {
  _FlowerBoardPainter({required this.state, this.hint}) : super(repaint: state);

  final GameState state;
  final Map<int, List<int>>? hint;

  @override
  void paint(Canvas canvas, Size size) {
    final lineWidth = (size.shortestSide * 0.022).clamp(6.0, 11.0);
    final flowerR = (size.shortestSide * 0.046).clamp(13.0, 22.0);

    _paintBackground(canvas, size);
    _paintRoads(canvas, size, lineWidth);
    _paintHint(canvas, size, lineWidth);
    _paintSegments(canvas, size, lineWidth);
    _paintDragLine(canvas, size, lineWidth);
    _paintFlowers(canvas, size, flowerR);
  }

  void _paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Palette.meadowTop, Palette.meadowBottom],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  /// 绘制预设道路：以淡色虚线展示允许直接相连的点对。
  void _paintRoads(Canvas canvas, Size size, double lineWidth) {
    final level = state.level;
    for (var g = 0; g < level.groups.length; g++) {
      final edges = level.groups[g].edges;
      if (edges == null) continue;

      final points = level.groups[g].points;
      final paint = Paint()
        ..color = Palette.inkSoft.withValues(alpha: 0.45)
        ..strokeWidth = lineWidth * 0.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (final (i, j) in edges) {
        final a = _toPixel(points[i], size);
        final b = _toPixel(points[j], size);
        _drawDashedLine(canvas, a, b, paint);
      }
    }
  }

  void _paintSegments(Canvas canvas, Size size, double lineWidth) {
    final level = state.level;
    for (var g = 0; g < level.groups.length; g++) {
      final points = level.groups[g].points;
      final path = state.pathOf(g);
      final color = Palette.flowers[level.groups[g].colorIndex];
      for (var i = 0; i < path.length - 1; i++) {
        final a = _toPixel(points[path[i]], size);
        final b = _toPixel(points[path[i + 1]], size);
        _drawSegment(canvas, a, b, color, lineWidth);
      }
    }
  }

  void _paintDragLine(Canvas canvas, Size size, double lineWidth) {
    if (!state.hasActive) return;
    final head = state.headPoint;
    final drag = state.dragPos;
    if (head == null || drag == null) return;

    final group = state.activeGroup;
    final color = Palette.flowers[state.level.groups[group].colorIndex];
    final a = _toPixel(state.level.groups[group].points[head], size);
    final b = _toPixel(drag, size);

    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    _drawDashedLine(canvas, a, b, paint);
  }

  void _paintHint(Canvas canvas, Size size, double lineWidth) {
    final h = hint;
    if (h == null || h.isEmpty) return;

    final level = state.level;
    h.forEach((g, order) {
      final points = level.groups[g].points;
      final color = Palette.flowers[level.groups[g].colorIndex];
      final paint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (var i = 0; i < order.length - 1; i++) {
        final a = _toPixel(points[order[i]], size);
        final b = _toPixel(points[order[i + 1]], size);
        _drawDashedLine(canvas, a, b, paint);
      }
      // 首尾相连的闭环段。
      if (order.length >= 3) {
        final a = _toPixel(points[order.last], size);
        final b = _toPixel(points[order.first], size);
        _drawDashedLine(canvas, a, b, paint);
      }
    });
  }

  void _paintFlowers(Canvas canvas, Size size, double flowerR) {
    final level = state.level;
    for (var g = 0; g < level.groups.length; g++) {
      final points = level.groups[g].points;
      final path = state.pathOf(g);
      final color = Palette.flowers[level.groups[g].colorIndex];
      for (var p = 0; p < points.length; p++) {
        final center = _toPixel(points[p], size);
        final visited = path.contains(p);
        final isHead = state.activeGroup == g && state.headPoint == p;
        _drawFlower(
          canvas,
          center,
          flowerR,
          color,
          visited: visited,
          isHead: isHead,
        );
      }
    }
  }

  void _drawSegment(Canvas canvas, Offset a, Offset b, Color color, double w) {
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = Palette.pathShadow
        ..strokeWidth = w + 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = color
        ..strokeWidth = w
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 8.0;
    const gap = 6.0;
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    var t = 0.0;
    while (t < total) {
      final end = math.min(t + dash, total);
      canvas.drawLine(a + dir * t, a + dir * end, paint);
      t += dash + gap;
    }
  }

  void _drawFlower(
    Canvas canvas,
    Offset c,
    double r,
    Color color, {
    required bool visited,
    required bool isHead,
  }) {
    const petalCount = 6;
    final petal = Paint()..color = color;
    for (var i = 0; i < petalCount; i++) {
      final angle = i * 2 * math.pi / petalCount;
      final dir = Offset(math.cos(angle), math.sin(angle));
      canvas.drawCircle(c + dir * (r * 0.7), r * 0.55, petal);
    }

    // 花心：已连接为白色，未连接保持原色。
    canvas.drawCircle(
      c,
      r * 0.55,
      Paint()..color = visited ? Colors.white : color,
    );
    if (visited) {
      canvas.drawCircle(c, r * 0.28, Paint()..color = color);
    }

    // 当前头部：外圈高亮。
    if (isHead) {
      canvas.drawCircle(
        c,
        r * 1.35,
        Paint()
          ..color = color.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }
  }

  Offset _toPixel(Offset normalized, Size size) =>
      Offset(normalized.dx * size.width, normalized.dy * size.height);

  @override
  bool shouldRepaint(covariant _FlowerBoardPainter oldDelegate) => true;
}