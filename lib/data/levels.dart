import 'dart:ui' show Offset;

import '../models/level.dart';

/// 关卡数据：纯数组形式存储，坐标归一化到 0..1（板面为竖屏矩形）。
///
/// 设计约束（保证每个颜色都可一笔连完且不交叉）：
/// - 单色关卡：花朵位于凸位置（三角形/四边形/五边形/六边形），沿外圈连线即解。
/// - 多色关卡：各组位于互不相交的独立区域，或一个组严格嵌套在另一个组内部。
final List<Level> levels = [
  const Level(
    id: 1,
    name: '三角初绽',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.30),
        Offset(0.28, 0.72),
        Offset(0.72, 0.72),
      ]),
    ],
  ),
  const Level(
    id: 2,
    name: '四瓣方阵',
    groups: [
      FlowerGroup(0, [
        Offset(0.28, 0.30),
        Offset(0.72, 0.30),
        Offset(0.72, 0.72),
        Offset(0.28, 0.72),
      ]),
    ],
  ),
  const Level(
    id: 3,
    name: '五瓣星环',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.20),
        Offset(0.82, 0.42),
        Offset(0.70, 0.80),
        Offset(0.30, 0.80),
        Offset(0.18, 0.42),
      ]),
    ],
  ),
  const Level(
    id: 4,
    name: '六瓣花冠',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.16),
        Offset(0.79, 0.33),
        Offset(0.79, 0.67),
        Offset(0.50, 0.84),
        Offset(0.21, 0.67),
        Offset(0.21, 0.33),
      ]),
    ],
  ),
  const Level(
    id: 5,
    name: '双色初现',
    groups: [
      FlowerGroup(0, [
        Offset(0.24, 0.32),
        Offset(0.14, 0.60),
        Offset(0.34, 0.60),
      ]),
      FlowerGroup(1, [
        Offset(0.76, 0.40),
        Offset(0.66, 0.68),
        Offset(0.86, 0.68),
      ]),
    ],
  ),
  const Level(
    id: 6,
    name: '同心花环',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.20),
        Offset(0.14, 0.78),
        Offset(0.86, 0.78),
      ]),
      FlowerGroup(1, [
        Offset(0.50, 0.42),
        Offset(0.34, 0.66),
        Offset(0.66, 0.66),
      ]),
    ],
  ),
  const Level(
    id: 7,
    name: '三色田园',
    groups: [
      FlowerGroup(0, [
        Offset(0.34, 0.18),
        Offset(0.50, 0.16),
        Offset(0.42, 0.34),
      ]),
      FlowerGroup(2, [
        Offset(0.62, 0.44),
        Offset(0.78, 0.46),
        Offset(0.70, 0.62),
      ]),
      FlowerGroup(1, [
        Offset(0.30, 0.68),
        Offset(0.46, 0.70),
        Offset(0.38, 0.86),
      ]),
    ],
  ),
  const Level(
    id: 8,
    name: '方中有方',
    groups: [
      FlowerGroup(0, [
        Offset(0.26, 0.24),
        Offset(0.74, 0.24),
        Offset(0.74, 0.76),
        Offset(0.26, 0.76),
      ]),
      FlowerGroup(1, [
        Offset(0.40, 0.40),
        Offset(0.60, 0.40),
        Offset(0.60, 0.60),
        Offset(0.40, 0.60),
      ]),
    ],
  ),
  const Level(
    id: 9,
    name: '四色繁花',
    groups: [
      FlowerGroup(0, [
        Offset(0.22, 0.20),
        Offset(0.14, 0.34),
        Offset(0.30, 0.34),
      ]),
      FlowerGroup(1, [
        Offset(0.78, 0.20),
        Offset(0.70, 0.34),
        Offset(0.86, 0.34),
      ]),
      FlowerGroup(2, [
        Offset(0.22, 0.56),
        Offset(0.14, 0.70),
        Offset(0.30, 0.70),
      ]),
      FlowerGroup(3, [
        Offset(0.78, 0.56),
        Offset(0.70, 0.70),
        Offset(0.86, 0.70),
      ]),
    ],
  ),
];

Level levelById(int id) => levels.firstWhere((l) => l.id == id);