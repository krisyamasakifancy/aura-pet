import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/monet_background.dart';
import '../../widgets/bitepal_widgets.dart';

/// P27: Welcome Home
/// "Welcome to your new life!"
class P27WelcomeHome extends StatefulWidget {
  final VoidCallback onNext;
  
  const P27WelcomeHome({super.key, required this.onNext});
  
  @override
  State<P27WelcomeHome> createState() => _P27WelcomeHomeState();
}

class _P27WelcomeHomeState extends State<P27WelcomeHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCE4EC), // Pink
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Confetti
                const ConfettiAnimation(active: true),
                // Bouncing bear
                Transform.translate(
                  offset: Offset(0, 100 * (1 - _bounceAnimation.value)),
                  child: Transform.scale(
                    scale: _bounceAnimation.value,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Rainbow circle
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.red.shade100.withOpacity(0.5),
                                Colors.orange.shade100.withOpacity(0.4),
                                Colors.yellow.shade100.withOpacity(0.3),
                                Colors.green.shade100.withOpacity(0.2),
                                Colors.blue.shade100.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                        const CanvasBear(
                          mood: BearMood.celebrating,
                          size: 180,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      const Text(
                        'Welcome to your\nnew life!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your personalized plan is ready',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (_fadeAnimation.value > 0.5)
                  Opacity(
                    opacity: (_fadeAnimation.value - 0.5) * 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CapsuleButton(
                        text: 'Start journey >',
                        onPressed: widget.onNext,
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
