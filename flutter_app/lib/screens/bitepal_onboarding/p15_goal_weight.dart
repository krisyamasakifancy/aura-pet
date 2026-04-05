import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P15: Goal Weight Input
/// "What's your goal weight?"
class P15GoalWeight extends StatefulWidget {
  final VoidCallback onNext;
  
  const P15GoalWeight({super.key, required this.onNext});
  
  @override
  State<P15GoalWeight> createState() => _P15GoalWeightState();
}

class _P15GoalWeightState extends State<P15GoalWeight> {
  double _goalWeight = 65;
  bool _isKg = true;
  
  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingState>();
    final currentWeight = onboarding.currentWeight;
    final difference = currentWeight - _goalWeight;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "What's your\ngoal weight?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            // Expecting bear
            const CanvasBear(
              mood: BearMood.heartEyes,
              size: 120,
            ),
            const Spacer(),
            // Weight display
            Text(
              '${_isKg ? _goalWeight.toStringAsFixed(1) : (_goalWeight * 2.205).toStringAsFixed(1)} ${_isKg ? 'kg' : 'lbs'}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 48,
                color: Color(0xFF4CAF50),
              ),
            ),
            // Difference indicator
            if (difference > 0)
              Text(
                'You want to lose ${difference.toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.red.shade400,
                ),
              )
            else if (difference < 0)
              Text(
                'You want to gain ${(-difference).toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.green.shade400,
                ),
              )
            else
              Text(
                'You want to maintain',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.blue.shade400,
                ),
              ),
            const SizedBox(height: 24),
            // Unit toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _UnitButton(
                    label: 'KG',
                    selected: _isKg,
                    onTap: () => setState(() => _isKg = true),
                  ),
                  _UnitButton(
                    label: 'LBS',
                    selected: !_isKg,
                    onTap: () => setState(() => _isKg = false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Weight slider
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFF4CAF50),
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: const Color(0xFF4CAF50),
                overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
                trackHeight: 8,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              ),
              child: Slider(
                value: _goalWeight,
                min: 30,
                max: 200,
                onChanged: (value) {
                  setState(() => _goalWeight = value);
                  context.read<OnboardingState>().setGoalWeight(value);
                },
              ),
            ),
            const Spacer(),
            CapsuleButton(
              text: 'Next >',
              onPressed: widget.onNext,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  
  const _UnitButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: selected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
