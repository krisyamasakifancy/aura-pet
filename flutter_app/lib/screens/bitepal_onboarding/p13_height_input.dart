import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P13: Height Input
/// Vertical ruler for height with unit toggle
class P13HeightInput extends StatefulWidget {
  final VoidCallback onNext;
  
  const P13HeightInput({super.key, required this.onNext});

  @override
  State<P13HeightInput> createState() => _P13HeightInputState();
}

class _P13HeightInputState extends State<P13HeightInput> {
  bool _useMetric = true;
  
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    // Convert cm to feet/inches for display
    final heightInCm = state.heightCm;
    final feet = (heightInCm / 30.48).floor();
    final inches = ((heightInCm % 30.48) / 2.54).round();
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "How tall are\nyou?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Slide to measure your height',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            // Unit toggle
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _useMetric = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _useMetric ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'cm',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: _useMetric ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _useMetric = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: !_useMetric ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'ft/in',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: !_useMetric ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Height display
            Center(
              child: Column(
                children: [
                  if (_useMetric)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          heightInCm.round().toString(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 72,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const Text(
                          ' cm',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$feet',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 72,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const Text(
                          ' ft ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '$inches',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const Text(
                          ' in',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),
                  // Vertical ruler
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Left marks
                        SizedBox(
                          width: 30,
                          child: ListView.builder(
                            reverse: true,
                            itemCount: 30,
                            itemBuilder: (context, index) {
                              final cm = (heightInCm - 100 + index * 5).clamp(100, 220).toInt();
                              final showLabel = cm % 10 == 0;
                              return SizedBox(
                                height: 200 / 30,
                                child: Row(
                                  children: [
                                    Container(
                                      width: showLabel ? 15 : 8,
                                      height: 1,
                                      color: showLabel ? Colors.grey : Colors.grey.shade300,
                                    ),
                                    if (showLabel)
                                      Text(
                                        '${cm}cm',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Slider track
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              activeTrackColor: const Color(0xFF4CAF50),
                              inactiveTrackColor: Colors.grey.shade200,
                              thumbColor: const Color(0xFF4CAF50),
                              overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
                            ),
                            child: Slider(
                              value: state.heightCm,
                              min: 100,
                              max: 220,
                              onChanged: (value) => state.setHeight(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.curious,
                  size: 50,
                  animate: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Standing tall! 📏 Great height!",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Next', onPressed: widget.onNext),
          ],
        ),
      ),
    );
  }
}
