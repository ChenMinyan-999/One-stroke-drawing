import 'dart:ui' show Offset;

import 'package:flutter/foundation.dart';

import '../models/level.dart';
import '../services/geometry.dart';

/// 一局游戏的运行时状态。
///
/// 交互模型：每组颜色是一条“一笔路径”，可跨多次手势继续，但每次都必须从
/// 当前路径的“头部”（最后一个花朵）接续；一次手势内只能连同一颜色的花。
class GameState extends ChangeNotifier {
  GameState(this.level) : _paths = List.generate(level.groups.length, (_) => <int>[]);

  final Level level;

  /// 每组颜色已访问花朵的索引顺序。
  final List<List<int>> _paths;

  /// 记录每次“落点”，用于撤销。
  final List<(int, int)> _moves = [];

  int _activeGroup = -1;
  Offset? _dragPos;

  List<int> pathOf(int group) => _paths[group];

  bool isGroupComplete(int group) =>
      _paths[group].length == level.groups[group].points.length;

  bool get isSolved {
    for (var g = 0; g < level.groups.length; g++) {
      if (!isGroupComplete(g)) return false;
    }
    return true;
  }

  int get activeGroup => _activeGroup;

  int? get headPoint => _activeGroup < 0 || _paths[_activeGroup].isEmpty
      ? null
      : _paths[_activeGroup].last;

  Offset? get dragPos => _dragPos;

  /// 当前是否有一笔正在进行。
  bool get hasActive => _activeGroup >= 0;

  /// 尝试开始/接续一笔。只有空路径或触碰到当前头部才允许。
  bool beginStroke(int group, int point) {
    if (isGroupComplete(group)) return false;

    final path = _paths[group];
    if (path.isEmpty) {
      path.add(point);
      _moves.add((group, point));
      _activeGroup = group;
      _dragPos = level.groups[group].points[point];
      notifyListeners();
      return true;
    }
    if (path.last == point) {
      _activeGroup = group;
      _dragPos = level.groups[group].points[point];
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 拖动中尝试吸附到下一个未访问花朵。若新线段会交叉则拒绝。
  bool tryExtend(int group, int point) {
    if (group != _activeGroup) return false;

    final path = _paths[group];
    if (path.isEmpty || path.contains(point)) return false;

    final points = level.groups[group].points;
    final from = points[path.last];
    final to = points[point];
    if (wouldCross(from, to)) return false;

    path.add(point);
    _moves.add((group, point));
    notifyListeners();
    return true;
  }

  void updateDrag(Offset normalized) {
    _dragPos = normalized;
    notifyListeners();
  }

  void endStroke() {
    _activeGroup = -1;
    _dragPos = null;
    notifyListeners();
  }

  /// 撤销最后一次落点（可能来自任意颜色）。
  void undo() {
    if (_moves.isEmpty) return;
    final (group, point) = _moves.removeLast();
    final path = _paths[group];
    if (path.isNotEmpty && path.last == point) {
      path.removeLast();
    }
    _activeGroup = -1;
    _dragPos = null;
    notifyListeners();
  }

  void reset() {
    for (final path in _paths) {
      path.clear();
    }
    _moves.clear();
    _activeGroup = -1;
    _dragPos = null;
    notifyListeners();
  }

  /// 新线段是否会与已画线段相交。
  bool wouldCross(Offset a, Offset b) {
    for (final seg in allSegments()) {
      if (segmentsCross(a, b, seg.$1, seg.$2)) return true;
    }
    return false;
  }

  List<(Offset, Offset)> allSegments() {
    final segs = <(Offset, Offset)>[];
    for (var g = 0; g < level.groups.length; g++) {
      final points = level.groups[g].points;
      final path = _paths[g];
      for (var i = 0; i < path.length - 1; i++) {
        segs.add((points[path[i]], points[path[i + 1]]));
      }
    }
    return segs;
  }
}