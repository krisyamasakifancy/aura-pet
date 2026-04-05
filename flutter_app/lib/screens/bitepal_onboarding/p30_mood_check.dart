import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P30MoodCheck extends StatelessWidget {
  final VoidCallback onNext;
  
  const P30MoodCheck({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    final moods = [
      {'emoji': '😊', 'label': 'Great', 'mood': 'great'},
      {'emoji': '🙂', 'label': 'Good', 'mood': 'good'},
      {'emoji': '😐', 'label': 'Okay', 'mood': 'okay'},
      {'emoji': '😔', 'label': 'Low', 'mood': 'low'},
      {'emoji': '😤', 'label': 'Stressed', 'mood': 'stressed'},
    ];
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('How are you feeling today?', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: moods.map((m) {
                final isSelected = state.todayMood == m['mood'];
                return GestureDetector(
                  onTap: () => state.setMood(m['mood'] as String),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? 64 : 56,
                        height: isSelected ? 64 : 56,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.2) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade200, width: 2),
                        ),
                        child: Center(child: Text(m['emoji'] as String, style: TextStyle(fontSize: isSelected ? 32 : 28))),
                      ),
                      const SizedBox(height: 8),
                      Text(m['label'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isSelected ? const Color(0xFF4CAF50) : Colors.grey)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Row(
              children: [
                CanvasBear(mood: state.todayMood == 'great' ? BearMood.heartEyes : BearMood.curious, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(state.todayMood != null ? "We feel you! 💚" : "Tap to share how you feel...", style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF4CAF50))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: state.todayMood != null ? onNext : null),
          ],
        ),
      ),
    );
  }
}
