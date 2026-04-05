import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/aura_theme.dart';

/// 微拟真Q萌小熊画布
/// 特点：亮眼睛、无辜眼神、毛茸茸质感、比心手势
class QRaccoonCanvas extends StatefulWidget {
  final String mood;
  final int auraScore;
  final double size;
  final bool showHeart;
  final bool showHeartBubbles;
  final String? speakingText;
  
  const QRaccoonCanvas({
    super.key,
    this.mood = 'happy',
    this.auraScore = 80,
    this.size = 200,
    this.showHeart = true,
    this.showHeartBubbles = false,
    this.speakingText,
  });

  @override
  State<QRaccoonCanvas> createState() => _QRaccoonCanvasState();
}

class _QRaccoonCanvasState extends State<QRaccoonCanvas>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _heartFloatController;
  late AnimationController _sparkleController;
  late AnimationController _heartBubbleController;
  late Animation<double> _breathScale;
  late Animation<double> _heartFloat;
  late List<_HeartBubble> _heartBubbles;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // 呼吸动画
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _breathScale = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // 心形漂浮动画
    _heartFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _heartFloat = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _heartFloatController, curve: Curves.easeInOut),
    );

    // 眼睛闪烁动画
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    // 心形气泡
    _initHeartBubbles();
    _heartBubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  void _initHeartBubbles() {
    _heartBubbles = List.generate(5, (index) {
      return _HeartBubble(
        angle: (index / 5) * 2 * pi,
        size: 12 + _random.nextDouble() * 8,
        speed: 0.5 + _random.nextDouble() * 0.5,
        delay: _random.nextDouble(),
      );
    });
  }

  @override
  void didUpdateWidget(QRaccoonCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showHeartBubbles != oldWidget.showHeartBubbles && widget.showHeartBubbles) {
      _initHeartBubbles();
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _heartFloatController.dispose();
    _sparkleController.dispose();
    _heartBubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathController,
        _heartFloatController,
        _sparkleController,
        _heartBubbleController,
      ]),
      builder: (context, child) {
        return SizedBox(
          width: widget.size * 2,
          height: widget.size * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Aura 光晕层
              _buildAuraGlow(),
              
              // 心形气泡层
              if (widget.showHeartBubbles) _buildHeartBubbles(),
              
              // 小熊主体
              Transform.scale(
                scale: _breathScale.value,
                child: _buildRaccoon(),
              ),
              
              // 比心手势
              if (widget.showHeart) _buildHeartGesture(),
              
              // Aura 光圈
              _buildAuraRing(),
            ],
          ),
        );
      },
    );
  }

  /// Aura 光晕层
  Widget _buildAuraGlow() {
    final intensity = widget.auraScore / 100;
    final glowSize = widget.size * (1.2 + _sparkleController.value * 0.1);
    
    return Container(
      width: glowSize,
      height: glowSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AuraPetTheme.auraGlow.withValues(alpha: 0.4 * intensity),
            AuraPetTheme.auraGlowSoft.withValues(alpha: 0.2 * intensity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// 心形气泡
  Widget _buildHeartBubbles() {
    return SizedBox(
      width: widget.size * 1.8,
      height: widget.size * 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: _heartBubbles.map((bubble) {
          final progress = (_heartBubbleController.value + bubble.delay) % 1.0;
          final distance = progress * widget.size * 0.8;
          final opacity = (sin(progress * pi) * 0.6 + 0.4) * (1 - progress);
          
          return Positioned(
            left: widget.size + cos(bubble.angle) * distance - bubble.size / 2,
            top: widget.size + sin(bubble.angle) * distance - bubble.size / 2,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.5 + progress * 0.5,
                child: Container(
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AuraPetTheme.heartLight.withValues(alpha: 0.8),
                        AuraPetTheme.heartPink.withValues(alpha: 0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AuraPetTheme.heartPink.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('❤️', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 微拟真Q萌小熊
  Widget _buildRaccoon() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: [
            AuraPetTheme.raccoonLight,
            AuraPetTheme.raccoonGray,
            AuraPetTheme.raccoonDark,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AuraPetTheme.raccoonDark.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 毛茸茸纹理层
          _buildFurTexture(),
          
          // 脸部
          _buildFace(),
          
          // 眼睛
          _buildEyes(),
          
          // 鼻子
          _buildNose(),
          
          // 腮红
          _buildBlush(),
          
          // 嘴巴
          _buildMouth(),
        ],
      ),
    );
  }

  /// 毛茸茸纹理
  Widget _buildFurTexture() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// 脸部
  Widget _buildFace() {
    final faceSize = widget.size * 0.65;
    return Positioned(
      top: widget.size * 0.22,
      left: (widget.size - faceSize) / 2,
      child: Container(
        width: faceSize,
        height: faceSize * 0.75,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(faceSize * 0.4),
        ),
      ),
    );
  }

  /// 眼睛 - 亮晶晶无辜眼神
  Widget _buildEyes() {
    final eyeY = widget.size * 0.38;
    final eyeSize = widget.size * 0.15;
    final eyeSpacing = widget.size * 0.18;
    
    final sparkleIntensity = _sparkleController.value;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 左眼
        _buildSingleEye(
          left: widget.size / 2 - eyeSpacing - eyeSize / 2,
          top: eyeY,
          size: eyeSize,
          sparkleIntensity: sparkleIntensity,
        ),
        // 右眼
        _buildSingleEye(
          left: widget.size / 2 + eyeSpacing - eyeSize / 2,
          top: eyeY,
          size: eyeSize,
          sparkleIntensity: sparkleIntensity,
        ),
      ],
    );
  }

  Widget _buildSingleEye({
    required double left,
    required double top,
    required double size,
    required double sparkleIntensity,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AuraPetTheme.noseBlack,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AuraPetTheme.noseBlack.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 眼睛高光
            Positioned(
              left: size * 0.2,
              top: size * 0.15,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  color: AuraPetTheme.eyeShine,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // 次高光
            Positioned(
              right: size * 0.25,
              bottom: size * 0.2,
              child: Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: BoxDecoration(
                  color: AuraPetTheme.eyeShine.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // 闪烁效果
            if (sparkleIntensity > 0.7)
              Positioned(
                left: size * 0.5,
                top: size * 0.1,
                child: Container(
                  width: size * 0.2,
                  height: size * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 鼻子
  Widget _buildNose() {
    final noseSize = widget.size * 0.1;
    return Positioned(
      top: widget.size * 0.52,
      left: (widget.size - noseSize) / 2,
      child: Container(
        width: noseSize,
        height: noseSize * 0.7,
        decoration: BoxDecoration(
          color: AuraPetTheme.noseBlack,
          borderRadius: BorderRadius.circular(noseSize * 0.3),
        ),
      ),
    );
  }

  /// 腮红
  Widget _buildBlush() {
    final blushSize = widget.size * 0.1;
    final blushY = widget.size * 0.52;
    final blushX = widget.size * 0.22;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 左腮红
        Container(
          width: blushSize,
          height: blushSize * 0.5,
          decoration: BoxDecoration(
            color: AuraPetTheme.accent.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(blushSize),
          ),
        ),
        SizedBox(width: widget.size * 0.3),
        // 右腮红
        Container(
          width: blushSize,
          height: blushSize * 0.5,
          decoration: BoxDecoration(
            color: AuraPetTheme.accent.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(blushSize),
          ),
        ),
      ],
    );
  }

  /// 嘴巴 - 微笑
  Widget _buildMouth() {
    final mouthY = widget.size * 0.62;
    final mouthWidth = widget.size * 0.15;
    final mouthHeight = widget.size * 0.06;
    
    return Positioned(
      top: mouthY,
      left: (widget.size - mouthWidth) / 2,
      child: Container(
        width: mouthWidth,
        height: mouthHeight,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AuraPetTheme.noseBlack,
              width: 2,
            ),
          ),
          borderRadius: BorderRadius.circular(mouthWidth),
        ),
      ),
    );
  }

  /// 比心手势
  Widget _buildHeartGesture() {
    final heartSize = widget.size * 0.25;
    final heartY = widget.size * 0.65 + _heartFloat.value;
    
    return Positioned(
      top: heartY,
      left: widget.size * 0.6,
      child: Transform.rotate(
        angle: -0.3,
        child: Container(
          width: heartSize,
          height: heartSize,
          decoration: BoxDecoration(
            gradient: AuraPetTheme.heartBubbleGradient,
            borderRadius: BorderRadius.circular(heartSize * 0.3),
            boxShadow: AuraPetTheme.heartShadow,
          ),
          child: const Center(
            child: Text('💕', style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }

  /// Aura 光圈
  Widget _buildAuraRing() {
    final intensity = widget.auraScore / 100;
    final ringSize = widget.size * 1.15 + _sparkleController.value * 5;
    
    return Container(
      width: ringSize,
      height: ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AuraPetTheme.auraGlow.withValues(alpha: 0.3 * intensity),
          width: 3,
        ),
      ),
    );
  }
}

/// 心形气泡数据
class _HeartBubble {
  final double angle;
  final double size;
  final double speed;
  final double delay;

  _HeartBubble({
    required this.angle,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

/// 心形飘浮动画 Widget
class FloatingHearts extends StatefulWidget {
  final bool isActive;
  final int heartCount;
  
  const FloatingHearts({
    super.key,
    this.isActive = false,
    this.heartCount = 5,
  });

  @override
  State<FloatingHearts> createState() => _FloatingHeartsState();
}

class _FloatingHeartsState extends State<FloatingHearts>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FloatingHeart> _hearts;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _initHearts();
  }

  void _initHearts() {
    _hearts = List.generate(widget.heartCount, (index) {
      return _FloatingHeart(
        x: _random.nextDouble(),
        startY: 0.8 + _random.nextDouble() * 0.2,
        speed: 0.3 + _random.nextDouble() * 0.4,
        size: 16 + _random.nextDouble() * 12,
        delay: _random.nextDouble(),
        wiggle: _random.nextDouble() * 2 - 1,
      );
    });
  }

  @override
  void didUpdateWidget(FloatingHearts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.heartCount != oldWidget.heartCount) {
      _initHearts();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _FloatingHeartsPainter(
            hearts: _hearts,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _FloatingHeart {
  final double x;
  final double startY;
  final double speed;
  final double size;
  final double delay;
  final double wiggle;

  _FloatingHeart({
    required this.x,
    required this.startY,
    required this.speed,
    required this.size,
    required this.delay,
    required this.wiggle,
  });
}

class _FloatingHeartsPainter extends CustomPainter {
  final List<_FloatingHeart> hearts;
  final double progress;

  _FloatingHeartsPainter({
    required this.hearts,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final heart in hearts) {
      final adjustedProgress = (progress + heart.delay) % 1.0;
      final y = size.height * (heart.startY - adjustedProgress * heart.speed);
      final x = size.width * heart.x + sin(adjustedProgress * pi * 4) * 20 * heart.wiggle;
      final opacity = sin(adjustedProgress * pi) * 0.6 + 0.4;
      final scale = 0.5 + adjustedProgress * 0.5;

      final paint = Paint()
        ..color = AuraPetTheme.heartPink.withValues(alpha: opacity * 0.7)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.scale(scale);
      
      // 绘制心形
      _drawHeart(canvas, Offset.zero, heart.size, paint);
      
      canvas.restore();
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(0, size * 0.3);
    path.cubicTo(-size * 0.5, -size * 0.3, -size, size * 0.1, 0, size);
    path.cubicTo(size, size * 0.1, size * 0.5, -size * 0.3, 0, size * 0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FloatingHeartsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
