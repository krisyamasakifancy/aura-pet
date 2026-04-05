import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/achievement_provider.dart';
import '../../utils/theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 60),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AuraPetTheme.primary, AuraPetTheme.primaryDark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${context.watch<NutritionProvider>().todayCalories * 7}',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: AuraPetTheme.white,
                    ),
                  ),
                  const Text(
                    '本周总摄入 (kcal)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, -40, 24, 24),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AuraPetTheme.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AuraPetTheme.shadowMd,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            icon: '🔥',
                            iconBg: AuraPetTheme.bgPink,
                            value: '${context.watch<NutritionProvider>().todayCalories}',
                            label: '日均摄入',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatItem(
                            icon: '⚖️',
                            iconBg: AuraPetTheme.bgGreen,
                            value: '${context.watch<NutritionProvider>().todayProtein.toInt()}g',
                            label: '日均蛋白',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            icon: '💧',
                            iconBg: AuraPetTheme.bgBlue,
                            value: '5天',
                            label: '喝水达标',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatItem(
                            icon: '⏰',
                            iconBg: AuraPetTheme.bgPurple,
                            value: '3次',
                            label: '完成禁食',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Achievements section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏆 成就',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AuraPetTheme.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AuraPetTheme.shadowSm,
                    ),
                    child: Consumer<AchievementProvider>(
                      builder: (context, achievements, _) {
                        return Column(
                          children: achievements.achievements.map((a) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: a.bgColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(a.emoji, style: const TextStyle(fontSize: 22)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          a.description,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AuraPetTheme.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (a.isUnlocked)
                                    const Icon(Icons.check_circle, color: AuraPetTheme.accent),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AuraPetTheme.shadowSm,
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AuraPetTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AuraPetTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
