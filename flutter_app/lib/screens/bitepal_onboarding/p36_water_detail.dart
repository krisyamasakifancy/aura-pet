import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../providers/fullstack_providers.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P36WaterDetail extends StatelessWidget {
  final VoidCallback onNext;
  
  const P36WaterDetail({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    final theme = Provider.of<ThemeController>(context);
    
    // Sync water level to ThemeController (affects P28 icon size)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      theme.updateWaterLevel(state.waterIntakeMl, state.waterGoalMl);
    });
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Water Intake',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: theme.isFastingMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            // Water glass visual - 60FPS optimized
            AnimatedScale(
              scale: theme.waterIconScale, // Icon grows with water
              duration: const Duration(milliseconds: 300),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 140, height: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(40)),
                      border: Border.all(color: Colors.blue.shade200, width: 3),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17), bottom: Radius.circular(37)),
                    child: Container(
                      width: 134, 
                      height: (state.waterProgress * 180).clamp(0.0, 180),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, 
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue.shade300, Colors.blue.shade600],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: CustomPaint(
                              size: const Size(134, 20),
                              painter: _WavePainter(),
                            ),
                          ),
                          ...List.generate(5, (i) => Positioned(
                            bottom: 20 + i * 25.0,
                            left: 30.0 + i * 15,
                            child: Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${state.waterIntakeMl.round()} ml / ${state.waterGoalMl.round()} ml',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: theme.isFastingMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              '${(state.waterProgress * 100).round()}%',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: theme.isFastingMode ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _WaterButton(
                  label: '+250ml', 
                  onTap: () {
                    state.addWater(250);
                    theme.updateWaterLevel(state.waterIntakeMl, state.waterGoalMl);
                  },
                ),
                _WaterButton(
                  label: '+500ml',
                  onTap: () {
                    state.addWater(500);
                    theme.updateWaterLevel(state.waterIntakeMl, state.waterGoalMl);
                  },
                ),
                _WaterButton(
                  label: '+1L',
                  onTap: () {
                    state.addWater(1000);
                    theme.updateWaterLevel(state.waterIntakeMl, state.waterGoalMl);
                  },
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                CanvasBear(mood: BearMood.diving, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      QuoteEngine.instance.getWaterQuote(),
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  
  const _WaterButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.blue.shade700, size: 18),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14, color: Colors.blue.shade700)),
          ],
        ),
      ),
    );
  }
}
