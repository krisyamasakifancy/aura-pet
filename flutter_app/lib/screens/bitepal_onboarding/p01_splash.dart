import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';

/// P01: Splash Screen
/// Purple background (#E4E3F4) with rolling eyes bear
class P01Splash extends StatefulWidget {
  final VoidCallback onNext;
  
  const P01Splash({super.key, required this.onNext});

  @override
  State<P01Splash> createState() => _P01SplashState();
}

class _P01SplashState extends State<P01Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    
    // Auto advance after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) widget.onNext();
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
      color: const Color(0xFFE4E3F4),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo text
                const Text(
                  'BitePal',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    color: Color(0xFF4CAF50),
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 40),
                // Rolling eyes bear (Canvas)
                const CanvasBear(
                  mood: BearMood.rollingEyes,
                  size: 200,
                  animate: true,
                ),
                const SizedBox(height: 40),
                // Tagline
                Text(
                  'Your health companion',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.grey.shade600,
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
