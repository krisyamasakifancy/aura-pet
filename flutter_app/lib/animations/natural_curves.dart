import 'dart:math';
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';

/// Custom Curves Library - 非线性弹性曲线系统
/// 让所有动画拥有"丝绸般顺滑"的减速感
class NaturalCurves {
  NaturalCurves._();

  // ================== 丝绸系列 ==================
  
  /// 丝绸顺滑 - 用于面板弹出
  /// 特点：快速启动，优雅减速，无突兀停顿
  static const Curve silkSlide = _SilkSlideCurve();
  
  /// 丝绸呼吸 - 用于光晕脉动
  /// 特点：平滑升降，模拟真实呼吸节奏
  static const Curve silkBreath = _SilkBreathCurve();
  
  /// 丝绸弹跳 - 用于卡片交互
  /// 特点：先快后慢，末端优雅回弹
  static const Curve silkBounce = _SilkBounceCurve();

  // ================== 四段式触控曲线 ==================
  
  /// 触碰-压缩-回弹-微颤
  /// 用于摸头等深度交互
  static const Curve touchQuake = _TouchQuakeCurve();
  
  /// 快速按压反馈
  static const Curve pressDown = _PressDownCurve();
  
  /// 按压释放
  static const Curve pressUp = _PressUpCurve();

  // ================== 拟物系列 ==================
  
  /// 水波荡漾 - 用于点击反馈
  static const Curve rippleSpread = _RippleSpreadCurve();
  
  /// 弹簧悬挂 - 用于列表拖拽
  static const Curve springDangle = _SpringDangleCurve();
  
  /// 羽毛飘落 - 用于元素消失
  static const Curve featherFall = _FeatherFallCurve();
}

/// 丝绸滑入曲线
class _SilkSlideCurve extends Curve {
  const _SilkSlideCurve();
  
  @override
  double transformInternal(double t) {
    // 贝塞尔模拟：快速启动 → 优雅减速
    // 控制点：(0, 0) → (0.2, 0.4) → (0.6, 0.85) → (1, 1)
    return _cubicBezier(t, 0.0, 0.2, 0.6, 1.0);
  }
  
  static double _cubicBezier(double t, double p0, double p1, double p2, double p3) {
    final u = 1 - t;
    return u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3;
  }
}

/// 丝绸呼吸曲线
class _SilkBreathCurve extends Curve {
  const _SilkBreathCurve();
  
  @override
  double transformInternal(double t) {
    // 正弦波 + 呼吸感
    // 0.0 → 0.5: 吸气（加速上升）
    // 0.5 → 1.0: 呼气（减速下降）
    if (t < 0.5) {
      return 2 * t * t;
    } else {
      return 1 - pow(-2 * t + 2, 2) / 2;
    }
  }
}

/// 丝绸弹跳曲线
class _SilkBounceCurve extends Curve {
  const _SilkBounceCurve();
  
  @override
  double transformInternal(double t) {
    // 使用指数衰减模拟弹跳
    const c4 = (2 * pi) / 4.5;
    
    return t == 0
        ? 0
        : t == 1
            ? 1
            : t < 0.5
                ? (pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1) / 2
                : (pow(2, -10 * (t - 1)) * sin((t * 10 - 0.75) * c4) + 1) / 2;
  }
}

/// 四段式触控曲线：触碰-压缩-回弹-微颤
/// 模拟真实弹性物体被触摸的感觉
class _TouchQuakeCurve extends Curve {
  const _TouchQuakeCurve();
  
  @override
  double transformInternal(double t) {
    // 四个阶段：快速压缩(0-0.2) → 回弹上升(0.2-0.5) → 微颤衰减(0.5-0.8) → 稳定(0.8-1.0)
    if (t < 0.2) {
      // 阶段1：快速压缩（线性）
      return 0.1 + t * 0.5;
    } else if (t < 0.5) {
      // 阶段2：弹性回弹
      final stage = (t - 0.2) / 0.3;
      return 0.2 + sin(stage * pi * 0.5) * 0.3;
    } else if (t < 0.8) {
      // 阶段3：微颤衰减
      final stage = (t - 0.5) / 0.3;
      return 0.5 + sin(stage * pi * 3) * 0.05 * (1 - stage);
    } else {
      // 阶段4：稳定
      final stage = (t - 0.8) / 0.2;
      return 0.5 + (stage * 0.5);
    }
  }
}

/// 按压下沉曲线
class _PressDownCurve extends Curve {
  const _PressDownCurve();
  
  @override
  double transformInternal(double t) {
    // 快速下沉 + 轻微形变
    return 1 - pow(1 - t, 2);
  }
}

/// 按压释放曲线
class _PressUpCurve extends Curve {
  const _PressUpCurve();
  
  @override
  double transformInternal(double t) {
    // 弹性上升
    return 1 - pow(1 - t, 3);
  }
}

/// 水波扩散曲线
class _RippleSpreadCurve extends Curve {
  const _RippleSpreadCurve();
  
  @override
  double transformInternal(double t) {
    // 快速扩散 → 急剧减速
    return 1 - pow(1 - t, 3);
  }
}

/// 弹簧悬挂曲线
class _SpringDangleCurve extends Curve {
  const _SpringDangleCurve();
  
  @override
  double transformInternal(double t) {
    // 重力 + 弹性
    return 1 - cos(t * pi * 0.5) * exp(-t * 3);
  }
}

/// 羽毛飘落曲线
class _FeatherFallCurve extends Curve {
  const _FeatherFallCurve();
  
  @override
  double transformInternal(double t) {
    // 飘落感：先慢后快，模拟重力
    return pow(t, 1.5);
  }
}

/// ================== 高级物理引擎 ==================

/// 升级版弹簧物理系统
class AdvancedSpringPhysics {
  /// 丝绸阻尼配置 - 顺滑如丝
  static SpringDescription get silkSmooth => const SpringDescription(
    mass: 1.0,
    stiffness: 180,
    damping: 14, // 较高阻尼，减少震荡
  );

  /// 弹性触控配置 - 真实手感
  static SpringDescription get tactileTouch => const SpringDescription(
    mass: 0.8,
    stiffness: 200,
    damping: 12,
  );

  /// 快速响应配置 - 即时反馈
  static SpringDescription get quickResponse => const SpringDescription(
    mass: 0.5,
    stiffness: 300,
    damping: 20,
  );

  /// 果冻弹性配置 - 呆萌效果
  static SpringDescription get jellyEffect => const SpringDescription(
    mass: 1.2,
    stiffness: 100,
    damping: 8,
  );

  /// 创建弹簧模拟器
  static SpringSimulation createSimulation({
    required double from,
    required double to,
    double velocity = 0,
    SpringDescription? spring,
  }) {
    return SpringSimulation(
      spring ?? silkSmooth,
      from,
      to,
      velocity,
    );
  }
}

/// ================== 复合动画控制器 ==================

/// 复合动画序列
class CompositeAnimationController {
  final List<AnimationController> _controllers = [];
  final TickerProvider vsync;
  
  CompositeAnimationController({required this.vsync});
  
  /// 创建四段式触控动画
  Animation<double> createTouchQuakeAnimation({
    required Duration totalDuration,
  }) {
    final controller = AnimationController(
      vsync: vsync,
      duration: totalDuration,
    );
    _controllers.add(controller);
    
    return CurvedAnimation(
      parent: controller,
      curve: NaturalCurves.touchQuake,
    );
  }
  
  /// 创建丝绸弹跳动画
  Animation<double> createSilkBounceAnimation({
    required Duration duration,
    double initialScale = 1.0,
    double bounceScale = 0.9,
  }) {
    final controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );
    _controllers.add(controller);
    
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: initialScale, end: bounceScale)
            .chain(CurveTween(curve: NaturalCurves.pressDown)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: bounceScale, end: initialScale * 1.05)
            .chain(CurveTween(curve: NaturalCurves.silkBounce)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: initialScale * 1.05, end: initialScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(controller);
  }
  
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
  }
}
