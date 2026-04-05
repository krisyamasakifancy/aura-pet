import 'package:flutter/material.dart';

/// Monet-inspired color palette
class MonetColors {
  static const Color airBlue = Color(0xFFEDF6FA);
  static const Color blushPink = Color(0xFFFDEBEE);
  static const Color mintGreen = Color(0xFFE8F5E9);
  static const Color lavender = Color(0xFFEDE7F6);
  static const Color sunnyYellow = Color(0xFFFFF8E1);
  
  // Monet gradient colors
  static const List<Color> monetGradient = [
    Color(0xFFB3E5FC), // Light blue
    Color(0xFFF8BBD9), // Pink
    Color(0xFFC8E6C9), // Mint
    Color(0xFFE1BEE7), // Lavender
    Color(0xFFFFF9C4), // Yellow
  ];
  
  // Page-specific backgrounds
  static Color getBackgroundForPage(int page) {
    switch (page) {
      case 0: return const Color(0xFFE4E3F4); // Splash purple
      case 1: return airBlue; // Welcome
      case 2: return blushPink; // Calories
      case 3: return airBlue; // Hydration
      case 4: return mintGreen; // Fasting
      case 5: return lavender; // Results
      case 6: return blushPink; // Nutrition
      case 7: return airBlue; // Survey
      case 8: return sunnyYellow; // Goals
      case 9: return airBlue;
      case 10: return blushPink;
      case 11: return airBlue;
      case 12: return mintGreen;
      case 13: return lavender;
      case 14: return sunnyYellow;
      case 15: return airBlue;
      case 16: return mintGreen;
      case 17: return blushPink;
      case 18: return airBlue;
      case 19: return lavender;
      default: return airBlue;
    }
  }
  
  // Target color for smooth lerp
  static Color targetColor(int page) => getBackgroundForPage(page);
}

/// Monet gradient background with smooth transitions
class MonetBackground extends StatefulWidget {
  final int currentPage;
  
  const MonetBackground({super.key, required this.currentPage});
  
  @override
  State<MonetBackground> createState() => _MonetBackgroundState();
}

class _MonetBackgroundState extends State<MonetBackground> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Color _currentColor = MonetColors.airBlue;
  Color _targetColor = MonetColors.blushPink;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _updateColors();
  }
  
  @override
  void didUpdateWidget(MonetBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _updateColors();
    }
  }
  
  void _updateColors() {
    _currentColor = MonetColors.getBackgroundForPage(widget.currentPage);
    _targetColor = MonetColors.getBackgroundForPage(
      (widget.currentPage + 1).clamp(0, 45)
    );
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
      animation: _animation,
      builder: (context, child) {
        final color = Color.lerp(_currentColor, _targetColor, _animation.value)!;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
                Color.lerp(color, Colors.white, 0.3)!,
              ],
            ),
          ),
          child: child,
        );
      },
      child: const SizedBox.expand(),
    );
  }
}

/// Decorative stars for some pages
class DecorativeStars extends StatelessWidget {
  final Color color;
  final int count;
  
  const DecorativeStars({
    super.key,
    this.color = Colors.amber,
    this.count = 5,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(count, (index) {
        final size = 8.0 + (index % 3) * 4;
        return Positioned(
          left: 50 + (index * 73) % 280,
          top: 100 + (index * 47) % 300,
          child: Icon(
            Icons.star,
            size: size,
            color: color.withOpacity(0.3 + (index % 3) * 0.2),
          ),
        );
      }),
    );
  }
}

/// Decorative paw prints
class DecorativePaws extends StatelessWidget {
  final Color color;
  
  const DecorativePaws({super.key, this.color = Colors.black12});
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 30,
          top: 120,
          child: _buildPawPrint(color, 24),
        ),
        Positioned(
          right: 40,
          bottom: 180,
          child: _buildPawPrint(color, 20),
        ),
      ],
    );
  }
  
  Widget _buildPawPrint(Color color, double size) {
    return Opacity(
      opacity: 0.15,
      child: Icon(
        Icons.pets,
        size: size,
        color: color,
      ),
    );
  }
}

/// Confetti animation for celebrations
class ConfettiAnimation extends StatefulWidget {
  final bool active;
  
  const ConfettiAnimation({super.key, this.active = false});
  
  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiPiece> _pieces = [];
  final _random = DateTime.now().millisecondsSinceEpoch;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    if (widget.active) {
      _generatePieces();
      _controller.forward();
    }
  }
  
  void _generatePieces() {
    final colors = MonetColors.monetGradient;
    for (int i = 0; i < 50; i++) {
      _pieces.add(_ConfettiPiece(
        x: (i * 17 % 300).toDouble(),
        y: (i * 23 % 500 * -1).toDouble(),
        color: colors[i % colors.length],
        size: 6 + (i % 4) * 2,
        speed: 200 + (i % 5) * 50,
      ));
    }
  }
  
  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _generatePieces();
      _controller.forward(from: 0);
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
      builder: (context, _) {
        return CustomPaint(
          painter: _ConfettiPainter(
            pieces: _pieces,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ConfettiPiece {
  double x;
  double y;
  Color color;
  double size;
  double speed;
  
  _ConfettiPiece({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;
  
  _ConfettiPainter({required this.pieces, required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final paint = Paint()
        ..color = piece.color.withOpacity(1 - progress * 0.5)
        ..style = PaintingStyle.fill;
      
      final y = piece.y + progress * piece.speed;
      final x = piece.x + (progress * 50 - 25) * (piece.x % 2 == 0 ? 1 : -1);
      
      canvas.drawCircle(Offset(x, y), piece.size * (1 - progress * 0.3), paint);
    }
  }
  
  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => progress < 1;
}
