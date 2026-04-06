import 'package:flutter/material.dart';
import '../animations/natural_curves.dart';
import '../services/haptic_audio.dart';

/// 四段式触控按钮 - 触碰-压缩-回弹-微颤
/// 让每一次点击都像在触摸真实有弹性的物体
class TactileButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double borderRadius;
  
  const TactileButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 16,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _squishAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // 四段式触控曲线
    _scaleAnimation = TweenSequence<double>([
      // 阶段1：快速压缩 (0-20%)
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.92)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 20,
      ),
      // 阶段2：弹性回弹 (20-50%)
      TweenSequenceItem(
        tween: Tween(begin: 0.92, end: 1.02)
            .chain(CurveTween(curve: NaturalCurves.silkBounce)),
        weight: 30,
      ),
      // 阶段3：微颤衰减 (50-80%)
      TweenSequenceItem(
        tween: Tween(begin: 1.02, end: 0.98)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      // 阶段4：稳定 (80-100%)
      TweenSequenceItem(
        tween: Tween(begin: 0.98, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    // 轻微挤压动画
    _squishAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.95),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.03),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.03, end: 0.99),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.99, end: 1.0),
        weight: 20,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    CombinedFeedback.instance;
    HapticEngine.instance.buttonPress();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onLongPress() {
    HapticEngine.instance.petHead();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: _onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.scale(
              scaleX: _squishAnimation.value,
              scaleY: 2 - _squishAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                padding: widget.padding ?? 
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? 
                      Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          _isPressed ? 0.05 : 0.1),
                      blurRadius: _isPressed ? 4 : 8,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          );
        },
        child: Center(child: widget.child),
      ),
    );
  }
}

/// 莫奈小熊头像按钮 - 带呼吸光晕
class MonetPetButton extends StatefulWidget {
  final String petEmoji;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double size;
  final Color glowColor;
  final double glowIntensity;
  
  const MonetPetButton({
    super.key,
    this.petEmoji = '🐻',
    this.onTap,
    this.onLongPress,
    this.size = 80,
    this.glowColor = const Color(0xFFFFE4B5),
    this.glowIntensity = 0.5,
  });

  @override
  State<MonetPetButton> createState() => _MonetPetButtonState();
}

class _MonetPetButtonState extends State<MonetPetButton>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _bounceController;
  late Animation<double> _breathAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _bounceAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // 呼吸动画
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: NaturalCurves.silkBreath,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: Curves.easeInOut,
      ),
    );

    // 弹跳动画
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.85),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.15)
            .chain(CurveTween(curve: NaturalCurves.silkBounce)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.95),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0),
        weight: 15,
      ),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() => _isPressed = true);
    _bounceController.forward().then((_) {
      setState(() => _isPressed = false);
      _bounceController.reset();
    });
    
    CombinedFeedback.instance.petInteraction();
    widget.onTap?.call();
  }

  void _onLongPress() {
    CombinedFeedback.instance.petInteraction();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onLongPress: _onLongPress,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathController, _bounceController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _breathAnimation.value * 
                   (_bounceController.isAnimating ? _bounceAnimation.value : 1.0),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(
                        _glowAnimation.value * widget.glowIntensity),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: widget.glowColor.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.petEmoji,
                    style: TextStyle(fontSize: widget.size * 0.5),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 水波扩散点击效果
class RippleTapEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color rippleColor;
  
  const RippleTapEffect({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor = const Color(0xFFFFB5B5),
  });

  @override
  State<RippleTapEffect> createState() => _RippleTapEffectState();
}

class _RippleTapEffectState extends State<RippleTapEffect>
    with SingleTickerProviderStateMixin {
  final List<_RippleData> _ripples = [];
  int _rippleKey = 0;

  void _onTapDown(TapDownDetails details) {
    final key = _rippleKey++;
    _ripples.add(_RippleData(key: key));
    setState(() {});
    
    HapticEngine.instance.buttonPress();
    
    // 动画结束后移除
    Future.delayed(const Duration(milliseconds: 600), () {
      _ripples.removeWhere((r) => r.key == key);
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            widget.child,
            ..._ripples.map((ripple) {
              return Positioned.fill(
                child: AnimatedBuilder(
                  animation: ripple.controller,
                  builder: (context, child) {
                    final scale = ripple.controller.value * 2;
                    final opacity = 1 - ripple.controller.value;
                    
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.rippleColor.withOpacity(opacity * 0.3),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _RippleData {
  final int key;
  final AnimationController controller;
  
  _RippleData({required this.key})
      : controller = AnimationController(
          vsync: navigatorKey.currentState ?? const DefaultWidgetsFlutterBinding(),
          duration: const Duration(milliseconds: 600),
        )..forward();
}

/// 丝绸滑动面板
class SilkSlidePanel extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final Duration duration;
  final Offset offset;
  
  const SilkSlidePanel({
    super.key,
    required this.child,
    this.isOpen = false,
    this.duration = const Duration(milliseconds: 400),
    this.offset = const Offset(0, 1),
  });

  @override
  State<SilkSlidePanel> createState() => _SilkSlidePanelState();
}

class _SilkSlidePanelState extends State<SilkSlidePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: NaturalCurves.silkSlide,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    ));

    if (widget.isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SilkSlidePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
