import 'dart:math';
import 'package:flutter/material.dart';

/// P41: Goal Celebration - Full-screen confetti effect
/// Triggers when user completes daily goals
class P41GoalCelebration extends StatefulWidget {
  final VoidCallback onNext;
  
  const P41GoalCelebration({super.key, required this.onNext});

  @override
  State<P41GoalCelebration> createState() => _P41GoalCelebrationState();
}

class _P41GoalCelebrationState extends State<P41GoalCelebration>
    with TickerProviderStateMixin {
  
  // Confetti animation controller
  late AnimationController _confettiController;
  late AnimationController _textController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  final List<_Confetti> _confetti = [];
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize confetti particles
    for (int i = 0; i < 100; i++) {
      _confetti.add(_Confetti(
        x: _random.nextDouble(),
        y: -_random.nextDouble() * 0.5,
        size: 8 + _random.nextDouble() * 8,
        color: _getRandomMonetColor(),
        speed: 0.5 + _random.nextDouble() * 1.5,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: _random.nextDouble() * 0.2,
        sway: _random.nextDouble() * 0.02 - 0.01,
      ));
    }
    
    // Confetti fall animation
    _confettiController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener(() {
      setState(() {
        for (var c in _confetti) {
          c.y += c.speed * 0.01;
          c.x += c.sway * sin(c.y * 10);
          c.rotation += c.rotationSpeed;
        }
      });
    });
    
    // Text celebration animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    
    // Start animations
    _confettiController.forward();
    _textController.forward();
  }

  Color _getRandomMonetColor() {
    final colors = [
      const Color(0xFFB8D4E3), // Monet light blue
      const Color(0xFFF4A460), // Sandy orange
      const Color(0xFFE6B89C), // Soft peach
      const Color(0xFF98D8C8), // Seafoam green
      const Color(0xFFDDA0DD), // Plum
      const Color(0xFFFFB6C1), // Light pink
      const Color(0xFF87CEEB), // Sky blue
      const Color(0xFFFFD700), // Gold
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8E7), // Warm cream
            Color(0xFFFFF0E0), // Soft peach
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // 【CORE】Full-screen Monet confetti
            ..._confetti.map((c) => Positioned(
              left: c.x * MediaQuery.of(context).size.width,
              top: c.y * MediaQuery.of(context).size.height,
              child: Transform.rotate(
                angle: c.rotation,
                child: Container(
                  width: c.size,
                  height: c.size * 0.6,
                  decoration: BoxDecoration(
                    color: c.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            )),
            
            // Celebration content
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Trophy icon with scale animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFFFA500),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Congratulations text
                    const Text(
                      '🎉',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Goals Achieved!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ve completed today\'s targets!\nKeep up the amazing work!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Stats cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatCard(icon: Icons.local_fire_department, value: '1,250', label: 'Calories', color: const Color(0xFFFF6B6B)),
                        _StatCard(icon: Icons.water_drop, value: '2.5L', label: 'Water', color: const Color(0xFF4ECDC4)),
                        _StatCard(icon: Icons.timer, value: '16:8', label: 'Fasting', color: const Color(0xFF9B59B6)),
                      ],
                    ),
                    
                    const SizedBox(height: 64),
                    
                    // Continue button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: _CapsuleButton(
                        text: 'Continue',
                        onPressed: widget.onNext,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Tap to dismiss hint
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '✨ Keep going! Your pet is proud!',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Confetti {
  double x;
  double y;
  double size;
  Color color;
  double speed;
  double rotation;
  double rotationSpeed;
  double sway;
  
  _Confetti({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
    required this.sway,
  });
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CapsuleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient gradient;
  
  const _CapsuleButton({
    required this.text,
    required this.onPressed,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
