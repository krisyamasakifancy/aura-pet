import 'package:flutter/material.dart';
import '../services/monet_clock.dart';

/// 骨架屏系统 - 零等待感知
/// 带有莫奈色流动感的占位骨架
class MonetSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final MonetColors? colors;
  
  const MonetSkeleton({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12,
    this.colors,
  });

  @override
  State<MonetSkeleton> createState() => _MonetSkeletonState();
}

class _MonetSkeletonState extends State<MonetSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ?? MonetColors.getCurrentColors();
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                colors.shimmerBase,
                colors.shimmerHighlight.withOpacity(0.6),
                colors.shimmerBase,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// 骨架卡片
class MonetSkeletonCard extends StatelessWidget {
  final double height;
  final MonetColors? colors;
  
  const MonetSkeletonCard({
    super.key,
    this.height = 120,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors ?? MonetColors.getCurrentColors(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MonetSkeleton(
                width: 48,
                height: 48,
                borderRadius: 12,
                colors: colors,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MonetSkeleton(
                      width: 120,
                      height: 16,
                      borderRadius: 8,
                      colors: colors,
                    ),
                    const SizedBox(height: 8),
                    MonetSkeleton(
                      width: 80,
                      height: 12,
                      borderRadius: 6,
                      colors: colors,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MonetSkeleton(
            height: 14,
            borderRadius: 7,
            colors: colors,
          ),
          const SizedBox(height: 8),
          MonetSkeleton(
            height: 14,
            borderRadius: 7,
            colors: colors,
          ),
        ],
      ),
    );
  }
}

/// 骨架列表
class MonetSkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final MonetColors? colors;
  
  const MonetSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return MonetSkeletonCard(
          height: itemHeight,
          colors: colors,
        );
      },
    );
  }
}

/// 无缝内容切换Widget
/// 数据加载时显示骨架，加载完成后渐变切换到内容
class MonetContentSwitcher extends StatefulWidget {
  final Widget loadingWidget;
  final Widget? content;
  final bool isLoading;
  final Duration fadeDuration;
  
  const MonetContentSwitcher({
    super.key,
    required this.loadingWidget,
    this.content,
    this.isLoading = true,
    this.fadeDuration = const Duration(milliseconds: 400),
  });

  @override
  State<MonetContentSwitcher> createState() => _MonetContentSwitcherState();
}

class _MonetContentSwitcherState extends State<MonetContentSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (!widget.isLoading) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(MonetContentSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.reverse();
      } else {
        _controller.forward();
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.isLoading 
          ? widget.loadingWidget 
          : (widget.content ?? const SizedBox.shrink()),
    );
  }
}

/// 预加载管理器
/// 提前加载下一页数据，实现无缝切换
class PreloadManager {
  static PreloadManager? _instance;
  static PreloadManager get instance => 
      _instance ??= PreloadManager._();
  PreloadManager._();

  final Map<String, Future<dynamic>> _preloadedData = {};
  
  /// 预加载数据
  Future<T> preload<T>({
    required String key,
    required Future<T> loader,
  }) async {
    if (_preloadedData.containsKey(key)) {
      return _preloadedData[key] as Future<T>;
    }
    
    final future = loader;
    _preloadedData[key] = future;
    return future;
  }
  
  /// 获取预加载数据（如果已加载）
  T? getIfLoaded<T>(String key) {
    if (_preloadedData.containsKey(key)) {
      final future = _preloadedData[key];
      if (future is T) return future;
    }
    return null;
  }
  
  /// 清除预加载缓存
  void clear() {
    _preloadedData.clear();
  }
}

/// 莫奈风格加载动画
class MonetLoadingIndicator extends StatefulWidget {
  final double size;
  final MonetColors? colors;
  
  const MonetLoadingIndicator({
    super.key,
    this.size = 40,
    this.colors,
  });

  @override
  State<MonetLoadingIndicator> createState() => _MonetLoadingIndicatorState();
}

class _MonetLoadingIndicatorState extends State<MonetLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ?? MonetColors.getCurrentColors();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              startAngle: _controller.value * 2 * 3.14159,
              endAngle: (_controller.value + 1) * 2 * 3.14159,
              colors: [
                colors.primary.withOpacity(0.0),
                colors.primary.withOpacity(0.3),
                colors.primary,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.size * 0.15),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.shimmerBase,
              ),
            ),
          ),
        );
      },
    );
  }
}
