import 'package:flutter/material.dart';

import '../theme/palette.dart';
import 'level_select_screen.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _FlowerBunch(),
                const SizedBox(height: 28),
                Text(
                  '一笔花田',
                  style: textTheme.displaySmall?.copyWith(
                    color: Palette.ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '一笔连起同色的花 · 首尾相连 · 不交叉 · 不重复',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: Palette.inkSoft),
                ),
                const SizedBox(height: 56),
                FilledButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, LevelSelectScreen.route),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('开始游戏'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(220, 52),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => _showRules(context),
                  icon: const Icon(Icons.help_outline),
                  label: const Text('玩法说明'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(220, 52),
                    foregroundColor: Palette.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRules(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('玩法说明'),
        content: const Text(
          '· 每关有若干种颜色的花。\n'
          '· 从一朵花开始，手指拖到同色的下一朵，一笔连完该色所有花。\n'
          '· 有的关卡两朵花之间只有“预设道路”才能相连，不能凭空搭桥。\n'
          '· 连完所有花后，再拖回起点那朵花，把首尾连起来才算完成。\n'
          '· 抬手指后可以换一种颜色继续；接续时需从上一朵花（发光的那朵）开始。\n'
          '· 连线不能交叉，也不能重复经过同一朵花。\n'
          '· 连完所有颜色即过关。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

class _FlowerBunch extends StatelessWidget {
  const _FlowerBunch();

  @override
  Widget build(BuildContext context) {
    const colors = <Color>[
      Color(0xFFEC4899),
      Color(0xFF3B82F6),
      Color(0xFFF59E0B),
    ];
    const sizes = <double>[56, 40, 56];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < colors.length; i++)
          Transform.rotate(
            angle: (i - 1) * 0.35,
            child: Icon(
              Icons.local_florist_rounded,
              size: sizes[i],
              color: colors[i],
            ),
          ),
      ],
    );
  }
}