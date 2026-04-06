import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/theme.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  double _height = 175;
  double _weight = 70;
  bool _isMetric = true;

  double get _bmi => _weight / ((_height / 100) * (_height / 100));

  String get _bmiCategory {
    if (_bmi < 18.5) return '偏瘦';
    if (_bmi < 24) return '正常';
    if (_bmi < 28) return '超重';
    return '肥胖';
  }

  Color get _bmiColor {
    if (_bmi < 18.5) return const Color(0xFF3498DB);
    if (_bmi < 24) return AuraPetTheme.accent;
    if (_bmi < 28) return const Color(0xFFF1C40F);
    return AuraPetTheme.danger;
  }

  String get _bmiAdvice {
    if (_bmi < 18.5) return '适当增重，保持营养均衡';
    if (_bmi < 24) return '体重正常，继续保持健康生活方式';
    if (_bmi < 28) return '适当减少热量摄入，增加运动';
    return '建议咨询医生，制定减重计划';
  }

  double get _bmiMarkerPosition {
    // Map BMI 15-30 to 0-100%
    return ((_bmi - 15) / 15).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('BMI 计算器'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Unit toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AuraPetTheme.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _UnitButton(
                    label: '公制',
                    isSelected: _isMetric,
                    onTap: () => setState(() => _isMetric = true),
                  ),
                  _UnitButton(
                    label: '英制',
                    isSelected: !_isMetric,
                    onTap: () => setState(() => _isMetric = false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // BMI Result
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AuraPetTheme.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AuraPetTheme.shadowMd,
              ),
              child: Column(
                children: [
                  const Text(
                    '你的 BMI',
                    style: TextStyle(
                      fontSize: 16,
                      color: AuraPetTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      color: _bmiColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _bmiColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _bmiCategory,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _bmiColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // BMI Scale
                  Stack(
                    children: [
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF3498DB),
                              Color(0xFF2ECC71),
                              Color(0xFFF1C40F),
                              Color(0xFFE74C3C),
                            ],
                            stops: [0.0, 0.33, 0.66, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width *
                            0.75 *
                            _bmiMarkerPosition,
                        child: Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(top: -6),
                          decoration: BoxDecoration(
                            color: AuraPetTheme.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: _bmiColor, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('15', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                      Text('18.5', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                      Text('24', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                      Text('28', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                      Text('30+', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _bmiAdvice,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AuraPetTheme.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Height slider
            _SliderCard(
              icon: '📏',
              label: '身高',
              value: _height,
              unit: _isMetric ? 'cm' : 'in',
              displayValue: _isMetric ? '${_height.toInt()}' : '${(_height / 2.54).toInt()}',
              min: _isMetric ? 100 : 39,
              max: _isMetric ? 220 : 87,
              onChanged: (v) => setState(() => _height = v),
            ),
            const SizedBox(height: 16),

            // Weight slider
            _SliderCard(
              icon: '⚖️',
              label: '体重',
              value: _weight,
              unit: _isMetric ? 'kg' : 'lbs',
              displayValue: _isMetric ? '${_weight.toInt()}' : '${(_weight * 2.2).toInt()}',
              min: _isMetric ? 30 : 66,
              max: _isMetric ? 150 : 330,
              onChanged: (v) => setState(() => _weight = v),
            ),
            const SizedBox(height: 32),

            // BMR info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AuraPetTheme.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AuraPetTheme.shadowSm,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AuraPetTheme.bgPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('🔥', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          '基础代谢率 (BMR)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_calculateBMR().toInt()}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AuraPetTheme.primary,
                    ),
                  ),
                  const Text(
                    'kcal/天',
                    style: TextStyle(
                      color: AuraPetTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '这是你在静息状态下消耗的热量',
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
    );
  }

  double _calculateBMR() {
    // Mifflin-St Jeor Equation
    // For men: BMR = 10 × weight(kg) + 6.25 × height(cm) - 5 × age + 5
    // Assuming age = 25 for simplicity
    return 10 * _weight + 6.25 * _height - 5 * 25 + 5;
  }
}

class _UnitButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AuraPetTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AuraPetTheme.white : AuraPetTheme.textLight,
          ),
        ),
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  final String icon;
  final String label;
  final double value;
  final String unit;
  final String displayValue;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.displayValue,
    required this.min,
    required this.max,
    required this.onChanged,
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
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AuraPetTheme.bgCream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$displayValue $unit',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AuraPetTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AuraPetTheme.primary,
              inactiveTrackColor: AuraPetTheme.primary.withOpacity(0.2),
              thumbColor: AuraPetTheme.primary,
              overlayColor: AuraPetTheme.primary.withOpacity(0.2),
              trackHeight: 8,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
