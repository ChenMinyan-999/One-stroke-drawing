import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 关卡进度：记录已解锁的最大关卡与已完成关卡集合。
/// 单例使用，读取后通过 [load] 初始化。
class ProgressService extends ChangeNotifier {
  ProgressService._();

  static final ProgressService instance = ProgressService._();

  static const _kHighestUnlocked = 'highest_unlocked';
  static const _kCompleted = 'completed_levels';

  int highestUnlocked = 1;
  Set<int> completed = {};

  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    highestUnlocked = prefs.getInt(_kHighestUnlocked) ?? 1;
    completed = (prefs.getStringList(_kCompleted) ?? const [])
        .map(int.parse)
        .toSet();
    _loaded = true;
    notifyListeners();
  }

  bool isUnlocked(int levelId) => levelId <= highestUnlocked;

  bool isCompleted(int levelId) => completed.contains(levelId);

  Future<void> completeLevel(int levelId, int totalLevels) async {
    completed.add(levelId);
    if (levelId >= highestUnlocked && levelId < totalLevels) {
      highestUnlocked = levelId + 1;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kHighestUnlocked, highestUnlocked);
    await prefs.setStringList(
      _kCompleted,
      completed.map((e) => e.toString()).toList()..sort(),
    );
  }

  Future<void> resetAll() async {
    completed = {};
    highestUnlocked = 1;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kHighestUnlocked);
    await prefs.remove(_kCompleted);
  }
}