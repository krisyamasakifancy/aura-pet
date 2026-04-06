import 'package:flutter/material.dart';
import '../../providers/nutrition_provider.dart';
import '../../utils/theme.dart';

class MealHistoryScreen extends StatelessWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('饮食记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<NutritionProvider>(
        builder: (context, nutrition, _) {
          final meals = nutrition.mealHistory;
          
          if (meals.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🍽️', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text(
                    '还没有记录',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AuraPetTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '开始拍照记录你的饮食吧',
                    style: TextStyle(color: AuraPetTheme.textLight),
                  ),
                ],
              ),
            );
          }

          // Group by date
          final groupedMeals = <String, List<NutritionRecord>>{};
          for (final meal in meals) {
            final dateKey = _formatDate(meal.timestamp);
            groupedMeals.putIfAbsent(dateKey, () => []).add(meal);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: groupedMeals.length,
            itemBuilder: (context, index) {
              final date = groupedMeals.keys.elementAt(index);
              final dayMeals = groupedMeals[date]!;
              final dayTotal = dayMeals.fold<int>(0, (sum, m) => sum + m.calories);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AuraPetTheme.textLight,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AuraPetTheme.bgPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$dayTotal kcal',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AuraPetTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Meals for this day
                  ...dayMeals.map((meal) => _MealHistoryItem(record: meal)),
                  
                  if (index < groupedMeals.length - 1)
                    const SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return '今天';
    if (dateOnly == yesterday) return '昨天';
    return '${date.month}月${date.day}日';
  }
}

class _MealHistoryItem extends StatelessWidget {
  final NutritionRecord record;

  const _MealHistoryItem({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AuraPetTheme.shadowSm,
      ),
      child: Row(
        children: [
          // Food emoji
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AuraPetTheme.bgPink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                record.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Food details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        record.foodName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AuraPetTheme.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AuraPetTheme.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '✨ ${record.auraScore}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AuraPetTheme.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _NutrientChip(label: '蛋白质', value: '${record.protein.toInt()}g'),
                    const SizedBox(width: 8),
                    _NutrientChip(label: '碳水', value: '${record.carbs.toInt()}g'),
                    const SizedBox(width: 8),
                    _NutrientChip(label: '脂肪', value: '${record.fat.toInt()}g'),
                  ],
                ),
              ],
            ),
          ),
          
          // Calories
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${record.calories}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AuraPetTheme.primary,
                ),
              ),
              const Text(
                'kcal',
                style: TextStyle(
                  fontSize: 12,
                  color: AuraPetTheme.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final String value;

  const _NutrientChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AuraPetTheme.bgCream,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$value $label',
        style: const TextStyle(
          fontSize: 11,
          color: AuraPetTheme.textLight,
        ),
      ),
    );
  }
}
