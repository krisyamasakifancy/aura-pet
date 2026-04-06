import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🧸 毛绒三友 - Furry Trio
/// 
/// 角色定义：
/// - Data Bear (熊仔): 核心数据展示
/// - Chef Bunny (兔厨): 饮食建议与录入  
/// - Cheer Ell (象宝): 运动激励与成就

// ========== 角色枚举 ==========
enum FurryTrio {
  dataBear,    // 熊仔 - 数据
  chefBunny,   // 兔厨 - 饮食
  cheerEll,    // 象宝 - 运动
}

// ========== 毛绒配色系统 ==========
class FurryColors {
  // 熊仔 - 温暖棕
  static const Color bearBrown = Color(0xFF8B7355);
  static const Color bearMuzzle = Color(0xFFD4A574);
  static const Color bearLight = Color(0xFFB8A88A);
  
  // 兔厨 - 奶油白 + 胡萝卜橙
  static const Color bunnyWhite = Color(0xFFFAF5F0);
  static const Color bunnyPink = Color(0xFFFFB6C1);
  static const Color bunnyCream = Color(0xFFFFF8DC);
  static const Color carrotOrange = Color(0xFFFF8C00);
  
  // 象宝 - 柔粉 + 天蓝
  static const Color ellGray = Color(0xFFB0C4DE);
  static const Color ellPink = Color(0xFFFFB6C1);
  static const Color ellLight = Color(0xFFB8C5D0);
  static const Color bowPink = Color(0xFFFF69B4);
  
  // 公共 - 腮红/腮帮
  static const Color blushPink = Color(0xFFFFB5B5);
  
  // 睡眠态
  static const Color nightcapPurple = Color(0xFF6B5B95);
  static const Color nightcapGold = Color(0xFFFFD700);
}

// ========== 毛绒主题 ==========
class FurryTheme {
  static const Color primary = Color(0xFFFFE4C4);      // 奶油黄
  static const Color secondary = Color(0xFFFFB6C1);     // 柔粉
  static const Color tertiary = Color(0xFFB0E0E6);      // 天蓝
  
  static const Color surface = Color(0xFFFFFAF5);       // 暖白
  static const Color cardBg = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF5D4E37);
  static const Color textSecondary = Color(0xFF8B7B6B);
  static const Color textMuted = Color(0xFFB0A090);
  
  // 渐变
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  
  // 渐变 - 熊仔
  static LinearGradient get bearGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bearBrown, bearLight],
  );
  
  // 阴影 - 毛绒软绵感
  static List<BoxShadow> get fluffyShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 40,
      offset: const Offset(0, 20),
    ),
  ];
  
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  // 圆角 - 毛绒圆润
  static const double radiusSm = 16;
  static const double radiusMd = 24;
  static const double radiusLg = 32;
  static const double radiusXl = 9999; // 胶囊形
}

// ========== 基础毛绒角色 Widget ==========
abstract class FurryCharacter extends StatefulWidget {
  final double size;
  final bool animate;
  final VoidCallback? onTap;
  
  const FurryCharacter({
    super.key,
    this.size = 120,
    this.animate = true,
    this.onTap,
  });
}

class FurryCharacterState<T extends FurryCharacter> extends State<T>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;
  late Animation<double> _breath;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _bounce = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _breath = Tween<double>(begin: 1.0, end: 1.03).animate(
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
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, widget.animate ? -_bounce.value : 0),
            child: Transform.scale(
              scale: widget.animate ? _breath.value : 1.0,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: getPainter(),
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// 子类必须实现此方法
  CustomPainter getPainter();
}

// ========== 🐻 熊仔 - Data Bear ==========
class DataBear extends FurryCharacter {
  final bool sleeping;
  final bool celebrating;
  final bool thinking;  // 困惑/思考状态
  
  const DataBear({
    super.key,
    super.size = 120,
    super.animate = true,
    super.onTap,
    this.sleeping = false,
    this.celebrating = false,
    this.thinking = false,
  });
  
  @override
  State<DataBear> createState() => _DataBearState();
}

class _DataBearState extends FurryCharacterState<DataBear> {
  @override
  CustomPainter getPainter() {
    return _DataBearPainter(
      sleeping: widget.sleeping,
      celebrating: widget.celebrating,
      thinking: widget.thinking,
      bounceOffset: widget.animate ? _bounce.value : 0,
    );
  }
}

class _DataBearPainter extends CustomPainter {
  final bool sleeping;
  final bool celebrating;
  final bool thinking;
  final double bounceOffset;
  
  _DataBearPainter({
    required this.sleeping,
    required this.celebrating,
    required this.thinking,
    required this.bounceOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final s = size.width * 0.35;
    
    // 身体
    final bodyPaint = Paint()..color = FurryColors.bearBrown;
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + s * 0.4 + bounceOffset),
      width: s * 1.8,
      height: s * 1.5,
    );
    canvas.drawOval(bodyRect, bodyPaint);
    
    // 头部
    final headRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - s * 0.2 + bounceOffset),
      width: s * 1.7,
      height: s * 1.6,
    );
    canvas.drawOval(headRect, bodyPaint);
    
    // 耳朵
    final earPaint = Paint()..color = FurryColors.bearBrown;
    canvas.drawCircle(
      Offset(center.dx - s * 0.65, center.dy - s * 0.7 + bounceOffset),
      s * 0.28, earPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.65, center.dy - s * 0.7 + bounceOffset),
      s * 0.28, earPaint,
    );
    
    // 内耳
    final innerEarPaint = Paint()..color = FurryColors.bearMuzzle;
    canvas.drawCircle(
      Offset(center.dx - s * 0.65, center.dy - s * 0.7 + bounceOffset),
      s * 0.14, innerEarPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.65, center.dy - s * 0.7 + bounceOffset),
      s * 0.14, innerEarPaint,
    );
    
    // 脸部
    final muzzlePaint = Paint()..color = FurryColors.bearMuzzle;
    final muzzleRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + s * 0.15 + bounceOffset),
      width: s * 0.65,
      height: s * 0.55,
    );
    canvas.drawOval(muzzleRect, muzzlePaint);
    
    // 表情
    if (sleeping) {
      _drawSleepingFace(canvas, center, s);
      _drawNightcap(canvas, center, s);
    } else if (celebrating) {
      _drawCelebratingFace(canvas, center, s);
    } else if (thinking) {
      _drawThinkingFace(canvas, center, s);
    } else {
      _drawHappyFace(canvas, center, s);
    }
    
    // 腮红
    final blushPaint = Paint()..color = FurryColors.blushPink.withOpacity(0.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - s * 0.55, center.dy + s * 0.05 + bounceOffset),
        width: s * 0.28,
        height: s * 0.16,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + s * 0.55, center.dy + s * 0.05 + bounceOffset),
        width: s * 0.28,
        height: s * 0.16,
      ),
      blushPaint,
    );
  }
  
  void _drawHappyFace(Canvas canvas, Offset center, double s) {
    // 眼睛
    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(
      Offset(center.dx - s * 0.32, center.dy - s * 0.15 + bounceOffset),
      s * 0.1, eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.32, center.dy - s * 0.15 + bounceOffset),
      s * 0.1, eyePaint,
    );
    
    // 眼睛高光
    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx - s * 0.3, center.dy - s * 0.17 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.34, center.dy - s * 0.17 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    
    // 嘴巴
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - s * 0.18, center.dy + s * 0.22 + bounceOffset);
    mouthPath.quadraticBezierTo(
      center.dx, center.dy + s * 0.38 + bounceOffset,
      center.dx + s * 0.18, center.dy + s * 0.22 + bounceOffset,
    );
    canvas.drawPath(mouthPath, mouthPaint);
  }
  
  void _drawSleepingFace(Canvas canvas, Offset center, double s) {
    // 闭眼
    final eyePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx - s * 0.42, center.dy - s * 0.12 + bounceOffset),
      Offset(center.dx - s * 0.18, center.dy - s * 0.12 + bounceOffset),
      eyePaint,
    );
    canvas.drawLine(
      Offset(center.dx + s * 0.18, center.dy - s * 0.12 + bounceOffset),
      Offset(center.dx + s * 0.42, center.dy - s * 0.12 + bounceOffset),
      eyePaint,
    );
    
    // 微笑
    _drawSleepSmile(canvas, center, s);
    
    // ZZZ
    _drawZZZ(canvas, center, s);
  }
  
  void _drawSleepSmile(Canvas canvas, Offset center, double s) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + s * 0.25 + bounceOffset),
        width: s * 0.3,
        height: s * 0.2,
      ),
      0, math.pi, false, mouthPaint,
    );
  }
  
  void _drawZZZ(Canvas canvas, Offset center, double s) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '💤',
        style: TextStyle(fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, 
      Offset(center.dx + s * 0.7, center.dy - s * 0.7 + bounceOffset));
  }
  
  void _drawThinkingFace(Canvas canvas, Offset center, double s) {
    // 困惑的眼睛（一边上一边下）
    final eyePaint = Paint()..color = Colors.black;
    
    // 左眼 - 困惑（问号眼）
    canvas.drawCircle(
      Offset(center.dx - s * 0.32, center.dy - s * 0.18 + bounceOffset),
      s * 0.12, eyePaint,
    );
    
    // 右眼 - 困惑
    canvas.drawCircle(
      Offset(center.dx + s * 0.32, center.dy - s * 0.12 + bounceOffset),
      s * 0.12, eyePaint,
    );
    
    // 高光
    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx - s * 0.28, center.dy - s * 0.22 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.36, center.dy - s * 0.16 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    
    // 嘴巴 - 困惑的 O 形
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawCircle(
      Offset(center.dx, center.dy + s * 0.28 + bounceOffset),
      s * 0.1, mouthPaint,
    );
    
    // 问号气泡
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '❓',
        style: TextStyle(fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, 
      Offset(center.dx + s * 0.6, center.dy - s * 0.8 + bounceOffset));
  }
  
  void _drawNightcap(Canvas canvas, Offset center, double s) {
    final capPaint = Paint()..color = FurryColors.nightcapPurple;
    final capPath = Path();
    capPath.moveTo(center.dx - s * 0.55, center.dy - s * 0.5 + bounceOffset);
    capPath.lineTo(center.dx, center.dy - s * 1.3 + bounceOffset);
    capPath.lineTo(center.dx + s * 0.55, center.dy - s * 0.5 + bounceOffset);
    capPath.close();
    canvas.drawPath(capPath, capPaint);
    
    // 星星
    final starPaint = Paint()..color = FurryColors.nightcapGold;
    _drawStar(canvas, 
      Offset(center.dx + s * 0.1, center.dy - s * 1.1 + bounceOffset), 
      s * 0.15, starPaint);
  }
  
  void _drawCelebratingFace(Canvas canvas, Offset center, double s) {
    // 星星眼
    final starPaint = Paint()..color = Colors.amber;
    _drawStar(canvas, Offset(center.dx - s * 0.32, center.dy - s * 0.15 + bounceOffset), s * 0.12, starPaint);
    _drawStar(canvas, Offset(center.dx + s * 0.32, center.dy - s * 0.15 + bounceOffset), s * 0.12, starPaint);
    
    // 大笑
    final mouthPaint = Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.fill;
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + s * 0.25 + bounceOffset),
      width: s * 0.4,
      height: s * 0.3,
    );
    canvas.drawOval(mouthRect, mouthPaint);
  }
  
  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final point = Offset(
        center.dx + size * math.cos(angle),
        center.dy + size * math.sin(angle),
      );
      if (i == 0) path.moveTo(point.dx, point.dy);
      else path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant _DataBearPainter oldDelegate) {
    return oldDelegate.sleeping != sleeping || 
           oldDelegate.celebrating != celebrating ||
           oldDelegate.bounceOffset != bounceOffset;
  }
}

// ========== 🐰 兔厨 - Chef Bunny ==========
class ChefBunny extends FurryCharacter {
  final bool thinking;
  final bool excited;
  
  const ChefBunny({
    super.key,
    super.size = 120,
    super.animate = true,
    super.onTap,
    this.thinking = false,
    this.excited = false,
  });
  
  @override
  State<ChefBunny> createState() => _ChefBunnyState();
}

class _ChefBunnyState extends FurryCharacterState<ChefBunny> {
  @override
  CustomPainter getPainter() {
    return _ChefBunnyPainter(
      thinking: widget.thinking,
      excited: widget.excited,
      bounceOffset: widget.animate ? _bounce.value : 0,
    );
  }
}

class _ChefBunnyPainter extends CustomPainter {
  final bool thinking;
  final bool excited;
  final double bounceOffset;
  
  _ChefBunnyPainter({
    required this.thinking,
    required this.excited,
    required this.bounceOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final s = size.width * 0.35;
    
    // 身体
    final bodyPaint = Paint()..color = FurryColors.bunnyWhite;
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + s * 0.5 + bounceOffset),
      width: s * 1.6,
      height: s * 1.3,
    );
    canvas.drawOval(bodyRect, bodyPaint);
    
    // 头部
    final headRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - s * 0.1 + bounceOffset),
      width: s * 1.5,
      height: s * 1.4,
    );
    canvas.drawOval(headRect, bodyPaint);
    
    // 长耳朵
    final earPaint = Paint()..color = FurryColors.bunnyWhite;
    _drawLongEar(canvas, Offset(center.dx - s * 0.35, center.dy - s * 1.2 + bounceOffset), s * 0.18, s * 0.7, earPaint);
    _drawLongEar(canvas, Offset(center.dx + s * 0.35, center.dy - s * 1.2 + bounceOffset), s * 0.18, s * 0.7, earPaint);
    
    // 内耳（粉色）
    final innerEarPaint = Paint()..color = FurryColors.bunnyPink;
    _drawLongEar(canvas, Offset(center.dx - s * 0.35, center.dy - s * 1.15 + bounceOffset), s * 0.08, s * 0.5, innerEarPaint);
    _drawLongEar(canvas, Offset(center.dx + s * 0.35, center.dy - s * 1.15 + bounceOffset), s * 0.08, s * 0.5, innerEarPaint);
    
    // 厨师帽
    _drawChefHat(canvas, center, s);
    
    // 脸部
    if (excited) {
      _drawExcitedFace(canvas, center, s);
    } else if (thinking) {
      _drawThinkingFace(canvas, center, s);
    } else {
      _drawHappyFace(canvas, center, s);
    }
    
    // 腮红
    final blushPaint = Paint()..color = FurryColors.blushPink.withOpacity(0.4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - s * 0.5, center.dy + s * 0.1 + bounceOffset),
        width: s * 0.25,
        height: s * 0.14,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + s * 0.5, center.dy + s * 0.1 + bounceOffset),
        width: s * 0.25,
        height: s * 0.14,
      ),
      blushPaint,
    );
  }
  
  void _drawLongEar(Canvas canvas, Offset top, double width, double height, Paint paint) {
    final path = Path();
    path.moveTo(top.dx - width, top.dy);
    path.quadraticBezierTo(
      top.dx - width * 0.5, top.dy + height,
      top.dx, top.dy + height,
    );
    path.quadraticBezierTo(
      top.dx + width * 0.5, top.dy + height,
      top.dx + width, top.dy,
    );
    path.close();
    canvas.drawPath(path, paint);
  }
  
  void _drawChefHat(Canvas canvas, Offset center, double s) {
    final hatPaint = Paint()..color = Colors.white;
    final hatStrokePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // 帽子主体
    final hatRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - s * 0.9 + bounceOffset),
      width: s * 1.1,
      height: s * 0.8,
    );
    canvas.drawOval(hatRect, hatPaint);
    canvas.drawOval(hatRect, hatStrokePaint);
    
    // 帽子褶皱
    for (int i = -2; i <= 2; i++) {
      canvas.drawLine(
        Offset(center.dx + i * s * 0.18, center.dy - s * 0.65 + bounceOffset),
        Offset(center.dx + i * s * 0.18, center.dy - s * 1.15 + bounceOffset),
        hatStrokePaint,
      );
    }
    
    // 帽子底边
    final brimPath = Path();
    brimPath.moveTo(center.dx - s * 0.55, center.dy - s * 0.55 + bounceOffset);
    brimPath.lineTo(center.dx + s * 0.55, center.dy - s * 0.55 + bounceOffset);
    canvas.drawPath(brimPath, hatStrokePaint..strokeWidth = 3);
  }
  
  void _drawHappyFace(Canvas canvas, Offset center, double s) {
    // 眼睛
    final eyePaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawCircle(
      Offset(center.dx - s * 0.3, center.dy - s * 0.05 + bounceOffset),
      s * 0.1, eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.3, center.dy - s * 0.05 + bounceOffset),
      s * 0.1, eyePaint,
    );
    
    // 高光
    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx - s * 0.28, center.dy - s * 0.07 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.32, center.dy - s * 0.07 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    
    // 鼻子
    final nosePaint = Paint()..color = FurryColors.bunnyPink;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + s * 0.12 + bounceOffset),
        width: s * 0.12,
        height: s * 0.1,
      ),
      nosePaint,
    );
    
    // 嘴巴
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx, center.dy + s * 0.17 + bounceOffset),
      Offset(center.dx - s * 0.15, center.dy + s * 0.22 + bounceOffset),
      mouthPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + s * 0.17 + bounceOffset),
      Offset(center.dx + s * 0.15, center.dy + s * 0.22 + bounceOffset),
      mouthPaint,
    );
  }
  
  void _drawExcitedFace(Canvas canvas, Offset center, double s) {
    // 星星眼
    final starPaint = Paint()..color = Colors.amber;
    _drawStar(canvas, Offset(center.dx - s * 0.3, center.dy - s * 0.05 + bounceOffset), s * 0.15, starPaint);
    _drawStar(canvas, Offset(center.dx + s * 0.3, center.dy - s * 0.05 + bounceOffset), s * 0.15, starPaint);
    
    // 大笑
    final mouthPaint = Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.fill;
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + s * 0.2 + bounceOffset),
      width: s * 0.35,
      height: s * 0.25,
    );
    canvas.drawOval(mouthRect, mouthPaint);
  }
  
  void _drawThinkingFace(Canvas canvas, Offset center, double s) {
    // 一只眼睁一只眯
    final eyePaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawCircle(
      Offset(center.dx - s * 0.3, center.dy - s * 0.05 + bounceOffset),
      s * 0.1, eyePaint,
    );
    
    final closedEyePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + s * 0.2, center.dy - s * 0.05 + bounceOffset),
      Offset(center.dx + s * 0.4, center.dy - s * 0.05 + bounceOffset),
      closedEyePaint,
    );
    
    // 思考气泡
    _drawThoughtBubble(canvas, center, s);
  }
  
  void _drawThoughtBubble(Canvas canvas, Offset center, double s) {
    final bubblePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(center.dx + s * 0.55, center.dy - s * 0.4 + bounceOffset),
      s * 0.2, bubblePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.75, center.dy - s * 0.65 + bounceOffset),
      s * 0.12, bubblePaint,
    );
    
    // 问号
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '?',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: FurryColors.carrotOrange,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, 
      Offset(center.dx + s * 0.45, center.dy - s * 0.5 + bounceOffset));
  }
  
  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final point = Offset(
        center.dx + size * math.cos(angle),
        center.dy + size * math.sin(angle),
      );
      if (i == 0) path.moveTo(point.dx, point.dy);
      else path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant _ChefBunnyPainter oldDelegate) {
    return oldDelegate.thinking != thinking ||
           oldDelegate.excited != excited ||
           oldDelegate.bounceOffset != bounceOffset;
  }
}

// ========== 🐘 象宝 - Cheer Ell ==========
class CheerEll extends FurryCharacter {
  final bool celebrating;
  final bool waving;
  final bool thinking;  // 困惑/思考状态
  
  const CheerEll({
    super.key,
    super.size = 120,
    super.animate = true,
    super.onTap,
    this.celebrating = false,
    this.waving = false,
    this.thinking = false,
  });
  
  @override
  State<CheerEll> createState() => _CheerEllState();
}

class _CheerEllState extends FurryCharacterState<CheerEll> {
  @override
  CustomPainter getPainter() {
    return _CheerEllPainter(
      celebrating: widget.celebrating,
      waving: widget.waving,
      thinking: widget.thinking,
      bounceOffset: widget.animate ? _bounce.value : 0,
    );
  }
}

class _CheerEllPainter extends CustomPainter {
  final bool celebrating;
  final bool waving;
  final bool thinking;
  final double bounceOffset;
  
  _CheerEllPainter({
    required this.celebrating,
    required this.waving,
    required this.thinking,
    required this.bounceOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final s = size.width * 0.35;
    
    // 身体
    final bodyPaint = Paint()..color = FurryColors.ellGray;
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + s * 0.5 + bounceOffset),
      width: s * 1.5,
      height: s * 1.2,
    );
    canvas.drawOval(bodyRect, bodyPaint);
    
    // 头部
    final headRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - s * 0.15 + bounceOffset),
      width: s * 1.4,
      height: s * 1.3,
    );
    canvas.drawOval(headRect, bodyPaint);
    
    // 耳朵
    final earPaint = Paint()..color = FurryColors.ellGray;
    _drawElephantEar(canvas, Offset(center.dx - s * 0.7, center.dy - s * 0.2 + bounceOffset), s * 0.4, earPaint);
    _drawElephantEar(canvas, Offset(center.dx + s * 0.7, center.dy - s * 0.2 + bounceOffset), s * 0.4, earPaint);
    
    // 粉色蝴蝶结
    _drawBow(canvas, center, s);
    
    // 鼻子
    _drawTrunk(canvas, center, s);
    
    // 脸部
    if (celebrating) {
      _drawCelebratingFace(canvas, center, s);
    } else if (waving) {
      _drawWavingFace(canvas, center, s);
    } else if (thinking) {
      _drawThinkingFace(canvas, center, s);
    } else {
      _drawHappyFace(canvas, center, s);
    }
    
    // 腮红
    final blushPaint = Paint()..color = FurryColors.ellPink.withOpacity(0.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - s * 0.35, center.dy + s * 0.15 + bounceOffset),
        width: s * 0.2,
        height: s * 0.12,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + s * 0.35, center.dy + s * 0.15 + bounceOffset),
        width: s * 0.2,
        height: s * 0.12,
      ),
      blushPaint,
    );
  }
  
  void _drawElephantEar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size * 0.3);
    path.quadraticBezierTo(
      center.dx + size * 0.8, center.dy,
      center.dx, center.dy + size * 0.5,
    );
    path.quadraticBezierTo(
      center.dx - size * 0.3, center.dy + size * 0.2,
      center.dx, center.dy - size * 0.3,
    );
    canvas.drawPath(path, paint);
    
    // 内耳粉色
    final innerPaint = Paint()..color = FurryColors.ellPink.withOpacity(0.4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + size * 0.2, center.dy + size * 0.1),
        width: size * 0.4,
        height: size * 0.3,
      ),
      innerPaint,
    );
  }
  
  void _drawBow(Canvas canvas, Offset center, double s) {
    final bowPaint = Paint()..color = FurryColors.bowPink;
    
    // 蝴蝶结中心
    canvas.drawCircle(
      Offset(center.dx, center.dy - s * 0.75 + bounceOffset),
      s * 0.12, bowPaint,
    );
    
    // 左翅膀
    final leftWing = Path();
    leftWing.moveTo(center.dx - s * 0.12, center.dy - s * 0.75 + bounceOffset);
    leftWing.quadraticBezierTo(
      center.dx - s * 0.5, center.dy - s * 0.9 + bounceOffset,
      center.dx - s * 0.45, center.dy - s * 0.65 + bounceOffset,
    );
    leftWing.quadraticBezierTo(
      center.dx - s * 0.35, center.dy - s * 0.5 + bounceOffset,
      center.dx - s * 0.12, center.dy - s * 0.75 + bounceOffset,
    );
    canvas.drawPath(leftWing, bowPaint);
    
    // 右翅膀
    final rightWing = Path();
    rightWing.moveTo(center.dx + s * 0.12, center.dy - s * 0.75 + bounceOffset);
    rightWing.quadraticBezierTo(
      center.dx + s * 0.5, center.dy - s * 0.9 + bounceOffset,
      center.dx + s * 0.45, center.dy - s * 0.65 + bounceOffset,
    );
    rightWing.quadraticBezierTo(
      center.dx + s * 0.35, center.dy - s * 0.5 + bounceOffset,
      center.dx + s * 0.12, center.dy - s * 0.75 + bounceOffset,
    );
    canvas.drawPath(rightWing, bowPaint);
  }
  
  void _drawTrunk(Canvas canvas, Offset center, double s) {
    final trunkPaint = Paint()..color = FurryColors.ellGray;
    
    final trunkPath = Path();
    trunkPath.moveTo(center.dx - s * 0.12, center.dy + s * 0.3 + bounceOffset);
    trunkPath.quadraticBezierTo(
      center.dx, center.dy + s * 0.6 + bounceOffset,
      center.dx + s * 0.1, center.dy + s * 0.45 + bounceOffset,
    );
    trunkPath.quadraticBezierTo(
      center.dx + s * 0.2, center.dy + s * 0.3 + bounceOffset,
      center.dx + s * 0.12, center.dy + s * 0.3 + bounceOffset,
    );
    canvas.drawPath(trunkPath, trunkPaint);
  }
  
  void _drawHappyFace(Canvas canvas, Offset center, double s) {
    // 眼睛
    final eyePaint = Paint()..color = const Color(0xFF4A4A4A);
    canvas.drawCircle(
      Offset(center.dx - s * 0.25, center.dy - s * 0.05 + bounceOffset),
      s * 0.1, eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.25, center.dy - s * 0.05 + bounceOffset),
      s * 0.1, eyePaint,
    );
    
    // 高光
    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx - s * 0.23, center.dy - s * 0.07 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.27, center.dy - s * 0.07 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    
    // 微笑
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + s * 0.35 + bounceOffset),
        width: s * 0.25,
        height: s * 0.2,
      ),
      0, math.pi, false, mouthPaint,
    );
  }
  
  void _drawThinkingFace(Canvas canvas, Offset center, double s) {
    // 困惑的眼睛
    final eyePaint = Paint()..color = const Color(0xFF4A4A4A);
    
    canvas.drawCircle(
      Offset(center.dx - s * 0.25, center.dy - s * 0.08 + bounceOffset),
      s * 0.12, eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.25, center.dy - s * 0.02 + bounceOffset),
      s * 0.12, eyePaint,
    );
    
    // 高光
    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx - s * 0.21, center.dy - s * 0.12 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + s * 0.29, center.dy - s * 0.06 + bounceOffset),
      s * 0.04, highlightPaint,
    );
    
    // 嘴巴 - O 形困惑
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(
      Offset(center.dx, center.dy + s * 0.32 + bounceOffset),
      s * 0.08, mouthPaint,
    );
    
    // 问号气泡
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '❓',
        style: TextStyle(fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, 
      Offset(center.dx + s * 0.5, center.dy - s * 0.8 + bounceOffset));
  }
  
  void _drawCelebratingFace(Canvas canvas, Offset center, double s) {
    // 星星眼
    final starPaint = Paint()..color = Colors.amber;
    _drawStar(canvas, Offset(center.dx - s * 0.25, center.dy - s * 0.05 + bounceOffset), s * 0.12, starPaint);
    _drawStar(canvas, Offset(center.dx + s * 0.25, center.dy - s * 0.05 + bounceOffset), s * 0.12, starPaint);
    
    // 大笑
    final mouthPaint = Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.fill;
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + s * 0.35 + bounceOffset),
      width: s * 0.35,
      height: s * 0.28,
    );
    canvas.drawOval(mouthRect, mouthPaint);
    
    // 举起的手
    _drawRaisedArm(canvas, center, s, true);
    _drawRaisedArm(canvas, center, s, false);
  }
  
  void _drawWavingFace(Canvas canvas, Offset center, double s) {
    // 眨眼开心
    final eyePaint = Paint()..color = const Color(0xFF4A4A4A);
    canvas.drawCircle(
      Offset(center.dx - s * 0.25, center.dy - s * 0.05 + bounceOffset),
      s * 0.1, eyePaint,
    );
    
    final closedEyePaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + s * 0.15, center.dy - s * 0.05 + bounceOffset),
      Offset(center.dx + s * 0.35, center.dy - s * 0.05 + bounceOffset),
      closedEyePaint,
    );
    
    // 微笑
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + s * 0.35 + bounceOffset),
        width: s * 0.25,
        height: s * 0.2,
      ),
      0, math.pi, false, mouthPaint,
    );
    
    // 挥手
    _drawWavingArm(canvas, center, s);
  }
  
  void _drawRaisedArm(Canvas canvas, Offset center, double s, bool isLeft) {
    final armPaint = Paint()
      ..color = FurryColors.ellGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.12
      ..strokeCap = StrokeCap.round;
    
    final direction = isLeft ? -1.0 : 1.0;
    canvas.drawLine(
      Offset(center.dx + direction * s * 0.65, center.dy + bounceOffset),
      Offset(center.dx + direction * s * 0.9, center.dy - s * 0.4 + bounceOffset),
      armPaint,
    );
    
    // 小手
    final handPaint = Paint()..color = FurryColors.ellGray;
    canvas.drawCircle(
      Offset(center.dx + direction * s * 0.9, center.dy - s * 0.45 + bounceOffset),
      s * 0.12, handPaint,
    );
  }
  
  void _drawWavingArm(Canvas canvas, Offset center, double s) {
    final armPaint = Paint()
      ..color = FurryColors.ellGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx + s * 0.65, center.dy + s * 0.1 + bounceOffset),
      Offset(center.dx + s * 1.0, center.dy - s * 0.2 + bounceOffset),
      armPaint,
    );
    
    // 小手
    final handPaint = Paint()..color = FurryColors.ellGray;
    canvas.drawCircle(
      Offset(center.dx + s * 1.0, center.dy - s * 0.25 + bounceOffset),
      s * 0.12, handPaint,
    );
  }
  
  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final point = Offset(
        center.dx + size * math.cos(angle),
        center.dy + size * math.sin(angle),
      );
      if (i == 0) path.moveTo(point.dx, point.dy);
      else path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant _CheerEllPainter oldDelegate) {
    return oldDelegate.celebrating != celebrating ||
           oldDelegate.waving != waving ||
           oldDelegate.bounceOffset != bounceOffset;
  }
}

// ========== 🎭 毛绒三友组合 Widget ==========
class FurryTrioDisplay extends StatelessWidget {
  final FurryTrio activeCharacter;
  final VoidCallback? onBearTap;
  final VoidCallback? onBunnyTap;
  final VoidCallback? onEllTap;
  final bool sleeping;
  
  const FurryTrioDisplay({
    super.key,
    this.activeCharacter = FurryTrio.dataBear,
    this.onBearTap,
    this.onBunnyTap,
    this.onEllTap,
    this.sleeping = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 兔厨 (左侧)
        Transform.scale(
          scale: activeCharacter == FurryTrio.chefBunny ? 1.1 : 0.9,
          child: Opacity(
            opacity: activeCharacter == FurryTrio.chefBunny ? 1.0 : 0.6,
            child: ChefBunny(
              size: 80,
              animate: activeCharacter == FurryTrio.chefBunny,
              excited: activeCharacter == FurryTrio.chefBunny,
              onTap: onBunnyTap,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 熊仔 (中间 - 最大)
        Transform.scale(
          scale: activeCharacter == FurryTrio.dataBear ? 1.2 : 1.0,
          child: Opacity(
            opacity: activeCharacter == FurryTrio.dataBear ? 1.0 : 0.6,
            child: DataBear(
              size: 100,
              animate: true,
              sleeping: sleeping,
              celebrating: activeCharacter == FurryTrio.dataBear && !sleeping,
              onTap: onBearTap,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 象宝 (右侧)
        Transform.scale(
          scale: activeCharacter == FurryTrio.cheerEll ? 1.1 : 0.9,
          child: Opacity(
            opacity: activeCharacter == FurryTrio.cheerEll ? 1.0 : 0.6,
            child: CheerEll(
              size: 80,
              animate: activeCharacter == FurryTrio.cheerEll,
              celebrating: activeCharacter == FurryTrio.cheerEll,
              onTap: onEllTap,
            ),
          ),
        ),
      ],
    );
  }
}
