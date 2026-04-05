import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P13: Height Input - TRUE Vertical Ruler
/// Not a slider - a REAL vertical measuring ruler with tick marks
class P13HeightInput extends StatefulWidget {
  final VoidCallback onNext;
  
  const P13HeightInput({super.key, required this.onNext});

  @override
  State<P13HeightInput> createState() => _P13HeightInputState();
}

class _P13HeightInputState extends State<P13HeightInput> {
  bool _useMetric = true;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    // Initialize scroll position based on saved height
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<OnboardingState>(context, listen: false);
      final targetOffset = (state.heightCm - 100) * 3.5; // 3.5 pixels per cm
      _scrollController.jumpTo(targetOffset.clamp(0, 420 * 3.5));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    // Calculate height based on scroll position
    final heightInCm = (100 + (_scrollController.hasClients 
        ? _scrollController.offset / 3.5 
        : state.heightCm - 100)).clamp(100.0, 220.0);
    
    // Convert for display
    final feet = (heightInCm / 30.48).floor();
    final inches = ((heightInCm % 30.48) / 2.54).round();
    
    return SafeArea(
      child: Row(
        children: [
          // 【CORE】TRUE Vertical Ruler
          Container(
            width: 60,
            color: const Color(0xFFF5F5F5),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Ruler marks
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                          Colors.black,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.05, 0.95, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 121, // 100-220cm
                      itemBuilder: (context, index) {
                        final cm = 100 + index;
                        final isMainMark = cm % 10 == 0;
                        final isMidMark = cm % 5 == 0 && !isMainMark;
                        
                        return GestureDetector(
                          onTap: () {
                            _scrollController.animateTo(
                              index * 3.5,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          child: Container(
                            height: 3.5,
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: isMainMark ? 20 : (isMidMark ? 12 : 6),
                                  height: 1,
                                  color: isMainMark 
                                      ? Colors.black87 
                                      : (isMidMark ? Colors.black54 : Colors.black38),
                                ),
                                if (isMainMark) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '$cm',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
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
                    'Scroll the ruler to measure',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Unit toggle
                  Container(
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
                  
                  const Spacer(),
                  
                  // Height display
                  Center(
                    child: Column(
                      children: [
                        // Large height number
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
                        
                        const SizedBox(height: 16),
                        
                        // Visual height indicator (stick figure concept)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.height, color: Color(0xFF4CAF50), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _useMetric 
                                    ? '${heightInCm.round()}cm tall' 
                                    : '${heightInCm.round()}cm / ${feet}\'${inches}"',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Bear with quote
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
                  
                  // Update state and next
                  CapsuleButton(
                    text: 'Next',
                    onPressed: () {
                      // Save height to state
                      state.setHeight(heightInCm);
                      widget.onNext();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
