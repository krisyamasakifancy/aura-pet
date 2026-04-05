import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/monet_background.dart';

/// P17: Analyzing Profile
/// Animated loading with particles
class P17Analyzing extends StatefulWidget {
  final VoidCallback onNext;
  
  const P17Analyzing({super.key, required this.onNext});

  @override
  State<P17Analyzing> createState() => _P17AnalyzingState();
}

class _P17AnalyzingState extends State<P17Analyzing>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _bounceController;
  late Animation<double> _loading;
  late Animation<double> _bounce;
  
  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    
    _loading = Tween<double>(begin: 0, end: 1).animate(_loadingController);
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _bounce = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    
    // Auto advance
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.onNext();
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          // Particles background
          SizedBox(
            height: 300,
            child: AnimatedBuilder(
              animation: _loading,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 300),
                  painter: _ParticlePainter(progress: _loading.value),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          // Bear with bounce
          AnimatedBuilder(
            animation: _bounce,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_bounce.value),
                child: const CanvasBear(
                  mood: BearMood.thinking,
                  size: 120,
                  animate: true,
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Analyzing your profile...',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: AnimatedBuilder(
              animation: _loading,
              builder: (context, child) {
                return Column(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _loading.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${(_loading.value * 100).round()}%',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final int particleCount = 20;
  
  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFE1BEE7),
      const Color(0xFFFCE4EC),
      const Color(0xFFE3F2FD),
      const Color(0xFFB3E5FC),
    ];
    
    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * 3.14159;
      final radius = 50 + progress * 100;
      final x = size.width / 2 + radius * (1 - progress) * 0.5 * (i % 2 == 0 ? 1 : -1) * (0.5 + (i * 17 % 100) / 200);
      final y = size.height / 2 + radius * (1 - progress) * 0.5 * (i % 3 == 0 ? 1 : -1) * (0.5 + (i * 31 % 100) / 200);
      
      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(1 - progress * 0.5)
        ..style = PaintingStyle.fill;
      
      final particleSize = 4 + (i % 5) * 2.0;
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
