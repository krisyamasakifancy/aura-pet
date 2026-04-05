import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

// ============================================
// THEME & COLORS - Digital Impressionism
// ============================================

class AppTheme {
  // Monet/Van Gogh Inspired Colors
  static const Color monetRose = Color(0xFFE8B4B8);
  static const Color monetLavender = Color(0xFFC9B8E0);
  static const Color monetPeach = Color(0xFFF5D0C5);
  static const Color monetMint = Color(0xFFB8E0D2);
  
  static const Color vanGoghNight = Color(0xFF1A1A2E);
  static const Color vanGoghTwilight = Color(0xFF16213E);
  static const Color vanGoghPurple = Color(0xFF0F3460);
  
  static const Color accentPrimary = Color(0xFFFF6B9D);
  static const Color accentSecondary = Color(0xFFC44CFF);
  static const Color accentSuccess = Color(0xFF4ADE80);
  
  // HSL Dynamic Colors
  static Color dynamicHue = const Color(0xFFFF6B9D);
  
  static Color get dynamicColor => HSLColor
      .fromAHSL(1.0, _hue, 0.7, 0.65)
      .toColor();
  
  static double _hue = 320;
  
  static void setMood(String mood) {
    switch (mood) {
      case 'happy':
        _hue = 320;
        break;
      case 'excited':
        _hue = 45;
        break;
      case 'neutral':
        _hue = 200;
        break;
      case 'sad':
        _hue = 220;
        break;
      case 'sleepy':
        _hue = 260;
        break;
    }
  }
  
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: vanGoghNight,
    primaryColor: accentPrimary,
    colorScheme: const ColorScheme.dark(
      primary: accentPrimary,
      secondary: accentSecondary,
      surface: vanGoghTwilight,
      onSurface: Colors.white,
    ),
    fontFamily: 'Inter',
    useMaterial3: true,
  );
}

// ============================================
// PET SPRITE WIDGET - Spring Physics Animation
// ============================================

class PetSprite extends StatefulWidget {
  final String mood;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  
  const PetSprite({
    super.key,
    required this.mood,
    this.onTap,
    this.onLongPress,
  });
  
  @override
  State<PetSprite> createState() => _PetSpriteState();
}

class _PetSpriteState extends State<PetSprite> with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _bounceController;
  late AnimationController _spinController;
  
  late Animation<double> _breathAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _spinAnimation;
  
  bool _isBlinking = false;
  bool _eyeOpen = true;
  
  @override
  void initState() {
    super.initState();
    
    // Breathing animation
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    
    // Bounce animation (Spring Physics)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    
    // Spin animation
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _spinAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOut),
    );
    
    // Blink timer
    _startBlinkTimer();
  }
  
  void _startBlinkTimer() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() => _isBlinking = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() => _eyeOpen = false);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted) {
                setState(() {
                  _eyeOpen = true;
                  _isBlinking = false;
                });
                _startBlinkTimer();
              }
            });
          }
        });
      }
    });
  }
  
  void playBounce() {
    _bounceController.forward(from: 0);
  }
  
  void playSpin() {
    _spinController.forward(from: 0);
  }
  
  @override
  void dispose() {
    _breathController.dispose();
    _bounceController.dispose();
    _spinController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    AppTheme.setMood(widget.mood);
    
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathAnimation, _bounceAnimation, _spinAnimation]),
        builder: (context, child) {
          // Spring physics bounce calculation
          final bounceOffset = _bounceAnimation.value > 0
              ? math.sin(_bounceAnimation.value * pi) * 20 * (1 - _bounceAnimation.value)
              : 0.0;
          
          return Transform.translate(
            offset: Offset(0, -bounceOffset),
            child: Transform.scale(
              scale: _breathAnimation.value,
              child: Transform.rotate(
                angle: _spinAnimation.value,
                child: _buildPetAvatar(),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPetAvatar() {
    final size = 200.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: [
            Colors.white.withOpacity(0.1),
            AppTheme.dynamicColor.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.dynamicColor.withOpacity(0.4),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Body
          Positioned(
            top: 40,
            child: Container(
              width: 120,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.monetRose.withOpacity(0.9),
                    AppTheme.monetRose.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          
          // Face
          Positioned(
            top: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          
          // Eyes
          Positioned(
            top: 55,
            left: size / 2 - 35,
            child: _buildEye(),
          ),
          Positioned(
            top: 55,
            right: size / 2 - 35,
            child: _buildEye(),
          ),
          
          // Nose
          Positioned(
            top: 85,
            child: Container(
              width: 8,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.monetRose.withOpacity(0.8),
              ),
            ),
          ),
          
          // Mouth
          Positioned(
            top: 95,
            child: _buildMouth(),
          ),
          
          // Blush
          if (widget.mood == 'happy' || widget.mood == 'excited')
            Positioned(
              top: 75,
              left: size / 2 - 50,
              child: _buildBlush(),
            ),
          if (widget.mood == 'happy' || widget.mood == 'excited')
            Positioned(
              top: 75,
              right: size / 2 - 50,
              child: _buildBlush(),
            ),
          
          // Ears
          Positioned(
            top: 15,
            left: size / 2 - 55,
            child: _buildEar(),
          ),
          Positioned(
            top: 15,
            right: size / 2 - 55,
            child: Transform.scale(scaleX: -1, child: _buildEar()),
          ),
          
          // Raccoon mask
          Positioned(
            top: 45,
            child: CustomPaint(
              size: Size(100, 40),
              painter: RaccoonMaskPainter(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEye() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 12,
      height: _eyeOpen ? 16 : 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_eyeOpen ? 6 : 1),
        color: const Color(0xFF2D1B4E),
      ),
    );
  }
  
  Widget _buildMouth() {
    if (widget.mood == 'happy' || widget.mood == 'excited') {
      return CustomPaint(
        size: const Size(20, 10),
        painter: HappyMouthPainter(),
      );
    } else if (widget.mood == 'sad') {
      return CustomPaint(
        size: const Size(16, 8),
        painter: SadMouthPainter(),
      );
    }
    return Container(
      width: 12,
      height: 2,
      color: AppTheme.monetRose.withOpacity(0.8),
    );
  }
  
  Widget _buildBlush() {
    return Container(
      width: 24,
      height: 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.pink.withOpacity(0.3),
      ),
    );
  }
  
  Widget _buildEar() {
    return CustomPaint(
      size: const Size(25, 35),
      painter: EarPainter(),
    );
  }
}

// ============================================
// CUSTOM PAINTERS
// ============================================

class RaccoonMaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    // Left eye mask
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width / 4, size.height / 2), width: 24, height: 20),
      paint,
    );
    
    // Right eye mask
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 3 / 4, size.height / 2), width: 24, height: 20),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HappyMouthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.monetRose.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..quadraticBezierTo(size.width / 2, 0, size.width, size.height / 2);
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SadMouthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 0);
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = AppTheme.monetRose
      ..style = PaintingStyle.fill;
    
    final innerPaint = Paint()
      ..color = Colors.pink.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(size.width, size.height * 0.8, 0, size.height)
      ..close();
    
    canvas.drawPath(path, outerPaint);
    
    final innerPath = Path()
      ..moveTo(size.width / 2, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.7, 0, size.height * 0.8)
      ..close();
    
    canvas.drawPath(innerPath, innerPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================
// FLUID BACKGROUND WIDGET
// ============================================

class FluidBackground extends StatefulWidget {
  final Widget child;
  
  const FluidBackground({super.key, required this.child});
  
  @override
  State<FluidBackground> createState() => _FluidBackgroundState();
}

class _FluidBackgroundState extends State<FluidBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.vanGoghNight,
                AppTheme.vanGoghTwilight,
                AppTheme.vanGoghPurple,
              ],
            ),
          ),
        ),
        
        // Fluid orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final value = _controller.value;
            return Stack(
              children: [
                // Orb 1
                Positioned(
                  top: -50 + math.sin(value * 2 * pi) * 30,
                  left: -50 + math.cos(value * 2 * pi) * 20,
                  child: _buildOrb(200, AppTheme.dynamicColor.withOpacity(0.4)),
                ),
                // Orb 2
                Positioned(
                  bottom: -40 + math.cos(value * 2 * pi + 1) * 25,
                  right: -40 + math.sin(value * 2 * pi + 1) * 25,
                  child: _buildOrb(180, AppTheme.monetLavender.withOpacity(0.3)),
                ),
                // Orb 3
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3 + math.sin(value * 2 * pi + 2) * 40,
                  left: MediaQuery.of(context).size.width * 0.4 + math.cos(value * 2 * pi + 2) * 30,
                  child: _buildOrb(150, AppTheme.monetPeach.withOpacity(0.25)),
                ),
              ],
            );
          },
        ),
        
        // Content
        widget.child,
      ],
    );
  }
  
  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

// ============================================
// GLASS CARD WIDGET
// ============================================

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ============================================
// COIN ANIMATION WIDGET
// ============================================

class CoinFloatAnimation extends StatefulWidget {
  final int amount;
  final VoidCallback onComplete;
  
  const CoinFloatAnimation({
    super.key,
    required this.amount,
    required this.onComplete,
  });
  
  @override
  State<CoinFloatAnimation> createState() => _CoinFloatAnimationState();
}

class _CoinFloatAnimationState extends State<CoinFloatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0),
      ),
    );
    
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -100),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    
    _controller.forward().then((_) => widget.onComplete());
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
        return Transform.translate(
          offset: _positionAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Text(
              '+${widget.amount}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================
// MAIN APP
// ============================================

void main() {
  runApp(const AuraPetApp());
}

class AuraPetApp extends StatelessWidget {
  const AuraPetApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura-Pet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _coins = 150;
  int _mealsToday = 3;
  int _waterIntake = 1200;
  int _streak = 5;
  String _petMood = 'happy';
  
  final GlobalKey<_PetSpriteState> _petKey = GlobalKey();
  
  void _onPetTap() {
    setState(() {
      _petMood = _petMood == 'happy' ? 'excited' : 'happy';
      _coins += 2;
    });
    _petKey.currentState?.playBounce();
  }
  
  void _simulateMealCapture() {
    // Simulate AI analysis
    final foods = [
      {'name': '芝士蛋糕', 'calories': 420, 'emoji': '🍰'},
      {'name': '蔬菜沙拉', 'calories': 180, 'emoji': '🥗'},
      {'name': '巧克力', 'calories': 550, 'emoji': '🍫'},
    ];
    
    final food = foods[(_mealsToday) % foods.length];
    
    setState(() {
      _mealsToday++;
      _streak++;
      _petMood = 'excited';
      _coins += 15;
    });
    
    _petKey.currentState?.playSpin();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food['emoji']} ${food['name']} - +15 金币!'),
        backgroundColor: AppTheme.accentPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
  
  void _addWater() {
    setState(() {
      _waterIntake += 250;
      if (_waterIntake >= 2000) {
        _petMood = 'excited';
      }
    });
    _petKey.currentState?.playBounce();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aura-Pet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            '$_coins',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Pet
              Expanded(
                flex: 3,
                child: Center(
                  child: PetSprite(
                    key: _petKey,
                    mood: _petMood,
                    onTap: _onPetTap,
                  ),
                ),
              ),
              
              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard('🍽️', '$_mealsToday', '今日餐食'),
                    const SizedBox(width: 12),
                    _buildStatCard('💧', '$_waterIntake', 'ml'),
                    const SizedBox(width: 12),
                    _buildStatCard('🔥', '$_streak', '连续天数'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        onTap: _simulateMealCapture,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('📸', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text('拍照记录', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        onTap: _addWater,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🥤', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text('+250ml', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // More actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        onTap: _onPetTap,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('👋', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text('摸摸头', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('😺', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text('戳肚子', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem('🏠', '首页', true),
                _buildNavItem('📊', '看板', false),
                _buildNavItem('🛒', '商店', false),
                _buildNavItem('👤', '我的', false),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String emoji, String value, String label) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavItem(String emoji, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          emoji,
          style: TextStyle(
            fontSize: 24,
            color: active ? AppTheme.accentPrimary : Colors.white.withOpacity(0.5),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? AppTheme.accentPrimary : Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
