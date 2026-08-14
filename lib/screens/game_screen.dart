import 'package:flutter/material.dart';

import '../data/levels.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../services/geometry.dart';
import '../services/progress.dart';
import '../theme/palette.dart';
import '../widgets/flower_board.dart';

class GameScreen extends StatefulWidget {
  static const route = '/game';
  final int levelId;
  const GameScreen({super.key, required this.levelId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final Level _level = levelById(widget.levelId);
  late final GameState _state = GameState(_level);
  Map<int, List<int>>? _hint;
  bool _solvedShown = false;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_state.isSolved && !_solvedShown) {
      _solvedShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showWinDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_level.name),
        actions: [
          IconButton(
            tooltip: '提示',
            onPressed: _toggleHint,
            icon: Icon(
              _hint == null
                  ? Icons.lightbulb_outline
                  : Icons.lightbulb,
            ),
          ),
          IconButton(
            tooltip: '撤销',
            onPressed: _state.undo,
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            tooltip: '重来',
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: _ProgressChips(state: _state, level: _level),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: FlowerBoard(state: _state, hint: _hint),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reset() {
    setState(() => _hint = null);
    _solvedShown = false;
    _state.reset();
  }

  void _toggleHint() {
    setState(() {
      if (_hint == null) {
        _hint = {
          for (var g = 0; g < _level.groups.length; g++)
            if (!_state.isGroupComplete(g))
              g: solveNonCrossingPath(_level.groups[g].points) ?? const [],
        };
      } else {
        _hint = null;
      }
    });
  }

  Future<void> _showWinDialog() async {
    // 通关即记录进度（解锁下一关）。
    await ProgressService.instance.completeLevel(_level.id, levels.length);

    final hasNext = _level.id < levels.length;
    if (!mounted) return;

    final choice = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: Palette.flowers[3]),
            const SizedBox(width: 8),
            const Text('过关啦！'),
          ],
        ),
        content: Text(
          hasNext ? '你连起了所有颜色的花。' : '恭喜，你已通关全部关卡！',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 0),
            child: const Text('重玩'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 1),
            child: const Text('返回选关'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 2),
            child: Text(hasNext ? '下一关' : '完成'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    switch (choice) {
      case 0:
        _reset();
        break;
      case 1:
        Navigator.pop(context);
        break;
      case 2:
        if (hasNext) {
          Navigator.pushReplacementNamed(
            context,
            GameScreen.route,
            arguments: _level.id + 1,
          );
        } else {
          Navigator.pop(context);
        }
        break;
    }
  }
}

class _ProgressChips extends StatelessWidget {
  const _ProgressChips({required this.state, required this.level});

  final GameState state;
  final Level level;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            for (var g = 0; g < level.groups.length; g++)
              Chip(
                visualDensity: VisualDensity.compact,
                avatar: CircleAvatar(
                  backgroundColor:
                      Palette.flowers[level.groups[g].colorIndex],
                ),
                label: Text(
                  '${state.pathOf(g).length}/${level.groups[g].points.length}',
                  style: const TextStyle(color: Palette.ink),
                ),
              ),
          ],
        );
      },
    );
  }
}