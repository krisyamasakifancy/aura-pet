import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P35FastingTimer extends StatelessWidget {
  final VoidCallback onNext;
  
  const P35FastingTimer({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    final progress = state.fastingProgress;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Fasting Timer', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 8),
            Text(state.fastingState == 'running' ? 'Keep going!' : 'Ready to start?', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const Spacer(),
            // Timer ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250, height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 16,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(const Color(0xFF4CAF50)),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.fastingState == 'running' ? '16:00:00' : '00:00:00',
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 36),
                    ),
                    Text('${(progress * 100).round()}%', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
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
                },
                backgroundColor: const Color(0xFF4CAF50),
              )
            else
              Row(
                children: [
                  const CanvasBear(mood: BearMood.sleeping, size: 50, animate: false),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
                      child: const Text("Sweet dreams! 😴 Your fast is going well!", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.purple)),
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
