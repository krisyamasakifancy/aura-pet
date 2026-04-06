import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/aura_theme.dart';

/// 语料气泡 + 心形飞舞动画
/// 小熊说话时，心形气泡随文本动态飞出
class SpeakingBubble extends StatefulWidget {
  final String text;
  final String? category;
  final VoidCallback? onDismiss;
  final bool showHearts;
  final Duration displayDuration;
  
  const SpeakingBubble({
    super.key,
    required this.text,
    this.category,
    this.onDismiss,
    this.showHearts = true,
    this.displayDuration = const Duration(seconds: 5),
  });

  @override
  State<SpeakingBubble> createState() => _SpeakingBubbleState();
}

class _SpeakingBubbleState extends State<SpeakingBubble>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _heartController;
  late AnimationController _typewriterController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<_HeartParticle> _heartParticles;
  String _displayedText = '';
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // 淡入动画
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // 心形飞舞动画
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // 打字机效果
    _typewriterController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.text.length * 50),
    );

    _initHeartParticles();
    
    // 开始动画
    _fadeController.forward();
    _startTypewriter();

    // 自动消失
    if (widget.displayDuration.inMilliseconds > 0) {
      Future.delayed(widget.displayDuration, () {
        if (mounted) _dismiss();
      });
    }
  }

  void _initHeartParticles() {
    _heartParticles = List.generate(8, (index) {
      return _HeartParticle(
        startX: 0.5 + (_random.nextDouble() - 0.5) * 0.3,
        startY: 0.3,
        endX: 0.1 + _random.nextDouble() * 0.8,
        endY: 0.0 - _random.nextDouble() * 0.2,
        delay: _random.nextDouble() * 0.5,
        size: 8 + _random.nextDouble() * 8,
        wiggle: _random.nextDouble() * 2 - 1,
      );
    });
  }

  void _startTypewriter() async {
    for (int i = 0; i <= widget.text.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 30));
      if (mounted) {
        setState(() {
          _displayedText = widget.text.substring(0, i);
        });
      }
    }
  }

  void _dismiss() {
    _fadeController.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _heartController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    if (widget.category == null) return AuraPetTheme.accent;
    
    switch (widget.category) {
      case 'food_peace':
        return const Color(0xFFFFB5B5);
      case 'water_fasting':
        return const Color(0xFF7BC4FF);
      case 'emotional_connection':
        return const Color(0xFFFFB5E8);
      case 'achievement_motivation':
        return const Color(0xFFFFD93D);
      default:
        return AuraPetTheme.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 心形飞舞层
              if (widget.showHearts) _buildHeartParticles(categoryColor),
              
              // 气泡主体
              _buildBubbleBody(categoryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeartParticles(Color color) {
    return AnimatedBuilder(
      animation: _heartController,
      builder: (context, child) {
        return SizedBox(
          height: 100,
          child: Stack(
            children: _heartParticles.map((particle) {
              final adjustedProgress = (_heartController.value + particle.delay) % 1.0;
              final progress = Curves.easeOut.transform(adjustedProgress);
              
              final x = particle.startX + (particle.endX - particle.startX) * progress;
              final y = particle.startY + (particle.endY - particle.startY) * progress;
              final opacity = (1 - progress) * 0.8;
              final scale = 1 - progress * 0.5;
              final wiggle = sin(progress * pi * 4) * 10 * particle.wiggle;

              if (opacity <= 0) return const SizedBox.shrink();

              return Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Transform.translate(
                  offset: Offset(
                    MediaQuery.of(context).size.width * x + wiggle,
                    -60 + 80 * (1 - progress),
                  ),
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: particle.size,
                        height: particle.size,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AuraPetTheme.heartLight,
                              color.withOpacity(0.6),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBubbleBody(Color categoryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 小熊头像 + 分类标签
          Row(
            children: [
              // 小熊头像
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AuraPetTheme.raccoonGray,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AuraPetTheme.auraGlow.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 脸部
                    Container(
                      width: 30,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // 眼睛
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AuraPetTheme.noseBlack,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AuraPetTheme.noseBlack,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 16,
                      child: Container(
                        width: 4,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AuraPetTheme.noseBlack,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // 分类标签
              if (widget.category != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryName(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: categoryColor,
                    ),
                  ),
                ),
              
              const Spacer(),
              
              // 关闭按钮
              GestureDetector(
                onTap: _dismiss,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AuraPetTheme.surfaceOverlay,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AuraPetTheme.textLight,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 语料内容 (打字机效果)
          Text(
            _displayedText,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: AuraPetTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // 打字机光标
          if (_displayedText.length < widget.text.length)
            Container(
              width: 2,
              height: 16,
              margin: const EdgeInsets.only(top: 2),
              color: categoryColor,
            ),
          
          const SizedBox(height: 12),
          
          // 心形装饰
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSmallHeart(AuraPetTheme.heartLight),
              const SizedBox(width: 4),
              _buildSmallHeart(AuraPetTheme.accent),
              const SizedBox(width: 4),
              _buildSmallHeart(AuraPetTheme.heartPink),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallHeart(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  String _getCategoryName() {
    switch (widget.category) {
      case 'food_peace':
        return '🍰 美食疗愈';
      case 'water_fasting':
        return '💧 喝水自律';
      case 'emotional_connection':
        return '💖 情感连接';
      case 'achievement_motivation':
        return '🏆 成就激励';
      default:
        return '✨ 语料';
    }
  }
}

/// 心形粒子数据
class _HeartParticle {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double delay;
  final double size;
  final double wiggle;

  _HeartParticle({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.delay,
    required this.size,
    required this.wiggle,
  });
}

/// Aura 氛围背景组件
class AuraBackground extends StatelessWidget {
  final Widget child;
  
  const AuraBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AuraPetTheme.backgroundGradient,
      ),
      child: Stack(
        children: [
          // 柔和的光斑
          ..._buildAmbientSpots(),
          // 主内容
          child,
        ],
      ),
    );
  }

  List<Widget> _buildAmbientSpots() {
    return [
      // 左上光斑
      Positioned(
        top: -100,
        left: -100,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AuraPetTheme.primaryLight.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // 右下光斑
      Positioned(
        bottom: -150,
        right: -100,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AuraPetTheme.accentLight.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
