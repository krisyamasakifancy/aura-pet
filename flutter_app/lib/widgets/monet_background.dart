import 'package:flutter/material.dart';
import 'dart:ui';

/// Monet Colors - Monet-inspired palette for BitePal
class MonetColors {
  // Default colors object for compatibility
  static Color getCurrentColors() {
    return airBlue;
  }
  
  // Primary air blue (background base)
  static const Color airBlue = Color(0xFFEDF6FA);
  
  // Monet-inspired gradient colors
  static const Color monetPink = Color(0xFFFCE4EC);
  static const Color monetBlue = Color(0xFFE3F2FD);
  static const Color monetGreen = Color(0xFFE8F5E9);
  static const Color monetPurple = Color(0xFFEDE7F6);
  static const Color monetYellow = Color(0xFFFFFDE7);
  static const Color monetOrange = Color(0xFFFFF3E0);
  
  // Splash purple
  static const Color splashPurple = Color(0xFFE4E3F4);
  
  // Accent colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color calorieOrange = Color(0xFFFF9800);
  static const Color waterBlue = Color(0xFF2196F3);
  static const Color fastingPurple = Color(0xFF9C27B0);
  
  // Get colors for specific page
  static Color getBackgroundColor(int pageIndex) {
    // P01: Splash - purple
    if (pageIndex == 0) return splashPurple;
    
    // P02: Welcome - air blue
    if (pageIndex == 1) return airBlue;
    
    // Feature pages P03-P07: Rotating Monet colors
    final featureIndex = (pageIndex - 2) % 5;
    switch (featureIndex) {
      case 0: return monetBlue;      // Calories - blue
      case 1: return monetGreen;       // Fasting - green
      case 2: return monetPurple;    // Results - purple
      case 3: return monetBlue;       // Water - blue
      case 4: return monetYellow;    // Nutrition - yellow
      default: return airBlue;
    }
    
    // P08-P16: Survey pages - soft pastels
    if (pageIndex >= 7 && pageIndex <= 15) return airBlue;
    
    // P17-P27: Deep engagement - warmer tones
    if (pageIndex >= 16 && pageIndex <= 26) {
      final engagementIndex = (pageIndex - 16) % 5;
      switch (engagementIndex) {
        case 0: return monetPink;
        case 1: return monetPurple;
        case 2: return monetBlue;
        case 3: return monetOrange;
        case 4: return monetYellow;
        default: return airBlue;
      }
    }
    
    // P28-P37: App pages - neutral air blue
    if (pageIndex >= 27 && pageIndex <= 36) return airBlue;
    
    // P38-P46: Achievement pages - celebratory
    if (pageIndex >= 37) {
      final achievementIndex = (pageIndex - 37) % 5;
      switch (achievementIndex) {
        case 0: return monetYellow;
        case 1: return monetPink;
        case 2: return monetGreen;
        case 3: return monetBlue;
        case 4: return monetPurple;
        default: return airBlue;
      }
    }
    
    return airBlue;
  }
  
  static Color getNextBackgroundColor(int pageIndex) {
    return getBackgroundColor(pageIndex + 1);
  }
}

/// Monet-style gradient background with smooth color transitions
class MonetBackground extends StatefulWidget {
  final int pageIndex;
  final Widget child;
  
  const MonetBackground({
    super.key,
    required this.pageIndex,
    required this.child,
  });

  @override
  State<MonetBackground> createState() => _MonetBackgroundState();
}

class _MonetBackgroundState extends State<MonetBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  Color _currentColor = MonetColors.getBackgroundColor(0);
  Color _targetColor = MonetColors.getBackgroundColor(1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _updateColors();
  }

  @override
  void didUpdateWidget(MonetBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex) {
      _updateColors();
    }
  }

  void _updateColors() {
    _currentColor = MonetColors.getBackgroundColor(widget.pageIndex);
    _targetColor = MonetColors.getBackgroundColor(widget.pageIndex + 1);
    
    _colorAnimation = ColorTween(
      begin: _currentColor,
      end: _targetColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
    
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final bgColor = _colorAnimation.value ?? _currentColor;
        
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                bgColor,
                Color.lerp(bgColor, Colors.white, 0.3) ?? bgColor,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Simple animated background for individual pages
class SimpleMonetBackground extends StatelessWidget {
  final Color? color;
  final int? pageIndex;
  final Widget child;
  
  const SimpleMonetBackground({
    super.key,
    this.color,
    this.pageIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? (pageIndex != null 
        ? MonetColors.getBackgroundColor(pageIndex!) 
        : MonetColors.airBlue);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bgColor,
            Color.lerp(bgColor, Colors.white, 0.2) ?? bgColor,
          ],
        ),
      ),
      child: child,
    );
  }
}

/// Confetti animation for celebrations
class ConfettiAnimation extends StatefulWidget {
  final bool active;
  final Color? color;
  
  const ConfettiAnimation({
    super.key,
    this.active = true,
    this.color,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final _random = DateTime.now().millisecondsSinceEpoch;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    if (widget.active) {
      _generateParticles();
      _controller.repeat();
    }
  }
  
  void _generateParticles() {
    _particles.clear();
    final colors = [
      MonetColors.primaryGreen,
      MonetColors.monetPink,
      MonetColors.monetYellow,
      MonetColors.monetBlue,
      MonetColors.calorieOrange,
    ];
    
    for (int i = 0; i < 50; i++) {
      _particles.add(_ConfettiParticle(
        x: (i * 17 % 100).toDouble(),
        y: -10 - (i * 7 % 50).toDouble(),
        size: 4 + (i % 8).toDouble(),
        color: colors[i % colors.length],
        speed: 0.5 + (i % 10) * 0.1,
        rotation: (i * 31 % 360).toDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  final double size;
  final Color color;
  final double speed;
  double rotation;
  
  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;
  
  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final y = (particle.y + progress * 120 * particle.speed) % (size.height + 50);
      final x = particle.x + (progress * 20 - 10) * (particle.x % 2 == 0 ? 1 : -1);
      
      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - progress * 0.3)
        ..style = PaintingStyle.fill;
      
      canvas.save();
      canvas.translate(x * size.width / 100, y);
      canvas.rotate(particle.rotation + progress * 3);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }
  
  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
