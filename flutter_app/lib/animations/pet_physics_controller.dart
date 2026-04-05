import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/pet_state.dart';

/// ============================================
// AURA-PET: 宠物物理动画控制器
// 包含摸头反馈、喂食缩放、果冻弹动
// ============================================

class PetPhysicsController extends StatefulWidget {
  final PetState petState;
  final VoidCallback? onTap;
  final Function(String phrase)? onSpeak;
  final Widget child;

  const PetPhysicsController({
    super.key,
    required this.petState,
    required this.child,
    this.onTap,
    this.onSpeak,
  });

  @override
  State<PetPhysicsController> createState() => _PetPhysicsControllerState();
}

class _PetPhysicsControllerState extends State<PetPhysicsController>
    with TickerProviderStateMixin {
  
  // 物理动画控制器
  late AnimationController _springController;  // 弹簧反弹
  late AnimationController _squishController;  // 挤压变形
  late AnimationController _wobbleController;  // 果冻晃动
  late AnimationController _feedController;   // 喂食缩放
  
  // 物理参数
  double _springX = 0;
  double _springY = 0;
  double _squishScaleX = 1.0;
  double _squishScaleY = 1.0;
  double _wobbleAngle = 0;
  double _feedScale = 1.0;
  
  // 果冻参数
  static const double _stiffness = 180.0;   // 弹簧刚度
  static const double _damping = 12.0;     // 阻尼
  static const double _mass = 1.0;          // 质量
  
  // 速度
  double _velocityX = 0;
  double _velocityY = 0;
  
  @override
  void initState() {
    super.initState();
    
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(_updateSpringPhysics);
    
    _squishController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(_updateWobble);
    
    _feedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(_updateFeedScale);
  }

  // ========== 弹簧物理更新 ==========
  void _updateSpringPhysics() {
    if (!mounted) return;
    
    // 弹簧物理公式：F = -kx - dv
    // k = stiffness, d = damping, x = displacement, v = velocity
    
    final dt = 0.016; // ~60fps
    
    // 计算弹簧力
    final springForceX = -_stiffness * _springX;
    final springForceY = -_stiffness * _springY;
    
    // 计算阻尼力
    final dampingForceX = -_damping * _velocityX;
    final dampingForceY = -_damping * _velocityY;
    
    // 加速度 F = ma, a = F/m
    final accX = (springForceX + dampingForceX) / _mass;
    final accY = (springForceY + dampingForceY) / _mass;
    
    // 更新速度
    _velocityX += accX * dt;
    _velocityY += accY * dt;
    
    // 更新位置
    _springX += _velocityX * dt;
    _springY += _velocityY * dt;
    
    // 检查是否静止
    if (_springX.abs() < 0.001 && _springY.abs() < 0.001 &&
        _velocityX.abs() < 0.001 && _velocityY.abs() < 0.001) {
      _springX = 0;
      _springY = 0;
      _springController.stop();
    }
    
    setState(() {});
  }

  // ========== 果冻晃动更新 ==========
  void _updateWobble() {
    if (!mounted) return;
    
    // 衰减的正弦波
    final progress = _wobbleController.value;
    final decay = 1 - progress;
    _wobbleAngle = math.sin(progress * math.pi * 6) * 0.1 * decay;
    
    setState(() {});
  }

  // ========== 喂食缩放更新 ==========
  void _updateFeedScale() {
    if (!mounted) return;
    
    final progress = _feedController.value;
    
    if (progress < 0.3) {
      // 按下
      final t = progress / 0.3;
      _feedScale = 1.0 - 0.15 * _easeOutCubic(t);
      _squishScaleX = 1.0 + 0.1 * _easeOutCubic(t);
      _squishScaleY = 1.0 - 0.1 * _easeOutCubic(t);
    } else if (progress < 0.5) {
      // 弹起
      final t = (progress - 0.3) / 0.2;
      _feedScale = 0.85 + 0.35 * _easeOutBack(t);
      _squishScaleX = 1.1 - 0.1 * _easeOutBack(t);
      _squishScaleY = 0.9 + 0.1 * _easeOutBack(t);
    } else {
      // 回弹
      final t = (progress - 0.5) / 0.5;
      _feedScale = 1.2 - 0.2 * _easeOutElastic(t);
      _squishScaleX = 1.0;
      _squishScaleY = 1.0;
    }
    
    setState(() {});
  }

  // ========== 缓动函数 ==========
  double _easeOutCubic(double t) => 1 - pow(1 - t, 3).toDouble();
  
  double _easeOutBack(double t) {
    const c1 = 1.70158;
    const c3 = c1 + 1;
    return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2);
  }
  
  double _easeOutElastic(double t) {
    if (t == 0 || t == 1) return t;
    return pow(2, -10 * t) * sin((t * 10 - 0.75) * (2 * pi) / 3) + 1;
  }

  // ========== 触摸处理 ==========
  void _onPanStart(DragStartDetails details) {
    _springController.stop();
    _velocityX = 0;
    _velocityY = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // 跟随手指移动，带轻微延迟
    setState(() {
      _springX += details.delta.dx * 0.3;
      _springY += details.delta.dy * 0.3;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // 释放时触发弹簧回弹
    _velocityX = details.velocity.pixelsPerSecond.dx * 0.01;
    _velocityY = details.velocity.pixelsPerSecond.dy * 0.01;
    _springController.repeat();
  }

  void _onTapDown(TapDownDetails details) {
    // 点击触发挤压
    _squishController.forward(from: 0);
  }

  void _onTap() {
    // 果冻晃动
    _wobbleController.forward(from: 0);
    
    // 触发回调
    widget.onTap?.call();
  }

  // ========== 公共方法 ==========
  
  /// 摸头反馈
  void triggerHeadPat() {
    // 轻微果冻晃动 + 缩小
    _wobbleController.forward(from: 0);
    _feedController.forward(from: 0);
    _feedController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _feedController.reset();
      }
    });
  }
  
  /// 喂食缩放
  void triggerFeedAnimation() {
    _feedController.forward(from: 0);
    _feedController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _feedController.reset();
      }
    });
  }
  
  /// 跳跃动画
  void triggerJump() {
    _wobbleController.forward(from: 0);
    
    // 上下弹跳
    final jumpAnimation = AnimationController(
      vsync: context,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
      final t = jumpAnimation.value;
      if (t < 0.5) {
        _springY = -30 * _easeOutCubic(t * 2);
      } else {
        _springY = -30 * (1 - _easeOutCubic((t - 0.5) * 2));
      }
      setState(() {});
    });
    
    jumpAnimation.forward().then((_) {
      jumpAnimation.dispose();
      _springY = 0;
      setState(() {});
    });
  }
  
  /// 开心旋转
  void triggerSpin() {
    _wobbleController.forward(from: 0);
    // 可以添加旋转动画
  }

  @override
  void dispose() {
    _springController.dispose();
    _squishController.dispose();
    _wobbleController.dispose();
    _feedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTapDown: _onTapDown,
      onTap: _onTap,
      child: RepaintBoundary(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(_springX, _springY)
            ..rotate(_wobbleAngle)
            ..scale(_feedScale, _feedScale)
            ..scale(_squishScaleX, _squishScaleY),
          child: widget.child,
        ),
      ),
    );
  }
}

/// ============================================
// AURA-PET: 粒子效果系统
// 触摸时的爱心/星星粒子
/// ============================================

class ParticleEffect extends StatefulWidget {
  final Offset position;
  final VoidCallback onComplete;

  const ParticleEffect({
    super.key,
    required this.position,
    required this.onComplete,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    // 初始化粒子
    _particles = List.generate(8, (i) {
      final angle = (i / 8) * 2 * pi + (Random().nextDouble() - 0.5) * 0.5;
      final speed = 80 + Random().nextDouble() * 60;
      return Particle(
        angle: angle,
        speed: speed,
        size: 16 + Random().nextDouble() * 12,
        emoji: ['💕', '✨', '💗', '⭐', '🌸', '💫'][Random().nextInt(6)],
      );
    });
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                progress: _controller.value,
                origin: widget.position,
              ),
            );
          },
        ),
      ),
    );
  }
}

class Particle {
  final double angle;
  final double speed;
  final double size;
  final String emoji;

  Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.emoji,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Offset origin;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.origin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 不需要 paint，留给 RepaintBoundary 优化
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

/// ============================================
// AURA-PET: 性能优化包装器
// 使用 RepaintBoundary 隔离宠物渲染
/// ============================================

class OptimizedPetRenderer extends StatelessWidget {
  final Widget Function() builder;
  final String? debugLabel;

  const OptimizedPetRenderer({
    super.key,
    required this.builder,
    this.debugLabel,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: debugLabel != null
          ? builder()
          : builder(),
    );
  }
}
