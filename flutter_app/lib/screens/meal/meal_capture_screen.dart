import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../providers/pet_provider.dart';
import '../../utils/theme.dart';
import '../../utils/router.dart';

class MealCaptureScreen extends StatefulWidget {
  const MealCaptureScreen({super.key});

  @override
  State<MealCaptureScreen> createState() => _MealCaptureScreenState();
}

class _MealCaptureScreenState extends State<MealCaptureScreen> {
  bool _isAnalyzing = false;
  NutritionRecord? _lastRecord;

  final List<Map<String, dynamic>> _quickFoods = [
    {'name': '鸡胸肉沙拉', 'emoji': '🍗'},
    {'name': '三文鱼便当', 'emoji': '🍣'},
    {'name': '蔬菜沙拉', 'emoji': '🥗'},
    {'name': '牛肉汉堡', 'emoji': '🍔'},
    {'name': '水果拼盘', 'emoji': '🍎'},
    {'name': '炒饭', 'emoji': '🍚'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('记录饮食'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Camera placeholder
            GestureDetector(
              onTap: _simulateCapture,
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: _isAnalyzing
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AuraPetTheme.accent,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'AI 正在分析...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '📸',
                            style: TextStyle(fontSize: 72),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '点击拍摄食物',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),
                          // Scan animation
                          const SizedBox(height: 20),
                          _ScanLine(),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 32),

            // Quick select
            Text('快速选择', style: AuraPetTheme.headingMd),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _quickFoods.length,
              itemBuilder: (context, index) {
                final food = _quickFoods[index];
                return _QuickFoodCard(
                  emoji: food['emoji'],
                  name: food['name'],
                  onTap: () => _selectQuickFood(food['name']),
                );
              },
            ),

            // Result display
            if (_lastRecord != null) ...[
              const SizedBox(height: 32),
              _MealResultCard(record: _lastRecord!),
            ],
          ],
        ),
      ),
    );
  }

  void _simulateCapture() {
    setState(() => _isAnalyzing = true);
    HapticFeedback.mediumImpact();

    // Simulate AI analysis
    Future.delayed(const Duration(seconds: 2), () {
      final foods = [
        '鸡胸肉沙拉',
        '三文鱼便当',
        '蔬菜沙拉',
        '牛肉汉堡',
        '水果拼盘',
      ];
      final food = foods[DateTime.now().second % foods.length];
      _analyzeFood(food);
    });
  }

  void _selectQuickFood(String foodName) {
    HapticFeedback.selectionClick();
    _analyzeFood(foodName);
  }

  void _analyzeFood(String foodName) {
    final nutrition = context.read<NutritionProvider>();
    final record = nutrition.simulateFoodAnalysis(foodName);

    // Update pet mood
    final pet = context.read<PetProvider>();
    pet.startEating();

    setState(() {
      _isAnalyzing = false;
      _lastRecord = record;
    });

    // Show result
    Future.delayed(const Duration(milliseconds: 500), () {
      pet.finishEating(auraScore: record.auraScore);
    });
  }
}

class _ScanLine extends StatefulWidget {
  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AuraPetTheme.accent,
                Colors.transparent,
              ],
            ),
          ),
          transform: Matrix4.translationValues(
            0,
            _controller.value * 150 - 75,
            0,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _QuickFoodCard extends StatelessWidget {
  final String emoji;
  final String name;
  final VoidCallback onTap;

  const _QuickFoodCard({
    required this.emoji,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AuraPetTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AuraPetTheme.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AuraPetTheme.textDark,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealResultCard extends StatelessWidget {
  final NutritionRecord record;

  const _MealResultCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AuraPetTheme.shadowMd,
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AuraPetTheme.bgPink,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(record.emoji, style: const TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.foodName, style: AuraPetTheme.headingMd),
                    Text('1份 · 约250g', style: AuraPetTheme.bodySm),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Calorie hero
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AuraPetTheme.bgPink, Color(0xFFFFF5F0)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      record.calories.toString(),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: AuraPetTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 18,
                        color: AuraPetTheme.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '今日已摄入 ${context.read<NutritionProvider>().todayCalories} / ${context.read<NutritionProvider>().dailyCalorieGoal} kcal',
                  style: AuraPetTheme.bodyMd,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AuraPetTheme.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✨ Aura: ${record.auraScore}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Nutrition grid
          Row(
            children: [
              _NutritionItem(
                label: '蛋白质',
                value: '${record.protein.toInt()}g',
                progress: record.protein / 60,
                color: AuraPetTheme.accent,
              ),
              const SizedBox(width: 12),
              _NutritionItem(
                label: '碳水',
                value: '${record.carbs.toInt()}g',
                progress: record.carbs / 200,
                color: const Color(0xFFFFB74D),
              ),
              const SizedBox(width: 12),
              _NutritionItem(
                label: '脂肪',
                value: '${record.fat.toInt()}g',
                progress: record.fat / 65,
                color: const Color(0xFFE57373),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<NutritionProvider>().addMealRecord(record);
                Navigator.pop(context);
              },
              child: const Text('保存记录 🐻'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _NutritionItem({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AuraPetTheme.bgCream,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AuraPetTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: AuraPetTheme.bodySm),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
