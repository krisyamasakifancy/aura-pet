import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P12: Age Input
/// "How old are you?"
class P12AgeInput extends StatefulWidget {
  final VoidCallback onNext;
  
  const P12AgeInput({super.key, required this.onNext});
  
  @override
  State<P12AgeInput> createState() => _P12AgeInputState();
}

class _P12AgeInputState extends State<P12AgeInput> {
  int _age = 25;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'How old are you?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Curious bear
            const CanvasBear(
              mood: BearMood.curious,
              size: 120,
            ),
            const Spacer(),
            // Age picker
            NumberPickerWheel(
              minValue: 16,
              maxValue: 100,
              value: _age,
              onChanged: (value) {
                setState(() => _age = value);
                context.read<OnboardingState>().setAge(value);
              },
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
