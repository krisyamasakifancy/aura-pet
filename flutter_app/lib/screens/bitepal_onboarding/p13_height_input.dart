import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P13: Height Input
/// "How tall are you?"
class P13HeightInput extends StatefulWidget {
  final VoidCallback onNext;
  
  const P13HeightInput({super.key, required this.onNext});
  
  @override
  State<P13HeightInput> createState() => _P13HeightInputState();
}

class _P13HeightInputState extends State<P13HeightInput> {
  double _height = 170;
  bool _isCm = true;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'How tall are you?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Bear with measurement indicator
            Stack(
              alignment: Alignment.centerRight,
              children: [
                const CanvasBear(
                  mood: BearMood.curious,
                  size: 140,
                ),
                // Height indicator line
                Positioned(
                  right: 30,
                  child: Container(
                    width: 40,
                    height: 3,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
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
                    label: 'CM',
                    selected: _isCm,
                    onTap: () => setState(() => _isCm = true),
                  ),
                  _UnitButton(
                    label: 'FT',
                    selected: !_isCm,
                    onTap: () => setState(() => _isCm = false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Height ruler
            SizedBox(
              height: 150,
              child: _isCm
                  ? NumberPickerWheel(
                      minValue: 100,
                      maxValue: 220,
                      value: _height.round(),
                      suffix: ' cm',
                      onChanged: (value) {
                        setState(() => _height = value.toDouble());
                        context.read<OnboardingState>().setHeight(value.toDouble());
                      },
                    )
                  : NumberPickerWheel(
                      minValue: 3,
                      maxValue: 8,
                      value: 5,
                      suffix: ' ft',
                      onChanged: (value) {
                        // Convert ft to cm approximation
                        final cm = value * 30.48;
                        setState(() => _height = cm);
                        context.read<OnboardingState>().setHeight(cm);
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_isCm ? _height.round() : (_height / 30.48).toStringAsFixed(1)} ${_isCm ? 'cm' : 'ft'}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xFF4CAF50),
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
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ]
              : null,
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
