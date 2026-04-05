import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../providers/fullstack_providers.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P35FastingTimer extends StatelessWidget {
  final VoidCallback onNext;
  
  const P35FastingTimer({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    final theme = Provider.of<ThemeController>(context);
    final progress = state.fastingProgress;
    
    // Trigger deep purple background when fasting starts
    if (state.fastingState == 'running') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        theme.startFasting();
      });
    }
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Fasting Timer',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: theme.isFastingMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.fastingState == 'running' ? 'Keep going!' : 'Ready to start?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: theme.isFastingMode ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            // Timer ring - 60FPS optimized
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250, height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 16,
                    backgroundColor: theme.isFastingMode ? Colors.white24 : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      theme.isFastingMode ? const Color(0xFF9C27B0) : const Color(0xFF4CAF50),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.fastingState == 'running' ? '16:00:00' : '00:00:00',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: theme.isFastingMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: theme.isFastingMode ? Colors.white70 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            if (state.fastingState == 'idle')
              CapsuleButton(
                text: 'START FASTING',
                onPressed: () {
                  state.startFasting();
                  theme.startFasting(); // Sync theme controller
                },
                backgroundColor: theme.isFastingMode ? const Color(0xFF9C27B0) : const Color(0xFF4CAF50),
              )
            else
              Row(
                children: [
                  CanvasBear(mood: BearMood.sleeping, size: 50, animate: false),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.isFastingMode ? Colors.white.withOpacity(0.2) : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        theme.isFastingMode 
                            ? QuoteEngine.instance.getFastingQuote(isNight: true)
                            : "Sweet dreams! 😴 Your fast is going well!",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: theme.isFastingMode ? Colors.white : Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Continue', 
              onPressed: () {
                if (state.fastingState == 'running') {
                  theme.stopFasting(); // Reset theme
                }
                onNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}
