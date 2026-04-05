import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 营养反馈 P8 - 比心小熊 + 营养雷达图缝合
class NutritionP8Screen extends StatefulWidget {
  const NutritionP8Screen({super.key});

  @override
  State<NutritionP8Screen> createState() => _NutritionP8ScreenState();
}

class _NutritionP8ScreenState extends State<NutritionP8Screen>
    with TickerProviderStateMixin {
  // 营养数据 (0-100)
  double _protein = 75;
  double _carbs = 60;
  double _fat = 45;
  double _fiber = 80;
  double _vitamins = 70;
  
  late AnimationController _heartController;
  late AnimationController _radarController;
  late AnimationController _celebrationController;
  late Animation<double> _heartAnimation;
  late Animation<double> _radarAnimation;
  late Animation<double> _celebrationAnimation;

  @override
  void initState() {
    super.initState();
    
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _heartAnimation = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
    
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _radarAnimation = CurvedAnimation(
      parent: _radarController,
      curve: Curves.elasticOut,
    );
    
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _celebrationAnimation = Tween<double>(begin: 0, end: 1).animate(_radarController);
    
    _radarController.forward();
  }

  @override
  void dispose() {
    _heartController.dispose();
    _radarController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  double get _overallScore {
    return (_protein + _carbs + _fat + _fiber + _vitamins) / 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF5F5),
              Color(0xFFFFE8E8),
              Color(0xFFF5E6E6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildScoreCard(),
                      const SizedBox(height: 24),
                      _buildHeartingPetWithRadar(),
                      const SizedBox(height: 24),
                      _buildNutritionDetails(),
                      const SizedBox(height: 24),
                      _buildRecommendation(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Nutrition Balance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: Color(0xFFFF8BA0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    final isBalanced = _overallScore >= 70;
    
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBalanced
              ? [const Color(0xFFFFD700), const Color(0xFFFF8BA0)]
              : [const Color(0xFFFFB74D), const Color(0xFFFF8BA0)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: (isBalanced ? const Color(0xFFFFD700) : const Color(0xFFFFB74D))
                .withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Aura Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nutrition Aura',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _overallScore),
                    duration: const Duration(milliseconds: 1500),
                    builder: (context, value, child) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 4),
                    child: Text(
                      '/100',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const Spacer(),
          
          // 状态徽章
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isBalanced ? '🌟' : '💪',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 6),
                Text(
                  isBalanced ? 'Well Balanced!' : 'Almost There!',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartingPetWithRadar() {
    return AnimatedBuilder(
      animation: Listenable.merge([_heartAnimation, _radarAnimation, _celebrationAnimation]),
      builder: (context, child) {
        return SizedBox(
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 雷达图 (作为背景)
              Positioned(
                right: 0,
                child: Opacity(
                  opacity: _radarAnimation.value,
                  child: Transform.scale(
                    scale: 0.8 + _radarAnimation.value * 0.2,
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _NutritionRadarPainter(
                        values: [_protein, _carbs, _fat, _fiber, _vitamins],
                        animationValue: _radarAnimation.value,
                      ),
                    ),
                  ),
                ),
              ),
              
              // 小熊
              Positioned(
                left: 20,
                child: Transform.scale(
                  scale: _heartAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Aura 光晕
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8BA0).withValues(alpha: 0.4 * _heartAnimation.value),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      
                      // 小熊身体
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // 脸部
                            Positioned(
                              top: 25,
                              left: 15,
                              child: Container(
                                width: 90,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                            
                            // 眼睛
                            Positioned(
                              top: 45,
                              left: 35,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2D3436),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 2,
                                      left: 2,
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 45,
                              right: 35,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2D3436),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 2,
                                      left: 2,
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // 腮红
                            Positioned(
                              bottom: 38,
                              left: 22,
                              child: Container(
                                width: 14,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB5B5).withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 38,
                              right: 22,
                              child: Container(
                                width: 14,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB5B5).withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            
                            // 嘴巴 - 开心微笑
                            Positioned(
                              bottom: 26,
                              left: 50,
                              child: Container(
                                width: 20,
                                height: 12,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Color(0xFF2D3436), width: 2),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            
                            // 比心手势
                            Positioned(
                              bottom: 20,
                              right: 5,
                              child: Transform.scale(
                                scale: _heartAnimation.value,
                                child: Transform.rotate(
                                  angle: -0.3,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF8BA0),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF8BA0).withValues(alpha: 0.5),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: const Text('💕', style: TextStyle(fontSize: 24)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 连接线 (小熊到雷达图)
                      CustomPaint(
                        size: const Size(180, 120),
                        painter: _ConnectionLinePainter(
                          radarProgress: _radarAnimation.value,
                          heartPulse: _heartAnimation.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 庆祝粒子
              if (_overallScore >= 70)
                ...List.generate(6, (index) {
                  final angle = (index / 6) * 2 * math.pi + _celebrationAnimation.value * 2 * math.pi;
                  final radius = 100 + math.sin(_celebrationAnimation.value * math.pi * 4 + index) * 20;
                  return Positioned(
                    left: 60 + math.cos(angle) * radius,
                    top: 90 + math.sin(angle) * radius,
                    child: Opacity(
                      opacity: (1 - _celebrationAnimation.value).clamp(0.0, 1.0),
                      child: Text(
                        ['✨', '💫', '⭐', '💗', '🌟', '💕'][index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildNutritionBar('Protein', _protein, const Color(0xFF7BC4FF), '🥚'),
          const SizedBox(height: 12),
          _buildNutritionBar('Carbs', _carbs, const Color(0xFFFFB74D), '🍞'),
          const SizedBox(height: 12),
          _buildNutritionBar('Fat', _fat, const Color(0xFFFF8BA0), '🥑'),
          const SizedBox(height: 12),
          _buildNutritionBar('Fiber', _fiber, const Color(0xFF81C784), '🥬'),
          const SizedBox(height: 12),
          _buildNutritionBar('Vitamins', _vitamins, const Color(0xFFBA68C8), '🍊'),
        ],
      ),
    );
  }

  Widget _buildNutritionBar(String label, double value, Color color, String emoji) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF636E72),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value),
                duration: const Duration(milliseconds: 1500),
                builder: (context, v, child) {
                  return FractionallySizedBox(
                    widthFactor: v / 100,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 35,
          child: Text(
            '${value.toInt()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendation() {
    final suggestions = <String>[];
    
    if (_protein < 60) suggestions.add('Add more protein like eggs or chicken 🥚');
    if (_carbs < 60) suggestions.add('Include whole grains for energy 🍞');
    if (_fat > 70) suggestions.add('Reduce fatty foods for balance 🥑');
    if (_fiber < 60) suggestions.add('Eat more vegetables and fruits 🥬');
    if (_vitamins < 60) suggestions.add('Add colorful fruits for vitamins 🍊');
    
    if (suggestions.isEmpty) {
      suggestions.add('Perfect balance! Keep it up! 🌟');
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'Suggestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...suggestions.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              s,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF636E72),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

/// 营养雷达图 Painter
class _NutritionRadarPainter extends CustomPainter {
  final List<double> values;
  final double animationValue;
  
  _NutritionRadarPainter({
    required this.values,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final sides = values.length;
    
    // 背景网格
    final gridPaint = Paint()
      ..color = const Color(0xFFFFE4E4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int i = 1; i <= 4; i++) {
      final r = radius * i / 4;
      final path = Path();
      for (int j = 0; j <= sides; j++) {
        final angle = (j / sides) * 2 * math.pi - math.pi / 2;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }
    
    // 轴线
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }
    
    // 数据区域
    final dataPath = Path();
    final colors = [
      const Color(0xFF7BC4FF),
      const Color(0xFFFFB74D),
      const Color(0xFFFF8BA0),
      const Color(0xFF81C784),
      const Color(0xFFBA68C8),
    ];
    
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi - math.pi / 2;
      final r = radius * (values[i] / 100) * animationValue;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        final prevAngle = ((i - 1) / sides) * 2 * math.pi - math.pi / 2;
        final prevR = radius * (values[i - 1] / 100) * animationValue;
        final prevX = center.dx + prevR * math.cos(prevAngle);
        final prevY = center.dy + prevR * math.sin(prevAngle);
        final cpX = (prevX + x) / 2;
        final cpY = (prevY + y) / 2;
        dataPath.quadraticBezierTo(cpX, cpY, x, y);
      }
    }
    dataPath.close();
    
    // 填充
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF8BA0).withValues(alpha: 0.4),
          const Color(0xFFFFB74D).withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawPath(dataPath, fillPaint);
    
    // 边框
    final borderPaint = Paint()
      ..color = const Color(0xFFFF8BA0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawPath(dataPath, borderPaint);
    
    // 数据点
    final dotPaint = Paint()..color = Colors.white;
    final dotBorderPaint = Paint()
      ..color = const Color(0xFFFF8BA0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi - math.pi / 2;
      final r = radius * (values[i] / 100) * animationValue;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), 6, dotPaint);
      canvas.drawCircle(Offset(x, y), 6, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NutritionRadarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// 连接线 Painter
class _ConnectionLinePainter extends CustomPainter {
  final double radarProgress;
  final double heartPulse;
  
  _ConnectionLinePainter({
    required this.radarProgress,
    required this.heartPulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (radarProgress < 0.5) return;
    
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFF8BA0).withValues(alpha: 0.6 * heartPulse),
          const Color(0xFFFFD700).withValues(alpha: 0.3 * radarProgress),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(size.width * 0.7, size.height * 0.6);
    
    // 波浪连接
    for (double t = 0; t <= 1; t += 0.1) {
      final x = size.width * 0.7 + t * size.width * 0.3;
      final y = size.height * 0.6 + math.sin(t * math.pi * 3 + radarProgress * 10) * 10;
      path.lineTo(x, y);
    }
    
    canvas.drawPath(path, paint);
    
    // 闪光点
    final glowX = size.width * 0.7 + radarProgress * size.width * 0.3;
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.8 * heartPulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    
    canvas.drawCircle(Offset(glowX, size.height * 0.6), 4, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _ConnectionLinePainter oldDelegate) {
    return oldDelegate.radarProgress != radarProgress || oldDelegate.heartPulse != heartPulse;
  }
}
