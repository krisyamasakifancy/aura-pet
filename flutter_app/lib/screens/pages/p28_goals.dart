import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// P28: 目标设定 - 空气感滑动选择器
class P28GoalsScreen extends StatefulWidget {
  const P28GoalsScreen({super.key});

  @override
  State<P28GoalsScreen> createState() => _P28GoalsScreenState();
}

class _P28GoalsScreenState extends State<P28GoalsScreen>
    with SingleTickerProviderStateMixin {
  // 目标数据
  double _targetWeight = 65.0;
  double _dailyCalories = 1800;
  double _waterIntake = 2.5;
  double _fastingHours = 16;
  int _weeklyWorkouts = 4;

  late AnimationController _saveAnimController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _saveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _saveAnimController.dispose();
    super.dispose();
  }

  void _updateGoal(String key, double value) {
    setState(() {
      _hasChanges = true;
      switch (key) {
        case 'weight':
          _targetWeight = value;
          break;
        case 'calories':
          _dailyCalories = value;
          break;
        case 'water':
          _waterIntake = value;
          break;
        case 'fasting':
          _fastingHours = value;
          break;
        case 'workouts':
          _weeklyWorkouts = value.roundToDouble();
          break;
      }
    });
    HapticFeedback.selectionClick();
  }

  void _saveGoals() {
    HapticFeedback.mediumImpact();
    _saveAnimController.forward(from: 0);
    setState(() => _hasChanges = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Goals saved successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Set Goals',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  if (_hasChanges)
                    AnimatedBuilder(
                      animation: _saveAnimController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _saveAnimController.value * 0.2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9B8FE8), Color(0xFF6C63FF)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: _saveGoals,
                              child: const Row(
                                children: [
                                  Icon(Icons.save, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 目标列表
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // 体重目标
                  _buildGoalCard(
                    title: 'Target Weight',
                    subtitle: 'Your goal weight',
                    icon: '⚖️',
                    value: _targetWeight,
                    unit: 'kg',
                    min: 40,
                    max: 120,
                    gradient: const [Color(0xFFFF8BA0), Color(0xFFFFB4C4)],
                    onChanged: (v) => _updateGoal('weight', v),
                  ),

                  // 每日卡路里
                  _buildGoalCard(
                    title: 'Daily Calories',
                    subtitle: 'Calorie intake target',
                    icon: '🔥',
                    value: _dailyCalories,
                    unit: 'kcal',
                    min: 1000,
                    max: 3000,
                    step: 50,
                    gradient: const [Color(0xFFFFB74D), Color(0xFFFF8A65)],
                    onChanged: (v) => _updateGoal('calories', v),
                  ),

                  // 饮水量
                  _buildGoalCard(
                    title: 'Water Intake',
                    subtitle: 'Daily hydration goal',
                    icon: '💧',
                    value: _waterIntake,
                    unit: 'L',
                    min: 1.0,
                    max: 5.0,
                    step: 0.1,
                    gradient: const [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                    onChanged: (v) => _updateGoal('water', v),
                  ),

                  // 禁食时长
                  _buildGoalCard(
                    title: 'Fasting Duration',
                    subtitle: 'Intermittent fasting hours',
                    icon: '🌙',
                    value: _fastingHours,
                    unit: 'hours',
                    min: 12,
                    max: 24,
                    gradient: const [Color(0xFF6C63FF), Color(0xFF9B8FE8)],
                    onChanged: (v) => _updateGoal('fasting', v),
                    valueLabel: '${_fastingHours.toInt()}:${((_fastingHours - _fastingHours.toInt()) * 60).toInt().toString().padLeft(2, '0')}',
                  ),

                  // 每周运动
                  _buildWorkoutCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String subtitle,
    required String icon,
    required double value,
    required String unit,
    required double min,
    required double max,
    double step = 1,
    required List<Color> gradient,
    required Function(double) onChanged,
    String? valueLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  valueLabel ?? '${value.toStringAsFixed(step < 1 ? 1 : 0)}$unit',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 滑动条
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: gradient[0],
              inactiveTrackColor: gradient[0].withValues(alpha: 0.2),
              thumbColor: gradient[0],
              overlayColor: gradient[0].withValues(alpha: 0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) / step).round(),
              onChanged: onChanged,
            ),
          ),
          
          // 范围标签
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${min.toStringAsFixed(step < 1 ? 1 : 0)}$unit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  '${max.toStringAsFixed(step < 1 ? 1 : 0)}$unit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('💪', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Workouts',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    Text(
                      'Exercise sessions per week',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$_weeklyWorkouts times',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 星期选择器
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final isSelected = i < _weeklyWorkouts;
              final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _weeklyWorkouts = i + 1;
                    _hasChanges = true;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dayNames[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 12),
          
          // 进度提示
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _weeklyWorkouts >= 4
                        ? 'Great! $4 workouts per week is optimal for most goals.'
                        : 'Try to aim for at least 3-4 workouts per week.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
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
