import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

/// P14: Current Weight Input
/// "What's your current weight?"
class P14CurrentWeight extends StatefulWidget {
  final VoidCallback onNext;
  
  const P14CurrentWeight({super.key, required this.onNext});
  
  @override
  State<P14CurrentWeight> createState() => _P14CurrentWeightState();
}

class _P14CurrentWeightState extends State<P14CurrentWeight> {
  double _weight = 70;
  bool _isKg = true;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "What's your current\nweight?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const Spacer(),
            // Weight dial visualization
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dial marks
                  ...List.generate(10, (index) {
                    final angle = (index * 36 - 90) * 3.14159 / 180;
                    return Positioned(
                      left: 125 + 100 * (index == 0 ? 0.9 : 0.85) * 
                          (index < 5 ? 1 : -1) * 
                          (index == 0 ? 0.8 : 1) * 
                          (index == 9 ? -0.5 : 1),
                      top: 125 + 100 * 
                          (index == 0 ? 0 : 0.85) * 
                          (index < 2 || index > 7 ? -1 : 1) *
                          (index == 0 ? -1 : 1),
                      child: Transform.rotate(
                        angle: angle,
                        child: Container(
                          width: 3,
                          height: index % 2 == 0 ? 20 : 12,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    );
                  }),
                  // Center weight display
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isKg ? _weight.toStringAsFixed(1) : (_weight * 2.205).toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      Text(
                        _isKg ? 'kg' : 'lbs',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
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
                value: _weight,
                min: _isKg ? 30 : 66,
                max: _isKg ? 200 : 440,
                onChanged: (value) {
                  setState(() => _weight = value);
                  // Store in kg for consistency
                  final kgWeight = _isKg ? value : value / 2.205;
                  context.read<OnboardingState>().setCurrentWeight(kgWeight);
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
