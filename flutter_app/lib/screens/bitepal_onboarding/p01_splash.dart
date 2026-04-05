import 'package:flutter/material.dart';
import '../widgets/canvas_bear.dart';

/// P01: Splash Screen
/// Minimal purple background with mischievous bear
class P01Splash extends StatefulWidget {
  final VoidCallback onComplete;
  
  const P01Splash({super.key, required this.onComplete});
  
  @override
  State<P01Splash> createState() => _P01SplashState();
}

class _P01SplashState extends State<P01Splash> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _controller.forward();
    
    // Auto-advance after 2 seconds
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
      color: const Color(0xFFE4E3F4), // Minimal purple
      child: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bear with mischievous eye-roll expression
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CustomPaint(
                    painter: _MischievousBearPainter(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MischievousBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 200;
    
    final bearColor = const Color(0xFF9E9E9E);
    final darkColor = const Color(0xFF424242);
    
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Ears
    paint.color = bearColor;
    canvas.drawCircle(Offset(center.dx - 55 * scale, center.dy - 55 * scale), 30 * scale, paint);
    canvas.drawCircle(Offset(center.dx + 55 * scale, center.dy - 55 * scale), 30 * scale, paint);
    
    // Head
    canvas.drawCircle(center, 70 * scale, paint);
    
    // Face mask
    paint.color = darkColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 5 * scale), 
          width: 80 * scale, height: 40 * scale),
      paint,
    );
    
    // Eyes (mischievous - rolled up)
    paint.color = Colors.white;
    canvas.drawCircle(Offset(center.dx - 25 * scale, center.dy - 20 * scale), 12 * scale, paint);
    canvas.drawCircle(Offset(center.dx + 25 * scale, center.dy - 20 * scale), 12 * scale, paint);
    
    // Pupils (looking up)
    paint.color = darkColor;
    canvas.drawCircle(Offset(center.dx - 25 * scale, center.dy - 25 * scale), 6 * scale, paint);
    canvas.drawCircle(Offset(center.dx + 25 * scale, center.dy - 25 * scale), 6 * scale, paint);
    
    // Nose
    paint.color = darkColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 10 * scale), 
          width: 20 * scale, height: 12 * scale),
      paint,
    );
    
    // Grin (teeth showing)
    final grinPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 25 * scale), 
          width: 40 * scale, height: 25 * scale),
      0.2, 2.7, false, grinPaint,
    );
    
    // Teeth
    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(center.dx - 10 * scale, center.dy + 18 * scale, 
          20 * scale, 10 * scale),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
