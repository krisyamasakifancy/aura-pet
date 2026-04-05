import 'package:flutter/material.dart';

/// 语料气泡组件
/// 特性：
/// 1. 莫奈滤镜渐变背景
/// 2. 呼吸感浮现动画
/// 3. 弹性缩放效果
class QuoteBubble extends StatefulWidget {
  final String text;
  final String category;
  final VoidCallback? onDismiss;
  final Duration showDuration;

  const QuoteBubble({
    super.key,
    required this.text,
    required this.category,
    this.onDismiss,
    this.showDuration = const Duration(seconds: 5),
  });

  @override
  State<QuoteBubble> createState() => _QuoteBubbleState();
}

class _QuoteBubbleState extends State<QuoteBubble>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _breatheController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnim;
  late Animation<double> _breatheAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // 渐显动画 (0 → 1)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // 呼吸动画 (脉动)
    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _breatheAnim = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _breatheController,
        curve: Curves.easeInOut,
      ),
    );

    // 弹性缩放
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );
  }

  void _startAnimationSequence() async {
    // 1. 弹性缩放
    _scaleController.forward();
    
    // 2. 渐显
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();

    // 3. 显示一段时间
    await Future.delayed(widget.showDuration);

    // 4. 淡出
    await _fadeController.reverse();
    
    // 5. 回调
    widget.onDismiss?.call();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _breatheController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  /// 获取莫奈色系渐变
  List<Color> _getMonetGradient() {
    switch (widget.category) {
      case '美食和解':
        return [
          const Color(0xFFFFF8E7), // 淡黄
          const Color(0xFFFFE4E1), // 淡粉
        ];
      case '自律之美':
        return [
          const Color(0xFFE3F2FD), // 淡蓝
          const Color(0xFFE8F5E9), // 淡绿
        ];
      case '日常撒娇':
        return [
          const Color(0xFFF3E5F5), // 淡紫
          const Color(0xFFFFE4E1), // 淡粉
        ];
      case '激励赞美':
        return [
          const Color(0xFFFFF9E7), // 淡金
          const Color(0xFFFFE4E1), // 淡粉
        ];
      default:
        return [
          const Color(0xFFFFF8E7),
          const Color(0xFFE3F2FD),
        ];
    }
  }

  /// 获取分类颜色
  Color _getCategoryColor() {
    switch (widget.category) {
      case '美食和解':
        return const Color(0xFFFFB5B5);
      case '自律之美':
        return const Color(0xFF64B5F6);
      case '日常撒娇':
        return const Color(0xFFFFB5E8);
      case '激励赞美':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF4ECDC4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnim, _breatheAnim, _scaleAnim]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // 莫奈渐变背景
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getMonetGradient(),
            ),
            // 呼吸感光晕
            boxShadow: [
              BoxShadow(
                color: _getCategoryColor().withOpacity(_breatheAnim.value),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _getCategoryColor().withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 分类标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.category,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getCategoryColor(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 语料文字
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  height: 1.6,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 12),
              // 装饰图标
              _buildDecorations(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 莫奈小熊
        const Text('🐻', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        // 呼吸光点
        AnimatedBuilder(
          animation: _breatheAnim,
          builder: (context, child) {
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getCategoryColor().withOpacity(_breatheAnim.value),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        const Text('✨', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

/// 语料气泡管理器
class QuoteBubbleOverlay {
  static OverlayEntry? _currentEntry;

  /// 显示语料气泡
  static void show(
    BuildContext context, {
    required String text,
    required String category,
    VoidCallback? onDismiss,
  }) {
    // 移除现有的
    hide();

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 120,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: QuoteBubble(
            text: text,
            category: category,
            onDismiss: () {
              hide();
              onDismiss?.call();
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_currentEntry!);
  }

  /// 隐藏语料气泡
  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
