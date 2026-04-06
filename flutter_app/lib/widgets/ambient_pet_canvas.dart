import 'dart:math';
import 'package:flutter/material.dart';
import '../services/monet_clock.dart';

/// 莫奈风格环境光宠物画布
/// 根据时间段自动调整光晕效果
class AmbientPetCanvas extends StatefulWidget {
  final String mood;
  final int auraScore;
  final double size;
  final String petEmoji;
  final bool showBreath;
  final bool showGlow;
  
  const AmbientPetCanvas({
    super.key,
    this.mood = 'happy',
    this.auraScore = 80,
    this.size = 200,
    this.petEmoji = '🐻',
    this.showBreath = true,
    this.showGlow = true,
  });

  @override
  State<AmbientPetCanvas> createState() => _AmbientPetCanvasState();
}

class _AmbientPetCanvasState extends State<AmbientPetCanvas>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _glowController;
  late AnimationController _wobbleController;
  late Animation<double> _breathScale;
  late Animation<double> _glowOpacity;
  late Animation<double> _glowSpread;
  late Animation<double> _wobbleAngle;

  @override
  void initState() {
    super.initState();
    
    // 呼吸动画
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _getBreathDuration()),
    )..repeat(reverse: true);

    _breathScale = Tween<double>(
      begin: 0.97,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _breathController,
      curve: NaturalBreathCurve(),
    ));

    // 光晕动画
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _glowOpacity = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _glowSpread = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // 摇晃动画
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _wobbleAngle = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _wobbleController,
      curve: Curves.easeInOut,
    ));
  }

  int _getBreathDuration() {
    // 根据心情调整呼吸速度
    switch (widget.mood) {
      case 'excited':
        return 1500; // 快速呼吸
      case 'sleepy':
        return 4000; // 慢速呼吸
      case 'happy':
        return 2500; // 正常呼吸
      default:
        return 3000;
    }
  }

  @override
  void didUpdateWidget(AmbientPetCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.mood != oldWidget.mood) {
      _breathController.duration = Duration(
        milliseconds: _getBreathDuration(),
      );
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _glowController.dispose();
    _wobbleController.dispose();
    super.dispose();
  }

  Color _getMoodColor() {
    switch (widget.mood) {
      case 'happy':
        return const Color(0xFFFFE4B5); // 温暖金
      case 'excited':
        return const Color(0xFFFF9C6B); // 兴奋橙
      case 'sleepy':
        return const Color(0xFFB5D0FF); // 慵懒蓝
      case 'sad':
        return const Color(0xFFB8B8D0); // 忧郁灰
      case 'celebrating':
        return const Color(0xFFFFD93D); // 庆祝金
      case 'eating':
        return const Color(0xFFFFB5B5); // 进食粉
      case 'diving':
        return const Color(0xFF7BC4FF); // 潜水蓝
      default:
        return const Color(0xFFE8D5B5); // 正常米
    }
  }

  double _getAuraIntensity() {
    return widget.auraScore / 100;
  }

  @override
  Widget build(BuildContext context) {
    final monetColors = MonetColors.getCurrentColors();
    final moodColor = _getMoodColor();
    final auraIntensity = _getAuraIntensity();

    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathController,
        _glowController,
        _wobbleController,
      ]),
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.showBreath ? _wobbleAngle.value : 0,
          child: Transform.scale(
            scale: widget.showBreath ? _breathScale.value : 1.0,
            child: SizedBox(
              width: widget.size * 1.5,
              height: widget.size * 1.5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 环境光晕层
                  if (widget.showGlow) ...[
                    // 外层大光晕
                    Positioned(
                      child: Container(
                        width: widget.size * _glowSpread.value,
                        height: widget.size * _glowSpread.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: moodColor.withOpacity(
                                  _glowOpacity.value * auraIntensity * 0.5),
                              blurRadius: 40 * auraIntensity,
                              spreadRadius: 10 * auraIntensity,
                            ),
                            // 深夜模式额外光晕
                            if (monetColors.phase == MonetTimePhase.night)
                              BoxShadow(
                                color: monetColors.petGlow.withOpacity(
                                    _glowOpacity.value * 0.3),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                    // 内层亮光
                    Positioned(
                      child: Container(
                        width: widget.size * 0.8,
                        height: widget.size * 0.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              moodColor.withOpacity(0.4 * auraIntensity),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  // 宠物主体
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: moodColor.withOpacity(
                              auraIntensity * 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 莫奈色调背景
                        Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.3, -0.3),
                              colors: [
                                moodColor.withOpacity(0.3),
                                Colors.white,
                              ],
                            ),
                          ),
                        ),
                        // 宠物表情
                        Text(
                          widget.petEmoji,
                          style: TextStyle(
                            fontSize: widget.size * 0.5,
                          ),
                        ),
                        // 装饰性光点
                        ..._buildSparkles(monetColors),
                      ],
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

  List<Widget> _buildSparkles(MonetColors colors) {
    final sparkles = <Widget>[];
    final random = Random();
    
    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * 2 * pi;
      final distance = widget.size * 0.4;
      final sparkleSize = 4.0 + random.nextDouble() * 4;
      
      sparkles.add(
        Positioned(
          left: widget.size / 2 + cos(angle) * distance - sparkleSize / 2,
          top: widget.size / 2 + sin(angle) * distance - sparkleSize / 2,
          child: AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.3 + _glowOpacity.value * 0.5,
                child: Container(
                  width: sparkleSize,
                  height: sparkleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.petGlow,
                    boxShadow: [
                      BoxShadow(
                        color: colors.petGlow.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    
    return sparkles;
  }
}

/// 自然呼吸曲线
class NaturalBreathCurve extends Curve {
  @override
  double transformInternal(double t) {
    // 不对称呼吸：吸气快，呼气慢
    if (t < 0.4) {
      // 吸气阶段 (0-40%): 快速上升
      return 2.5 * t * t;
    } else {
      // 呼气阶段 (40-100%): 缓慢下降
      final s = (t - 0.4) / 0.6;
      return 1 - pow(1 - s, 2);
    }
  }
}
