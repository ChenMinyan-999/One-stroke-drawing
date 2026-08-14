import 'package:flutter/material.dart';

import '../data/levels.dart';
import '../models/level.dart';
import '../services/progress.dart';
import '../theme/palette.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  static const route = '/levels';
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  @override
  void initState() {
    super.initState();
    ProgressService.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择关卡'),
        actions: [
          IconButton(
            tooltip: '重置进度',
            onPressed: () => _confirmReset(context),
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: ProgressService.instance,
        builder: (context, _) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: levels.length,
            itemBuilder: (context, index) =>
                _LevelCard(level: levels[index]),
          );
        },
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置进度'),
        content: const Text('确定清空所有已解锁与已完成的关卡吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ProgressService.instance.resetAll();
    }
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level});

  final Level level;

  @override
  Widget build(BuildContext context) {
    final progress = ProgressService.instance;
    final unlocked = progress.isUnlocked(level.id);
    final completed = progress.isCompleted(level.id);

    return Material(
      color: unlocked ? Colors.white : Palette.cream,
      borderRadius: BorderRadius.circular(20),
      elevation: unlocked ? 2 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: unlocked
            ? () => Navigator.pushNamed(context, GameScreen.route,
                arguments: level.id)
            : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x22000000), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (completed)
                Icon(
                  Icons.check_circle_rounded,
                  color: Palette.flowers[2],
                  size: 32,
                )
              else if (unlocked)
                Icon(
                  Icons.local_florist_rounded,
                  color: Palette.flowers[(level.id - 1) % Palette.flowers.length],
                  size: 32,
                )
              else
                const Icon(Icons.lock_rounded, color: Palette.inkSoft, size: 30),
              const SizedBox(height: 10),
              Text(
                '第 ${level.id} 关',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                level.name,
                style: const TextStyle(fontSize: 12, color: Palette.inkSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}