import 'dart:ui' show Offset;

import '../models/level.dart';

/// 关卡数据：纯数组形式存储，坐标归一化到 0..1（板面为竖屏矩形）。
///
/// 设计约束（保证每个颜色都存在不交叉且首尾相连的闭环解）：
/// - 无 [FlowerGroup.edges] 时任意两点可连，单色关沿凸位置外圈连线即解。
/// - 有 [FlowerGroup.edges]（预设道路）时只能沿允许的边连线；这类关卡通过
///   “中心枢纽 / 嵌套环回旋 / 双芯夹缝”等结构提升思考难度，而非单纯增加颜色。
/// - 多色关卡：各组位于互不相交的独立区域。
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
  const Level(
    id: 10,
    name: '一线穿珠',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.14),
        Offset(0.82, 0.40),
        Offset(0.68, 0.82),
        Offset(0.32, 0.82),
        Offset(0.18, 0.40),
        Offset(0.50, 0.50),
      ], edges: [
        (0, 1), (1, 2), (2, 3), (3, 4), (4, 0), (0, 5), (4, 5),
      ]),
    ],
  ),
  const Level(
    id: 11,
    name: '六芒枢纽',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.10),
        Offset(0.84, 0.30),
        Offset(0.84, 0.66),
        Offset(0.50, 0.86),
        Offset(0.16, 0.66),
        Offset(0.16, 0.30),
        Offset(0.50, 0.48),
      ], edges: [
        (0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 0), (0, 6), (1, 6),
      ]),
    ],
  ),
  const Level(
    id: 12,
    name: '回旋双环',
    groups: [
      FlowerGroup(0, [
        Offset(0.18, 0.18),
        Offset(0.82, 0.18),
        Offset(0.82, 0.82),
        Offset(0.18, 0.82),
        Offset(0.36, 0.36),
        Offset(0.64, 0.36),
        Offset(0.64, 0.64),
        Offset(0.36, 0.64),
      ], edges: [
        (0, 1), (1, 2), (2, 3), (3, 0),
        (4, 5), (5, 6), (6, 7), (7, 4),
        (0, 4), (1, 5), (2, 6), (3, 7),
      ]),
    ],
  ),
  const Level(
    id: 13,
    name: '五角内芯',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.10),
        Offset(0.88, 0.38),
        Offset(0.74, 0.86),
        Offset(0.26, 0.86),
        Offset(0.12, 0.38),
        Offset(0.50, 0.46),
        Offset(0.64, 0.66),
        Offset(0.36, 0.66),
      ], edges: [
        (0, 1), (1, 2), (2, 3), (3, 4), (4, 0),
        (5, 6), (6, 7), (7, 5),
        (0, 5), (4, 7),
      ]),
    ],
  ),
  const Level(
    id: 14,
    name: '双枢并蒂',
    groups: [
      FlowerGroup(0, [
        Offset(0.28, 0.08),
        Offset(0.52, 0.16),
        Offset(0.52, 0.40),
        Offset(0.28, 0.48),
        Offset(0.04, 0.40),
        Offset(0.04, 0.16),
        Offset(0.28, 0.28),
      ], edges: [
        (0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 0), (0, 6), (1, 6),
      ]),
      FlowerGroup(1, [
        Offset(0.72, 0.52),
        Offset(0.96, 0.60),
        Offset(0.96, 0.84),
        Offset(0.72, 0.92),
        Offset(0.48, 0.84),
        Offset(0.48, 0.60),
        Offset(0.72, 0.72),
      ], edges: [
        (0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 0), (0, 6), (1, 6),
      ]),
    ],
  ),
  const Level(
    id: 15,
    name: '双芯迷宫',
    groups: [
      FlowerGroup(0, [
        Offset(0.50, 0.10),
        Offset(0.85, 0.30),
        Offset(0.85, 0.65),
        Offset(0.50, 0.85),
        Offset(0.15, 0.65),
        Offset(0.15, 0.30),
        Offset(0.42, 0.48),
        Offset(0.58, 0.48),
      ], edges: [
        (0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 0),
        (6, 7),
        (1, 7), (7, 2), (4, 6), (6, 5),
      ]),
    ],
  ),
];

Level levelById(int id) => levels.firstWhere((l) => l.id == id);