import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../utils/theme.dart';

class MealDetailScreen extends StatelessWidget {
  final NutritionRecord? record;

  const MealDetailScreen({super.key, this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('饮食详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: record == null
          ? const Center(child: Text('没有记录'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AuraPetTheme.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AuraPetTheme.shadowMd,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AuraPetTheme.bgPink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              record!.emoji,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          record!.foodName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '1份 · 约250g',
                          style: TextStyle(
                            color: AuraPetTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _QuickStat(label: '卡路里', value: '${record!.calories}', unit: 'kcal'),
                            Container(
                              width: 1,
                              height: 40,
                              color: AuraPetTheme.bgCream,
                            ),
                            _QuickStat(label: '蛋白质', value: '${record!.protein.toInt()}', unit: 'g'),
                            Container(
                              width: 1,
                              height: 40,
                              color: AuraPetTheme.bgCream,
                            ),
                            _QuickStat(label: '碳水', value: '${record!.carbs.toInt()}', unit: 'g'),
                            Container(
                              width: 1,
                              height: 40,
                              color: AuraPetTheme.bgCream,
                            ),
                            _QuickStat(label: '脂肪', value: '${record!.fat.toInt()}', unit: 'g'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Aura Score
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getAuraColor(record!.auraScore).withValues(alpha: 0.2),
                          _getAuraColor(record!.auraScore).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _getAuraColor(record!.auraScore).withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _getAuraColor(record!.auraScore),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${record!.auraScore}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '✨ Aura 评分',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AuraPetTheme.textLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getAuraLabel(record!.auraScore),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: _getAuraColor(record!.auraScore),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getAuraAdvice(record!.auraScore),
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
                  ),
                  const SizedBox(height: 24),

                  // Nutrition breakdown
                  _NutritionBreakdownCard(record: record!),
                  const SizedBox(height: 24),

                  // Tips
                  _TipsCard(auraScore: record!.auraScore),
                ],
              ),
            ),
    );
  }

  Color _getAuraColor(int score) {
    if (score >= 80) return AuraPetTheme.accent;
    if (score >= 60) return const Color(0xFFFFB74D);
    if (score >= 40) return const Color(0xFFF1C40F);
    return AuraPetTheme.danger;
  }

  String _getAuraLabel(int score) {
    if (score >= 80) return '营养满分！';
    if (score >= 60) return '很不错！';
    if (score >= 40) return '还可以';
    return '需改进';
  }

  String _getAuraAdvice(int score) {
    if (score >= 80) return '完美的营养搭配，继续保持！';
    if (score >= 60) return '营养较均衡，可适当优化';
    if (score >= 40) return '减少脂肪摄入，增加蛋白';
    return '建议选择更健康的食物';
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AuraPetTheme.textDark,
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(
                  fontSize: 12,
                  color: AuraPetTheme.textLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AuraPetTheme.textLight,
          ),
        ),
      ],
    );
  }
}

class _NutritionBreakdownCard extends StatelessWidget {
  final NutritionRecord record;

  const _NutritionBreakdownCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final totalCal = record.calories.toDouble();
    final proteinCal = record.protein * 4;
    final carbsCal = record.carbs * 4;
    final fatCal = record.fat * 9;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AuraPetTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 营养素分析',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _MacroRow(
            label: '蛋白质',
            grams: record.protein,
            calories: proteinCal,
            totalCalories: totalCal,
            color: AuraPetTheme.accent,
            idealPercent: 30,
          ),
          const SizedBox(height: 16),
          _MacroRow(
            label: '碳水',
            grams: record.carbs,
            calories: carbsCal,
            totalCalories: totalCal,
            color: const Color(0xFFFFB74D),
            idealPercent: 40,
          ),
          const SizedBox(height: 16),
          _MacroRow(
            label: '脂肪',
            grams: record.fat,
            calories: fatCal,
            totalCalories: totalCal,
            color: const Color(0xFFE57373),
            idealPercent: 30,
          ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final String label;
  final double grams;
  final double calories;
  final double totalCalories;
  final Color color;
  final double idealPercent;

  const _MacroRow({
    required this.label,
    required this.grams,
    required this.calories,
    required this.totalCalories,
    required this.color,
    required this.idealPercent,
  });

  @override
  Widget build(BuildContext context) {
    final actualPercent = totalCalories > 0 ? (calories / totalCalories * 100) : 0;
    final ratio = actualPercent / idealPercent;
    final status = ratio > 1.2 ? '偏高' : (ratio < 0.8 ? '偏低' : '合适');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${grams.toInt()}g',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ratio > 1.2
                    ? AuraPetTheme.danger.withValues(alpha: 0.2)
                    : (ratio < 0.8
                        ? const Color(0xFFFFB74D).withValues(alpha: 0.2)
                        : AuraPetTheme.accent.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ratio > 1.2
                      ? AuraPetTheme.danger
                      : (ratio < 0.8
                          ? const Color(0xFFFFB74D)
                          : AuraPetTheme.accent),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (actualPercent / 100).clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${actualPercent.toInt()}%',
              style: const TextStyle(
                fontSize: 11,
                color: AuraPetTheme.textLight,
              ),
            ),
            Text(
              '理想: $idealPercent%',
              style: const TextStyle(
                fontSize: 11,
                color: AuraPetTheme.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  final int auraScore;

  const _TipsCard({required this.auraScore});

  @override
  Widget build(BuildContext context) {
    final tips = _getTips(auraScore);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AuraPetTheme.bgGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AuraPetTheme.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('💡', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '小熊建议',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AuraPetTheme.accent, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AuraPetTheme.textDark,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<String> _getTips(int score) {
    if (score >= 80) {
      return [
        '继续保持这样健康的饮食习惯！',
        '小熊为你感到骄傲 🐻',
        '记得多喝水帮助代谢',
      ];
    } else if (score >= 60) {
      return [
        '可以适当减少油脂摄入',
        '增加蔬菜比例会更健康',
        '记得补充足够的水分',
      ];
    } else {
      return [
        '建议选择更清淡的烹饪方式',
        '减少油炸和高糖食物',
        '多吃蔬菜和优质蛋白',
      ];
    }
  }
}
