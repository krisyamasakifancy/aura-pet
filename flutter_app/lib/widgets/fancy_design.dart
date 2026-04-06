import 'dart:math' as math;
import 'package:flutter/material.dart';

/// FancyEat 视觉协议 - 专业 UI 组件库
/// 基于 awesome-design-md 设计规范
/// 核心色调: #8B4513 (泰迪熊棕)

class FancyDesign {
  // ========== 核心色板 ==========
  static const Color primaryBrown = Color(0xFF8B4513);
  static const Color accentGold = Color(0xFFD4A574);
  static const Color lightBrown = Color(0xFFB8860B);
  static const Color darkBrown = Color(0xFF5D3A1A);
  
  static const Color surfaceLight = Color(0xFFFAF7F2);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  
  static const Color textPrimary = Color(0xFF2D2013);
  static const Color textSecondary = Color(0xFF6B5B4F);
  static const Color textMuted = Color(0xFF9A8A7E);
  
  // ========== 状态色 ==========
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ========== 阴影系统 (Stripe/Vercel 风格) ==========
  static List<BoxShadow> shadowSubtle = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> shadowElevated = [
    BoxShadow(
      color: primaryBrown.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 30,
      offset: const Offset(0, 15),
    ),
  ];

  // ========== 渐变 ==========
  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBrown, lightBrown],
  );
  
  static LinearGradient get goldGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGold, primaryBrown],
  );
  
  static LinearGradient get glowGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primaryBrown.withOpacity(0.3),
      primaryBrown.withOpacity(0.0),
    ],
  );
}

/// 🎯 专业数据卡片组件
class DataReportCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final String? trend; // '+12%' or '-5%'
  final bool trendPositive;
  final VoidCallback? onTap;

  const DataReportCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.trend,
    this.trendPositive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: FancyDesign.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: FancyDesign.shadowCard,
          border: Border.all(
            color: Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: FancyDesign.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: FancyDesign.textSecondary,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Value with trend
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: FancyDesign.textPrimary,
                    letterSpacing: -1,
                    height: 1,
                  ),
                ),
                if (trend != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (trendPositive ? FancyDesign.success : FancyDesign.error)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendPositive ? Icons.trending_up : Icons.trending_down,
                          size: 12,
                          color: trendPositive ? FancyDesign.success : FancyDesign.error,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          trend!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: trendPositive ? FancyDesign.success : FancyDesign.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: FancyDesign.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 📊 进度环形图组件 (带呼吸光效)
class GlowProgressRing extends StatefulWidget {
  final double progress; // 0.0 - 1.0
  final String centerValue;
  final String? centerLabel;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;

  const GlowProgressRing({
    super.key,
    required this.progress,
    required this.centerValue,
    this.centerLabel,
    this.size = 200,
    this.strokeWidth = 12,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  State<GlowProgressRing> createState() => _GlowProgressRingState();
}

class _GlowProgressRingState extends State<GlowProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _breathAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressColor = widget.progressColor ?? FancyDesign.primaryBrown;
    final bgColor = widget.backgroundColor ?? Colors.black.withOpacity(0.05);
    
    return AnimatedBuilder(
      animation: _breathAnimation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 外层光晕
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: progressColor.withOpacity(_breathAnimation.value * 0.4),
                      blurRadius: 30 + (widget.strokeWidth * 2),
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              
              // 背景环
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  progress: 1.0,
                  color: bgColor,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              
              // 进度环
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  progress: widget.progress,
                  color: progressColor,
                  strokeWidth: widget.strokeWidth,
                  hasGradient: true,
                ),
              ),
              
              // 中心内容
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.centerValue,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: FancyDesign.textPrimary,
                      letterSpacing: -1.5,
                    ),
                  ),
                  if (widget.centerLabel != null)
                    Text(
                      widget.centerLabel!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: FancyDesign.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool hasGradient;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.hasGradient = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    if (hasGradient) {
      paint.shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          FancyDesign.primaryBrown,
          FancyDesign.accentGold,
          FancyDesign.primaryBrown,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      paint.color = color;
    }
    
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// 🎨 状态 Callout 组件 (Success/Warning/Error/Info)
class StatusCallout extends StatelessWidget {
  final String title;
  final String? description;
  final StatusType type;
  final IconData? icon;
  final VoidCallback? onDismiss;

  const StatusCallout({
    super.key,
    required this.title,
    this.description,
    required this.type,
    this.icon,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getTypeConfig();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.borderColor, width: 1),
        boxShadow: FancyDesign.shadowSubtle,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: config.iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon ?? config.defaultIcon,
              color: config.iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: config.textColor,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: config.textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, size: 18, color: config.textColor),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  _CalloutConfig _getTypeConfig() {
    switch (type) {
      case StatusType.success:
        return _CalloutConfig(
          bgColor: FancyDesign.success.withOpacity(0.08),
          borderColor: FancyDesign.success.withOpacity(0.3),
          iconBgColor: FancyDesign.success.withOpacity(0.15),
          iconColor: FancyDesign.success,
          textColor: const Color(0xFF065F46),
          defaultIcon: Icons.check_circle_outline,
        );
      case StatusType.warning:
        return _CalloutConfig(
          bgColor: FancyDesign.warning.withOpacity(0.08),
          borderColor: FancyDesign.warning.withOpacity(0.3),
          iconBgColor: FancyDesign.warning.withOpacity(0.15),
          iconColor: FancyDesign.warning,
          textColor: const Color(0xFF92400E),
          defaultIcon: Icons.warning_amber_outlined,
        );
      case StatusType.error:
        return _CalloutConfig(
          bgColor: FancyDesign.error.withOpacity(0.08),
          borderColor: FancyDesign.error.withOpacity(0.3),
          iconBgColor: FancyDesign.error.withOpacity(0.15),
          iconColor: FancyDesign.error,
          textColor: const Color(0xFF991B1B),
          defaultIcon: Icons.error_outline,
        );
      case StatusType.info:
        return _CalloutConfig(
          bgColor: FancyDesign.info.withOpacity(0.08),
          borderColor: FancyDesign.info.withOpacity(0.3),
          iconBgColor: FancyDesign.info.withOpacity(0.15),
          iconColor: FancyDesign.info,
          textColor: const Color(0xFF1E40AF),
          defaultIcon: Icons.info_outline,
        );
    }
  }
}

enum StatusType { success, warning, error, info }

class _CalloutConfig {
  final Color bgColor;
  final Color borderColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color textColor;
  final IconData defaultIcon;

  _CalloutConfig({
    required this.bgColor,
    required this.borderColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.textColor,
    required this.defaultIcon,
  });
}

/// 🌟 磨砂玻璃卡片组件
class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const FrostedGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// 📈 迷你趋势指示器
class TrendIndicator extends StatelessWidget {
  final String value;
  final bool positive;
  final bool showArrow;

  const TrendIndicator({
    super.key,
    required this.value,
    required this.positive,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? FancyDesign.success : FancyDesign.error;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showArrow)
            Icon(
              positive ? Icons.arrow_upward : Icons.arrow_downward,
              size: 12,
              color: color,
            ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎯 AI 识别结果卡片
class AIResultCard extends StatelessWidget {
  final String foodName;
  final int calories;
  final String portion;
  final String anxietyLabel;
  final String emoji;
  final String? imageUrl;
  final VoidCallback? onAdd;

  const AIResultCard({
    super.key,
    required this.foodName,
    required this.calories,
    required this.portion,
    required this.anxietyLabel,
    required this.emoji,
    this.imageUrl,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FancyDesign.primaryBrown.withOpacity(0.05),
            FancyDesign.accentGold.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: FancyDesign.primaryBrown.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: FancyDesign.shadowElevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: FancyDesign.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'AI 推荐',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: FancyDesign.accentGold.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$emoji $anxietyLabel',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: FancyDesign.primaryBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: FancyDesign.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '$calories kcal',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: FancyDesign.primaryBrown,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '($portion)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: FancyDesign.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Nutrition chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _NutritionChip(label: '蛋白质', value: '8.5g'),
                const SizedBox(width: 12),
                _NutritionChip(label: '碳水', value: '45g'),
                const SizedBox(width: 12),
                _NutritionChip(label: '脂肪', value: '22g'),
              ],
            ),
          ),
          
          // Action button
          if (onAdd != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FancyDesign.primaryBrown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18),
                    SizedBox(width: 8),
                    Text(
                      '添加到记录',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NutritionChip extends StatelessWidget {
  final String label;
  final String value;

  const _NutritionChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: FancyDesign.shadowSubtle,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: FancyDesign.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: FancyDesign.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
