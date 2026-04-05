import 'package:flutter/material.dart';
import 'dart:math' as math;

/// P18: 成就系统 - 勋章解锁逻辑
class P18AchievementsScreen extends StatefulWidget {
  const P18AchievementsScreen({super.key});

  @override
  State<P18AchievementsScreen> createState() => _P18AchievementsScreenState();
}

class _P18AchievementsScreenState extends State<P18AchievementsScreen>
    with TickerProviderStateMixin {
  // 成就数据
  final List<Map<String, dynamic>> _achievements = [
    {
      'id': 'first_log',
      'title': 'First Bite',
      'description': 'Log your first meal',
      'icon': '🍽️',
      'rarity': 'common',
      'unlocked': true,
      'progress': 1.0,
      'unlockedAt': '2026-04-01',
    },
    {
      'id': 'week_streak',
      'title': 'Week Warrior',
      'description': 'Log meals for 7 consecutive days',
      'icon': '🔥',
      'rarity': 'rare',
      'unlocked': true,
      'progress': 1.0,
      'unlockedAt': '2026-04-05',
    },
    {
      'id': 'water_king',
      'title': 'Water Champion',
      'description': 'Meet water goal for 14 days',
      'icon': '💧',
      'rarity': 'rare',
      'unlocked': true,
      'progress': 1.0,
      'unlockedAt': '2026-04-03',
    },
    {
      'id': 'weight_loss_3',
      'title': '3kg Down',
      'description': 'Lose 3kg from starting weight',
      'icon': '⚖️',
      'rarity': 'epic',
      'unlocked': true,
      'progress': 1.0,
      'unlockedAt': '2026-04-04',
    },
    {
      'id': 'fasting_master',
      'title': 'Fasting Master',
      'description': 'Complete 30 days of fasting',
      'icon': '🌙',
      'rarity': 'legendary',
      'unlocked': false,
      'progress': 0.53,
      'current': 16,
      'target': 30,
    },
    {
      'id': 'perfect_week',
      'title': 'Perfect Week',
      'description': 'Hit all goals for 7 days straight',
      'icon': '⭐',
      'rarity': 'epic',
      'unlocked': false,
      'progress': 0.71,
      'current': 5,
      'target': 7,
    },
    {
      'id': 'early_bird',
      'title': 'Early Bird',
      'description': 'Log breakfast before 8am for 30 days',
      'icon': '🌅',
      'rarity': 'rare',
      'unlocked': false,
      'progress': 0.33,
      'current': 10,
      'target': 30,
    },
    {
      'id': 'night_owl',
      'title': 'Night Owl',
      'description': 'Log dinner after 8pm for 20 days',
      'icon': '🦉',
      'rarity': 'common',
      'unlocked': false,
      'progress': 0.15,
      'current': 3,
      'target': 20,
    },
    {
      'id': 'macro_master',
      'title': 'Macro Master',
      'description': 'Hit protein/carb/fat targets for 50 days',
      'icon': '📊',
      'rarity': 'legendary',
      'unlocked': false,
      'progress': 0.18,
      'current': 9,
      'target': 50,
    },
    {
      'id': 'social_share',
      'title': 'Sharing is Caring',
      'description': 'Share your progress 10 times',
      'icon': '📤',
      'rarity': 'common',
      'unlocked': false,
      'progress': 0.0,
      'current': 0,
      'target': 10,
    },
    {
      'id': 'photo_king',
      'title': 'Photo King',
      'description': 'Log 100 meals with photos',
      'icon': '📸',
      'rarity': 'epic',
      'unlocked': false,
      'progress': 0.42,
      'current': 42,
      'target': 100,
    },
    {
      'id': 'weight_goal',
      'title': 'Goal Crusher',
      'description': 'Reach your target weight',
      'icon': '🏆',
      'rarity': 'legendary',
      'unlocked': false,
      'progress': 0.85,
      'current': 3.7,
      'target': 4.3,
    },
  ];

  String _selectedFilter = 'all';
  late AnimationController _celebrationController;

  int get _unlockedCount => _achievements.where((a) => a['unlocked'] == true).length;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'common':
        return const Color(0xFF78909C);
      case 'rare':
        return const Color(0xFF42A5F5);
      case 'epic':
        return const Color(0xFF9B59B6);
      case 'legendary':
        return const Color(0xFFFFB300);
      default:
        return const Color(0xFF78909C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAchievements = _achievements.where((a) {
      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'unlocked') return a['unlocked'] == true;
      if (_selectedFilter == 'locked') return a['unlocked'] == false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFB74D)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '$_unlockedCount/${_achievements.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 进度概览
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFD700), Color(0xFFFFB74D)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overall Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_unlockedCount / _achievements.length * 100).toInt()}% Complete',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: _unlockedCount / _achievements.length,
                          strokeWidth: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      Text(
                        '$_unlockedCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 过滤器
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Unlocked', 'unlocked'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Locked', 'locked'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 成就列表
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: filteredAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = filteredAchievements[index];
                  return _buildAchievementCard(achievement);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedFilter = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD700) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] == true;
    final rarityColor = _getRarityColor(achievement['rarity']);
    final progress = achievement['progress'] as double;

    return GestureDetector(
      onTap: () => _showAchievementDetail(achievement),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked ? rarityColor.withValues(alpha: 0.3) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: rarityColor.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 勋章图标
            Stack(
              alignment: Alignment.center,
              children: [
                if (isUnlocked)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          rarityColor.withValues(alpha: 0.3),
                          rarityColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked ? rarityColor.withValues(alpha: 0.15) : Colors.grey[200],
                    border: Border.all(
                      color: isUnlocked ? rarityColor : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isUnlocked ? achievement['icon'] : '🔒',
                      style: TextStyle(
                        fontSize: 28,
                        color: isUnlocked ? null : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                // 稀有度标签
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: rarityColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      achievement['rarity'][0].toString().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 标题
            Text(
              achievement['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isUnlocked ? const Color(0xFF2D3436) : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // 进度条
            if (!isUnlocked) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(rarityColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${achievement['current']}/${achievement['target']}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ] else ...[
              Text(
                achievement['unlockedAt'] ?? '',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAchievementDetail(Map<String, dynamic> achievement) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isUnlocked = achievement['unlocked'] == true;
        final rarityColor = _getRarityColor(achievement['rarity']);
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      rarityColor.withValues(alpha: 0.3),
                      rarityColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    isUnlocked ? achievement['icon'] : '🔒',
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                achievement['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  achievement['rarity'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: rarityColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                achievement['description'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 8),
                      Text(
                        'Unlocked on ${achievement['unlockedAt']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: achievement['progress'],
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(rarityColor),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${achievement['current']}/${achievement['target']} (${(achievement['progress'] * 100).toInt()}%)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
