import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/monet_background.dart';

/// P17: Analyzing Profile
/// "Analyzing your profile..."
class P17Analyzing extends StatefulWidget {
  final VoidCallback onComplete;
  
  const P17Analyzing({super.key, required this.onComplete});
  
  @override
  State<P17Analyzing> createState() => _P17AnalyzingState();
}

class _P17AnalyzingState extends State<P17Analyzing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
      setState(() => _progress = _controller.value);
    });
    _controller.forward();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) widget.onComplete();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8F5E9), // Mint green
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bear thinking
              const CanvasBear(
                mood: BearMood.curious,
                size: 180,
              ),
              const SizedBox(height: 40),
              // Analyzing particles
              Stack(
                alignment: Alignment.center,
                children: List.generate(8, (index) {
                  final angle = index * 45.0 * 3.14159 / 180;
                  final radius = 120 * _progress;
                  return Positioned(
                    left: 180 + radius * _progress * (index % 2 == 0 ? 1 : -0.5) + 
                        20 * (index % 3) * _progress,
                    top: 200 + radius * _progress * 
                        (index < 4 ? -0.5 : 0.5) + 10 * (index % 2) * _progress,
                    child: Container(
                      width: 8 + (index % 3) * 4.0,
                      height: 8 + (index % 3) * 4.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MonetColors.monetGradient[index % 5]
                            .withOpacity(1 - _progress),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              const Text(
                'Analyzing your profile...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              // Progress bar
              Container(
                width: 200,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${(_progress * 100).toInt()}%',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
