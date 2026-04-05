import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 喝水追踪 P5 - 水波纹 CustomPainter + 潜水模式小熊
class WaterP5Screen extends StatefulWidget {
  const WaterP5Screen({super.key});

  @override
  State<WaterP5Screen> createState() => _WaterP5ScreenState();
}

class _WaterP5ScreenState extends State<WaterP5Screen>
    with TickerProviderStateMixin {
  int _glasses = 0;
  final int _targetGlasses = 8;
  bool _isDiving = false;
  
  late AnimationController _waveController;
  late AnimationController _bubbleController;
  late AnimationController _diveController;
  late Animation<double> _waveAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _diveAnimation;

  @override
  void initState() {
    super.initState();
    
    // 水波纹动画
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveController);
    
    // 泡泡动画
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(_bubbleController);
    
    // 潜水动画
    _diveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _diveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _diveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bubbleController.dispose();
    _diveController.dispose();
    super.dispose();
  }

  void _addGlass() {
    if (_glasses < _targetGlasses) {
      setState(() {
        _glasses++;
        if (_glasses >= 3) {
          _isDiving = true;
        }
      });
      _diveController.forward();
    }
  }

  void _removeGlass() {
    if (_glasses > 0) {
      setState(() {
        _glasses--;
        if (_glasses < 3) {
          _isDiving = false;
          _diveController.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 水波纹背景
                    _buildWaveBackground(),
                    
                    // 主内容
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWaterGlass(),
                        const SizedBox(height: 40),
                        _buildDivingPet(),
                        const SizedBox(height: 32),
                        _buildProgressIndicator(),
                      ],
                    ),
                    
                    // 泡泡
                    _buildBubbles(),
                  ],
                ),
              ),
              _buildBottomControls(),
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
              'Stay Hydrated',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1565C0),
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
              Icons.water_drop_outlined,
              color: Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveBackground() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(_waveAnimation.value, _glasses / _targetGlasses),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildWaterGlass() {
    return AnimatedBuilder(
      animation: _diveAnimation,
      builder: (context, child) {
        final progress = _diveAnimation.value;
        return Transform.translate(
          offset: Offset(0, progress * 20),
          child: Container(
            width: 180,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // 水位
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 272 * (_glasses / _targetGlasses),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF64B5F6),
                            Color(0xFF1976D2),
                            Color(0xFF0D47A1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // 波浪
                  if (_glasses > 0)
                    AnimatedBuilder(
                      animation: _waveAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _GlassWavePainter(_waveAnimation.value),
                          size: const Size(172, 30),
                        );
                      },
                    ),
                  
                  // 水滴装饰
                  Positioned(
                    right: 20,
                    top: 40,
                    child: Opacity(
                      opacity: _glasses / _targetGlasses,
                      child: const Text('💧', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivingPet() {
    return AnimatedBuilder(
      animation: Listenable.merge([_diveAnimation, _bubbleAnimation]),
      builder: (context, child) {
        final isDiving = _isDiving || _diveAnimation.value > 0.5;
        
        return Transform.translate(
          offset: Offset(0, 20 - _diveAnimation.value * 30),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 潜水气泡光晕
              if (isDiving)
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF64B5F6).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              
              // 小熊
              Transform.scale(
                scale: isDiving ? 0.9 : 1.0,
                child: Container(
                  width: 100,
                  height: 100,
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
                        top: 22,
                        left: 12,
                        child: Container(
                          width: 76,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(26),
                              topRight: Radius.circular(26),
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                        ),
                      ),
                      
                      // 潜水镜
                      if (isDiving) ...[
                        Positioned(
                          top: 28,
                          left: 18,
                          child: Container(
                            width: 28,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF64B5F6).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 28,
                          right: 18,
                          child: Container(
                            width: 28,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF64B5F6).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                      
                      // 眼睛
                      if (!isDiving) ...[
                        Positioned(
                          top: 38,
                          left: 30,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D3436),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 1,
                                  left: 1,
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
                          top: 38,
                          right: 30,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D3436),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 1,
                                  left: 1,
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
                      ],
                      
                      // 泡泡眼 (潜水时)
                      if (isDiving) ...[
                        Positioned(
                          top: 36,
                          left: 32,
                          child: _buildBubbleEye(),
                        ),
                        Positioned(
                          top: 36,
                          right: 32,
                          child: _buildBubbleEye(),
                        ),
                      ],
                      
                      // 腮红
                      Positioned(
                        bottom: 32,
                        left: 16,
                        child: Container(
                          width: 14,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB5B5).withValues(alpha: isDiving ? 0.9 : 0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 32,
                        right: 16,
                        child: Container(
                          width: 14,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB5B5).withValues(alpha: isDiving ? 0.9 : 0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      
                      // 嘴巴
                      Positioned(
                        bottom: 22,
                        left: 42,
                        child: Container(
                          width: 16,
                          height: isDiving ? 12 : 8,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFF2D3436),
                                width: 2,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(isDiving ? 12 : 8),
                              bottomRight: Radius.circular(isDiving ? 12 : 8),
                            ),
                          ),
                        ),
                      ),
                      
                      // 氧气罐 (潜水时)
                      if (isDiving)
                        Positioned(
                          bottom: 10,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('🫧', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBubbleEye() {
    return AnimatedBuilder(
      animation: _bubbleAnimation,
      builder: (context, child) {
        return Container(
          width: 12,
          height: 12 + _bubbleAnimation.value * 4,
          decoration: BoxDecoration(
            color: const Color(0xFF64B5F6).withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildBubbles() {
    return AnimatedBuilder(
      animation: _bubbleAnimation,
      builder: (context, child) {
        if (!_isDiving && _glasses < 3) return const SizedBox();
        
        return Stack(
          children: List.generate(8, (index) {
            final offset = (_bubbleAnimation.value + index * 0.125) % 1.0;
            return Positioned(
              left: 50 + (index % 4) * 80,
              bottom: 50 + offset * 200,
              child: Opacity(
                opacity: (1 - offset) * 0.6,
                child: Transform.scale(
                  scale: 0.5 + offset * 0.5,
                  child: const Text('🫧', style: TextStyle(fontSize: 16)),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withValues(alpha: 0.2),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '💧',
            style: TextStyle(
              fontSize: 24,
              color: _glasses >= _targetGlasses ? const Color(0xFF4CAF50) : const Color(0xFF1976D2),
            ),
          ),
          const SizedBox(width: 8),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: _glasses),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Text(
                '$value / $_targetGlasses',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _glasses >= _targetGlasses ? const Color(0xFF4CAF50) : const Color(0xFF1565C0),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            _glasses >= _targetGlasses ? '🎉' : 'glasses',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Row(
        children: [
          // 减少按钮
          GestureDetector(
            onTap: _removeGlass,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.2),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.remove_rounded,
                color: Color(0xFF1976D2),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 添加按钮
          Expanded(
            child: GestureDetector(
              onTap: _addGlass,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _glasses >= _targetGlasses
                        ? [const Color(0xFF4CAF50), const Color(0xFF81C784)]
                        : [const Color(0xFF1976D2), const Color(0xFF64B5F6)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: (_glasses >= _targetGlasses
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF1976D2)).withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _glasses >= _targetGlasses ? Icons.check_circle_rounded : Icons.add_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _glasses >= _targetGlasses ? 'Target Reached!' : 'Add Glass',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 水波纹 Painter
class _WavePainter extends CustomPainter {
  final double wavePhase;
  final double waterLevel;
  
  _WavePainter(this.wavePhase, this.waterLevel);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF64B5F6).withValues(alpha: 0.1),
          const Color(0xFF1976D2).withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final path = Path();
    final waveHeight = 8.0;
    final baseY = size.height * (1 - waterLevel);
    
    path.moveTo(0, size.height);
    path.lineTo(0, baseY);
    
    for (double x = 0; x <= size.width; x++) {
      final y = baseY + math.sin((x / size.width * 2 * math.pi) + wavePhase) * waveHeight;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase || oldDelegate.waterLevel != waterLevel;
  }
}

/// 玻璃杯波浪 Painter
class _GlassWavePainter extends CustomPainter {
  final double phase;
  
  _GlassWavePainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + math.sin((x / size.width * 4 * math.pi) + phase) * 6;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GlassWavePainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
