import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/monet_background.dart';

/// P21: Plan Loading
/// "Your plan is being created..."
class P21PlanLoading extends StatefulWidget {
  final VoidCallback onComplete;
  
  const P21PlanLoading({super.key, required this.onComplete});
  
  @override
  State<P21PlanLoading> createState() => _P21PlanLoadingState();
}

class _P21PlanLoadingState extends State<P21PlanLoading>
    with TickerProviderStateMixin {
  late AnimationController _spiralController;
  late AnimationController _progressController;
  double _progress = 0;
  int _currentStep = 0;
  
  final _steps = [
    'Analyzing your BMI',
    'Optimizing calorie intake',
    'Creating meal schedule',
    'Setting hydration goals',
    'Your plan is ready!',
  ];
  
  @override
  void initState() {
    super.initState();
    _spiralController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
      setState(() {
        _progress = _progressController.value;
        _currentStep = (_progress * _steps.length).floor().clamp(0, _steps.length - 1);
      });
    });
    _progressController.forward();
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.onComplete();
    });
  }
  
  @override
  void dispose() {
    _spiralController.dispose();
    _progressController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCE4EC), // Pink
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spiral animation with bear
              AnimatedBuilder(
                animation: _spiralController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _spiralController.value * 2 * 3.14159,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Colorful spiral particles
                        ...List.generate(12, (index) {
                          final angle = index * 30.0 * 3.14159 / 180;
                          final radius = 100 + 20 * _progress;
                          return Positioned(
                            left: 150 + radius * _progress * 
                                (index % 2 == 0 ? 1 : 0.8) * 
                                (index < 6 ? 1 : -1) * 
                                (index % 4 < 2 ? 1 : -1),
                            top: 150 + radius * _progress * 
                                (index % 3 == 0 ? 0.9 : 0.7) * 
                                (index < 3 || index > 8 ? -1 : 1) * 
                                (index % 5 < 2 ? 1 : -1),
                            child: Container(
                              width: 10 + (index % 3) * 3.0,
                              height: 10 + (index % 3) * 3.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MonetColors.monetGradient[index % 5]
                                    .withOpacity(0.8 - _progress * 0.5),
                              ),
                            ),
                          );
                        }),
                        // Bear in center
                        const CanvasBear(
                          mood: BearMood.curious,
                          size: 100,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
              const Text(
                'Your plan is being created...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              // Progress steps
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ...List.generate(_steps.length, (index) {
                      final isCompleted = index < _currentStep;
                      final isCurrent = index == _currentStep;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted 
                                    ? const Color(0xFF4CAF50)
                                    : isCurrent 
                                        ? const Color(0xFF2196F3)
                                        : Colors.grey.shade200,
                              ),
                              child: isCompleted
                                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                                  : isCurrent
                                      ? SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            value: _progress,
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _steps[index],
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: isCurrent || isCompleted 
                                    ? Colors.black87 
                                    : Colors.grey.shade400,
                                fontWeight: isCurrent 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
