import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../providers/pet_provider.dart';
import '../../utils/theme.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuraPetTheme.bgBlue,
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
                        '喝水追踪',
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

              Expanded(
                child: Consumer<NutritionProvider>(
                  builder: (context, nutrition, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Water cup visualization
                        _WaterCup(
                          fillLevel: nutrition.waterProgress,
                          glasses: nutrition.waterGlasses,
                          goal: nutrition.waterGoal,
                        ),
                        const SizedBox(height: 40),

                        // Big number
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${nutrition.waterGlasses}',
                                style: const TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                  color: AuraPetTheme.water,
                                ),
                              ),
                              TextSpan(
                                text: '/${nutrition.waterGoal}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  color: AuraPetTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '杯 / 每日目标 8 杯',
                          style: TextStyle(
                            fontSize: 18,
                            color: AuraPetTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Add buttons
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _AddWaterButton(
                              label: '🥛 +1杯',
                              onTap: () => _addWater(context, 1),
                            ),
                            _AddWaterButton(
                              label: '🥤 +2杯',
                              onTap: () => _addWater(context, 2),
                            ),
                            _AddWaterButton(
                              label: '☕ +半杯',
                              onTap: () => _addWater(context, 0.5),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addWater(BuildContext context, double glasses) {
    HapticFeedback.mediumImpact();
    final nutrition = context.read<NutritionProvider>();
    final pet = context.read<PetProvider>();

    final wasGoalMet = nutrition.waterGoalMet;
    nutrition.addWater(glasses: glasses.toInt());

    if (!wasGoalMet && nutrition.waterGoalMet) {
      pet.addWater(glasses: 8);
      _showGoalReachedDialog(context);
    }
  }

  void _showGoalReachedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              '喝水目标达成！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '小熊很开心获得了奖励！',
              style: TextStyle(color: AuraPetTheme.textLight),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('好的！'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterCup extends StatefulWidget {
  final double fillLevel;
  final int glasses;
  final int goal;

  const _WaterCup({
    required this.fillLevel,
    required this.glasses,
    required this.goal,
  });

  @override
  State<_WaterCup> createState() => _WaterCupState();
}

class _WaterCupState extends State<_WaterCup>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 220,
      child: Stack(
        children: [
          // Cup border
          Container(
            width: 160,
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(
                color: AuraPetTheme.water,
                width: 5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          // Water fill
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              height: 215 * widget.fillLevel.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF7BC4FF),
                    AuraPetTheme.water,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          // Wave animation
          if (widget.fillLevel > 0)
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Positioned(
                  top: 215 * widget.fillLevel.clamp(0.0, 1.0) - 10,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(160, 20),
                    painter: _WavePainter(
                      wavePhase: _waveController.value * 2 * 3.14159,
                    ),
                  ),
                );
              },
            ),
          // Water drops icon
          if (widget.fillLevel >= 1.0)
            const Center(
              child: Text('💧', style: TextStyle(fontSize: 48)),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }
}

class _WavePainter extends CustomPainter {
  final double wavePhase;

  _WavePainter({required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height / 2);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 +
          5 * (wavePhase + x * 0.05).remainder(6.28).toDouble();
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase;
  }
}

class _AddWaterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AddWaterButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: AuraPetTheme.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AuraPetTheme.water,
            width: 3,
          ),
          boxShadow: AuraPetTheme.shadowSm,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AuraPetTheme.water,
          ),
        ),
      ),
    );
  }
}
