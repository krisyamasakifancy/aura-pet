import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P17: Analyzing Profile - Radar Chart Analysis
/// Shows 5-axis radar chart based on user data from P8-P16
class P17Analyzing extends StatefulWidget {
  final VoidCallback onNext;
  
  const P17Analyzing({super.key, required this.onNext});

  @override
  State<P17Analyzing> createState() => _P17AnalyzingState();
}

class _P17AnalyzingState extends State<P17Analyzing>
    with TickerProviderStateMixin {
  
  // Animation stages
  int _stage = 0; // 0: loading, 1: analyzing, 2: complete
  late AnimationController _loadingController;
  late AnimationController _radarController;
  late AnimationController _textController;
  
  @override
  void initState() {
    super.initState();
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _radarController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Sequence: loading -> radar -> complete
    _loadingController.forward().then((_) {
      setState(() => _stage = 1);
      _radarController.forward().then((_) {
        setState(() => _stage = 2);
        _textController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) widget.onNext();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _radarController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEDF6FA), Colors.white],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Stage indicator
              Text(
                _stage == 0 ? 'Analyzing...' : (_stage == 1 ? 'Building your profile' : 'Analysis Complete!'),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              
              const SizedBox(height: 8),
              
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _stage == 0 
                      ? 'Processing your data...'
                      : (_stage == 1 
                          ? 'Generating insights from your inputs'
                          : 'Your personalized plan is ready!'),
                  key: ValueKey(_stage),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // 【CORE】Radar Chart - 5 axes based on user data
              AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return SizedBox(
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      painter: _RadarChartPainter(
                        values: [
                          // Calculate based on P8-P16 inputs
                          (state.activityLevel == 'very_active' ? 1.0 : 
                           state.activityLevel == 'active' ? 0.8 :
                           state.activityLevel == 'moderate' ? 0.6 :
                           state.activityLevel == 'light' ? 0.4 : 0.2), // Activity level
                          1.0 - (((state.currentWeightKg - state.goalWeightKg) / 30).clamp(0.0, 1.0)), // Weight gap
                          (state.age < 30 ? 1.0 : (state.age < 50 ? 0.8 : 0.6)), // Age factor
                          _calculateHydrationScore(state), // Hydration
                          _calculateDietScore(state), // Diet quality
                        ],
                        animationValue: _radarController.value,
                        isComplete: _stage == 2,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Axis labels
              AnimatedOpacity(
                opacity: _stage == 2 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _AxisLabel(color: const Color(0xFFFF6B6B), text: 'Activity'),
                    _AxisLabel(color: const Color(0xFF4ECDC4), text: 'Weight'),
                    _AxisLabel(color: const Color(0xFFFFE66D), text: 'Age'),
                    _AxisLabel(color: const Color(0xFF4ECDC4), text: 'Hydration'),
                    _AxisLabel(color: const Color(0xFFFF6B6B), text: 'Diet'),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Loading progress or complete message
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _stage < 2
                    ? Column(
                        key: const ValueKey('loading'),
                        children: [
                          SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(
                              value: _loadingController.value,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation(Color(0xFF9C27B0)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${(_loadingController.value * 100).round()}%',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        key: const ValueKey('complete'),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                                const SizedBox(width: 12),
                                Text(
                                  'Profile analyzed successfully!',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              
              const SizedBox(height: 24),
              
              // Bear
              Row(
                children: [
                  CanvasBear(
                    mood: _stage == 2 ? BearMood.celebrating : BearMood.thinking,
                    size: 60,
                    animate: true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _stage == 2 
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                            : const Color(0xFF9C27B0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _stage == 2 
                            ? "You're doing great! Your profile is uniquely yours! ✨"
                            : "Hold tight! We're creating your personalized plan...",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: _stage == 2 ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Next button (only visible when complete)
              AnimatedOpacity(
                opacity: _stage == 2 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: CapsuleButton(
                  text: 'View My Plan',
                  onPressed: widget.onNext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  double _calculateHydrationScore(OnboardingState state) {
    // Based on water goal (default 2.5L)
    return 0.7; // Default mid-level
  }
  
  double _calculateDietScore(OnboardingState state) {
    // Based on goals selected
    return 0.6; // Default moderate score
  }
}

/// 【CORE】Radar Chart CustomPainter
class _RadarChartPainter extends CustomPainter {
  final List<double> values; // 5 values 0.0-1.0
  final double animationValue;
  final bool isComplete;
  
  _RadarChartPainter({
    required this.values,
    required this.animationValue,
    required this.isComplete,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;
    final sides = 5; // Pentagon for 5 axes
    final angle = (2 * pi) / sides;
    final startAngle = -pi / 2; // Start from top
    
    // Draw background rings
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int ring = 1; ring <= 4; ring++) {
      final ringRadius = radius * (ring / 4);
      ringPaint.color = Colors.grey.withOpacity(0.1);
      
      final path = Path();
      for (int i = 0; i <= sides; i++) {
        final x = center.dx + ringRadius * cos(startAngle + angle * i);
        final y = center.dy + ringRadius * sin(startAngle + angle * i);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, ringPaint);
    }
    
    // Draw axis lines
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    
    for (int i = 0; i < sides; i++) {
      final x = center.dx + radius * cos(startAngle + angle * i);
      final y = center.dy + radius * sin(startAngle + angle * i);
      canvas.drawLine(center, Offset(x, y), axisPaint);
    }
    
    // Draw data polygon
    if (values.isNotEmpty) {
      final dataPath = Path();
      final animatedValues = values.map((v) => v * animationValue).toList();
      
      for (int i = 0; i <= sides; i++) {
        final valueIndex = i % sides;
        final value = animatedValues[valueIndex].clamp(0.0, 1.0);
        final r = radius * value;
        final x = center.dx + r * cos(startAngle + angle * i);
        final y = center.dy + r * sin(startAngle + angle * i);
        
        if (i == 0) {
          dataPath.moveTo(x, y);
        } else {
          dataPath.lineTo(x, y);
        }
      }
      dataPath.close();
      
      // Fill
      final fillPaint = Paint()
        ..color = (isComplete ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0))
            .withOpacity(0.3 * animationValue)
        ..style = PaintingStyle.fill;
      canvas.drawPath(dataPath, fillPaint);
      
      // Stroke
      final strokePaint = Paint()
        ..color = (isComplete ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0))
            .withOpacity(animationValue)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(dataPath, strokePaint);
      
      // Draw data points
      final pointPaint = Paint()
        ..color = isComplete ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0)
        ..style = PaintingStyle.fill;
      
      for (int i = 0; i < sides; i++) {
        final value = animatedValues[i].clamp(0.0, 1.0);
        final r = radius * value;
        final x = center.dx + r * cos(startAngle + angle * i);
        final y = center.dy + r * sin(startAngle + angle * i);
        canvas.drawCircle(Offset(x, y), 6, pointPaint);
      }
    }
    
    // Draw center dot
    final centerPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerPaint);
  }
  
  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || 
           oldDelegate.isComplete != isComplete;
  }
}

class _AxisLabel extends StatelessWidget {
  final Color color;
  final String text;
  
  const _AxisLabel({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
