import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../providers/achievement_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/pet_canvas.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraPetTheme.bgCream,
      body: CustomScrollView(
        slivers: [
          // Pet Display
          SliverToBoxAdapter(
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AuraPetTheme.bgPink.withValues(alpha: 0.5),
                    AuraPetTheme.bgCream,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // App bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              '我的小熊',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    // Pet
                    const SizedBox(
                      width: 260,
                      height: 260,
                      child: PetCanvas(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stats
          SliverToBoxAdapter(
            child: Consumer<PetProvider>(
              builder: (context, pet, _) {
                final state = pet.state;
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Level & XP
                      _LevelCard(
                        level: state.level,
                        xp: state.xp,
                        xpToNext: state.xpToNextLevel,
                      ),
                      const SizedBox(height: 20),

                      // Mood
                      _StatRow(
                        icon: '💭',
                        label: '心情',
                        value: state.moodLabel,
                        color: AuraPetTheme.bgPurple,
                      ),
                      const SizedBox(height: 12),

                      // Hearts
                      _StatRow(
                        icon: '❤️',
                        label: '爱心',
                        value: '${state.hearts} 个',
                        color: AuraPetTheme.danger.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 12),

                      // Coins
                      _StatRow(
                        icon: '🪙',
                        label: '金币',
                        value: '${state.coins}',
                        color: const Color(0xFFFFD93D).withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 12),

                      // Accessories
                      _AccessoriesRow(accessories: state.accessories),
                      const SizedBox(height: 32),

                      // Evolution preview
                      if (state.level < 10)
                        _EvolutionPreview(currentLevel: state.level),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final int xp;
  final int xpToNext;

  const _LevelCard({
    required this.level,
    required this.xp,
    required this.xpToNext,
  });

  @override
  Widget build(BuildContext context) {
    final progress = xp / xpToNext;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AuraPetTheme.shadowMd,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AuraPetTheme.secondary, Color(0xFFFFE066)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Lv.$level',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF8B6914),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '小熊等级',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AuraPetTheme.textDark,
                        ),
                      ),
                      Text(
                        '$xp / $xpToNext XP',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AuraPetTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AuraPetTheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AuraPetTheme.secondary.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AuraPetTheme.secondary),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AuraPetTheme.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AuraPetTheme.textLight,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AuraPetTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessoriesRow extends StatelessWidget {
  final List<PetAccessory> accessories;

  const _AccessoriesRow({required this.accessories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AuraPetTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AuraPetTheme.bgPink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('👗', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  '已装备',
                  style: TextStyle(
                    fontSize: 14,
                    color: AuraPetTheme.textLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: accessories.map((a) {
              final emoji = _accessoryEmoji(a);
              return Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AuraPetTheme.bgCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AuraPetTheme.accent, width: 2),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _accessoryEmoji(PetAccessory accessory) {
    switch (accessory) {
      case PetAccessory.scarf:
        return '🧣';
      case PetAccessory.hat:
        return '🎩';
      case PetAccessory.bow:
        return '🎀';
      case PetAccessory.glasses:
        return '🕶️';
      case PetAccessory.crown:
        return '👑';
      case PetAccessory.backpack:
        return '🎒';
    }
  }
}

class _EvolutionPreview extends StatelessWidget {
  final int currentLevel;

  const _EvolutionPreview({required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    final nextLevel = currentLevel + 1;
    final evolutionName = _getEvolutionName(nextLevel);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD93D).withValues(alpha: 0.2),
            const Color(0xFFFFE066).withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AuraPetTheme.secondary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AuraPetTheme.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌟', style: TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '进化预览',
                  style: TextStyle(
                    fontSize: 12,
                    color: AuraPetTheme.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lv.$nextLevel: $evolutionName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AuraPetTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '再升 ${10 - currentLevel} 级即可解锁',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AuraPetTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEvolutionName(int level) {
    if (level < 5) return '小熊宝宝';
    if (level < 10) return '成长小熊';
    if (level < 15) return '活力小熊';
    return '明星小熊';
  }
}
