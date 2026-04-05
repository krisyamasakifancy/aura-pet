import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/achievement_provider.dart';
import '../../utils/theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('成就'),
      ),
      body: Consumer<AchievementProvider>(
        builder: (context, achievements, _) {
          final unlocked = achievements.unlockedAchievements;
          final inProgress = achievements.inProgressAchievements;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AuraPetTheme.secondary, Color(0xFFFFE066)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AuraPetTheme.secondary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AuraPetTheme.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🏆', style: TextStyle(fontSize: 30)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${unlocked.length}/${achievements.achievements.length}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF8B6914),
                              ),
                            ),
                            const Text(
                              '已解锁成就',
                              style: TextStyle(
                                color: Color(0xFF8B6914),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 24)),
                          Text(
                            '+${achievements.totalCoinsEarned}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF8B6914),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // In Progress
                if (inProgress.isNotEmpty) ...[
                  const Text(
                    '进行中',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...inProgress.map((a) => _AchievementCard(achievement: a)),
                  const SizedBox(height: 24),
                ],

                // All Achievements
                const Text(
                  '全部成就',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                ...achievements.achievements.map((a) => _AchievementCard(achievement: a)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? AuraPetTheme.white
            : AuraPetTheme.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AuraPetTheme.shadowSm,
        border: achievement.isUnlocked
            ? Border.all(color: AuraPetTheme.secondary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: achievement.bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                achievement.emoji,
                style: TextStyle(
                  fontSize: 28,
                  color: achievement.isUnlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: achievement.isUnlocked
                              ? AuraPetTheme.textDark
                              : AuraPetTheme.textLight,
                        ),
                      ),
                    ),
                    if (achievement.isUnlocked)
                      const Icon(
                        Icons.check_circle,
                        color: AuraPetTheme.accent,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: achievement.isUnlocked
                        ? AuraPetTheme.textLight
                        : AuraPetTheme.textMuted,
                  ),
                ),
                if (!achievement.isUnlocked) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: achievement.progress,
                      backgroundColor: achievement.bgColor.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        achievement.bgColor.withValues(alpha: 0.8),
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${achievement.currentValue} / ${achievement.targetValue}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AuraPetTheme.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Reward
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AuraPetTheme.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${achievement.coinsReward}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8B6914),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
