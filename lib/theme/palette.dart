import 'package:flutter/material.dart';

/// 全局配色：花朵颜色尽量色觉友好、彼此区分清晰。
abstract final class Palette {
  /// 花朵颜色池（与关卡数据中的 colorIndex 对应）。
  static const List<Color> flowers = [
    Color(0xFFE5434B), // 0 红
    Color(0xFF3B82F6), // 1 蓝
    Color(0xFF22A55B), // 2 绿
    Color(0xFFF59E0B), // 3 橙黄
    Color(0xFF8B5CF6), // 4 紫
    Color(0xFFEC4899), // 5 粉
    Color(0xFF14B8A6), // 6 青
  ];

  static const Color cream = Color(0xFFFDF6EC);
  static const Color meadowTop = Color(0xFFFBF3E4);
  static const Color meadowBottom = Color(0xFFE7F0DC);
  static const Color ink = Color(0xFF3E4A3B);
  static const Color inkSoft = Color(0xFF7A8572);
  static const Color pink = Color(0xFFEC4899);
  static const Color pathShadow = Color(0x33000000);
}