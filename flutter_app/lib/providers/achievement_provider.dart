import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int targetValue;
  final int currentValue;
  final bool isUnlocked;
  final int coinsReward;
  final Color bgColor;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.targetValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    required this.coinsReward,
    this.bgColor = const Color(0xFFFFE5E0),
  });

  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);
  bool get canUnlock => currentValue >= targetValue && !isUnlocked;
}

class AchievementProvider extends ChangeNotifier {
  final List<Achievement> _achievements = [
    const Achievement(
      id: 'streak_7',
      name: '连续7天',
      description: '坚持使用一周',
      emoji: '🔥',
      targetValue: 7,
      coinsReward: 100,
      bgColor: Color(0xFFFFE5E0),
    ),
    const Achievement(
      id: 'water_8',
      name: '喝水达人',
      description: '单日喝满8杯水',
      emoji: '💧',
      targetValue: 8,
      coinsReward: 50,
      bgColor: Color(0xFFD4ECFF),
    ),
    const Achievement(
      id: 'balance_3',
      name: '营养均衡',
      description: '连续3天均衡饮食',
      emoji: '🎯',
      targetValue: 3,
      coinsReward: 80,
      bgColor: Color(0xFFE8F5E8),
    ),
    const Achievement(
      id: 'fasting_5',
      name: '断食达人',
      description: '完成5次断食',
      emoji: '⏰',
      targetValue: 5,
      coinsReward: 120,
      bgColor: Color(0xFFF4E8FF),
    ),
    const Achievement(
      id: 'pet_level_10',
      name: '小熊进化',
      description: '小熊达到10级',
      emoji: '⭐',
      targetValue: 10,
      coinsReward: 200,
      bgColor: Color(0xFFFFD93D),
    ),
    const Achievement(
      id: 'calorie_deficit',
      name: '热量赤字',
      description: '累计减少10000卡路里',
      emoji: '📉',
      targetValue: 10000,
      coinsReward: 150,
      bgColor: Color(0xFFFFE5E0),
    ),
    const Achievement(
      id: 'perfect_week',
      name: '完美一周',
      description: '7天内每天都达成目标',
      emoji: '🏆',
      targetValue: 7,
      coinsReward: 300,
      bgColor: Color(0xFFFFD93D),
    ),
  ];

  List<Achievement> get achievements => List.unmodifiable(_achievements);
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();
  List<Achievement> get inProgressAchievements =>
      _achievements.where((a) => !a.isUnlocked && a.currentValue > 0).toList();

  int get totalCoinsEarned =>
      unlockedAchievements.fold(0, (sum, a) => sum + a.coinsReward);

  void updateProgress(String achievementId, int newValue) {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index == -1) return;

    final achievement = _achievements[index];
    if (achievement.isUnlocked) return;

    _achievements[index] = Achievement(
      id: achievement.id,
      name: achievement.name,
      description: achievement.description,
      emoji: achievement.emoji,
      targetValue: achievement.targetValue,
      currentValue: newValue,
      isUnlocked: newValue >= achievement.targetValue,
      coinsReward: achievement.coinsReward,
      bgColor: achievement.bgColor,
    );

    notifyListeners();
  }

  void incrementProgress(String achievementId, {int by = 1}) {
    final achievement = _achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => throw Exception('Achievement not found'),
    );
    updateProgress(achievementId, achievement.currentValue + by);
  }

  List<Achievement> checkAndUnlock() {
    final newlyUnlocked = <Achievement>[];
    for (int i = 0; i < _achievements.length; i++) {
      final a = _achievements[i];
      if (a.canUnlock) {
        _achievements[i] = Achievement(
          id: a.id,
          name: a.name,
          description: a.description,
          emoji: a.emoji,
          targetValue: a.targetValue,
          currentValue: a.currentValue,
          isUnlocked: true,
          coinsReward: a.coinsReward,
          bgColor: a.bgColor,
        );
        newlyUnlocked.add(_achievements[i]);
      }
    }
    if (newlyUnlocked.isNotEmpty) notifyListeners();
    return newlyUnlocked;
  }
}
