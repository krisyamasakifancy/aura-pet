import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 莫奈花园明信片分享引擎
/// 自动生成精美海报，支持一键分享
class MonetGardenShare {
  static MonetGardenShare? _instance;
  static MonetGardenShare get instance => _instance ??= MonetGardenShare._();
  MonetGardenShare._();

  // ================== 明信片模板 ==================

  /// 生成莫奈风格明信片
  Future<ShareCardData> generatePostcard({
    required String petName,
    required int level,
    required int auraScore,
    required String dailyQuote,
    required String achievement,
    required Uint8List? petImage,
    MonetTemplate template = MonetTemplate.waterLily,
  }) async {
    // 创建画布
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(1080, 1920); // 9:16竖版

    // 绘制背景
    _drawBackground(canvas, size, template);

    // 绘制装饰元素
    _drawDecorations(canvas, size, template);

    // 绘制宠物头像
    await _drawPetAvatar(canvas, size, petImage, auraScore);

    // 绘制文字信息
    _drawTextInfo(canvas, size, petName, level, auraScore, dailyQuote, achievement);

    // 绘制水印
    _drawWatermark(canvas, size);

    // 结束绘制
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return ShareCardData(
      imageBytes: byteData!.buffer.asUint8List(),
      template: template,
      generatedAt: DateTime.now(),
    );
  }

  /// 绘制背景
  void _drawBackground(Canvas canvas, Size size, MonetTemplate template) {
    final colors = _getTemplateColors(template);
    
    // 渐变背景
    final gradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors.background,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gradient);

    // 添加纹理效果
    final texturePaint = Paint()
      ..color = colors.texture.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // 绘制莫奈风格的模糊圆形装饰
    for (int i = 0; i < 8; i++) {
      final x = size.width * (0.1 + (i % 4) * 0.25) + (i.isEven ? 50 : -50);
      final y = size.height * (0.1 + (i ~/ 4) * 0.4);
      canvas.drawCircle(
        Offset(x, y),
        100 + (i * 20).toDouble(),
        texturePaint..color = colors.accent.withOpacity(0.05 + (i * 0.01)),
      );
    }
  }

  /// 绘制装饰元素
  void _drawDecorations(Canvas canvas, Size size, MonetTemplate template) {
    final colors = _getTemplateColors(template);

    // 绘制光晕
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colors.accent.withOpacity(0.4),
          colors.accent.withOpacity(0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(size.width / 2, size.height * 0.3), radius: 400),
      );

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.3),
      400,
      glowPaint,
    );

    // 绘制边框
    final borderPaint = Paint()
      ..color = colors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(40, 40, size.width - 80, size.height - 80),
        const Radius.circular(30),
      ),
      borderPaint,
    );
  }

  /// 绘制宠物头像
  Future<void> _drawPetAvatar(
    Canvas canvas,
    Size size,
    Uint8List? petImage,
    int auraScore,
  ) async {
    final centerX = size.width / 2;
    final avatarY = size.height * 0.28;
    final avatarSize = 280.0;

    // 光晕
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          _getAuraColor(auraScore).withOpacity(0.6),
          _getAuraColor(auraScore).withOpacity(0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(centerX, avatarY), radius: avatarSize),
      );

    canvas.drawCircle(Offset(centerX, avatarY), avatarSize * 1.3, glowPaint);

    // 白色圆形背景
    canvas.drawCircle(
      Offset(centerX, avatarY),
      avatarSize,
      Paint()..color = Colors.white,
    );

    // 宠物emoji (如果没有图片)
    if (petImage == null) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: '🐻',
          style: TextStyle(fontSize: 140),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          avatarY - textPainter.height / 2,
        ),
      );
    }
  }

  /// 绘制文字信息
  void _drawTextInfo(
    Canvas canvas,
    Size size,
    String petName,
    int level,
    int auraScore,
    String dailyQuote,
    String achievement,
  ) {
    final centerX = size.width / 2;

    // 宠物名称
    final namePainter = TextPainter(
      text: TextSpan(
        text: petName,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A4063),
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    namePainter.paint(
      canvas,
      Offset(centerX - namePainter.width / 2, size.height * 0.48),
    );

    // 等级
    final levelPainter = TextPainter(
      text: TextSpan(
        text: 'Lv.$level',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFAB76),
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    levelPainter.paint(
      canvas,
      Offset(centerX - levelPainter.width / 2, size.height * 0.54),
    );

    // Aura Score
    final scorePainter = TextPainter(
      text: TextSpan(
        text: '✨ $auraScore Aura',
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFFD93D),
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    scorePainter.paint(
      canvas,
      Offset(centerX - scorePainter.width / 2, size.height * 0.60),
    );

    // 成就徽章
    final badgePaint = Paint()
      ..color = const Color(0xFFFFB5B5).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, size.height * 0.68),
          width: 400,
          height: 60,
        ),
        const Radius.circular(30),
      ),
      badgePaint,
    );

    final badgePainter = TextPainter(
      text: TextSpan(
        text: '🏆 $achievement',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE57373),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    badgePainter.paint(
      canvas,
      Offset(centerX - badgePainter.width / 2, size.height * 0.66),
    );

    // 每日金句
    final quotePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, size.height * 0.78),
          width: 900,
          height: 180,
        ),
        const Radius.circular(20),
      ),
      quotePaint,
    );

    final quotePainter = TextPainter(
      text: TextSpan(
        text: '"$dailyQuote"',
        style: const TextStyle(
          fontSize: 28,
          fontStyle: FontStyle.italic,
          color: Color(0xFF636E72),
          height: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 860);

    quotePainter.paint(
      canvas,
      Offset(centerX - quotePainter.width / 2, size.height * 0.74),
    );

    // 底部标语
    final sloganPainter = TextPainter(
      text: const TextSpan(
        text: 'Aura-Pet · 数字艺术疗愈',
        style: TextStyle(
          fontSize: 20,
          color: Color(0xFFB2BEC3),
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    sloganPainter.paint(
      canvas,
      Offset(centerX - sloganPainter.width / 2, size.height * 0.88),
    );
  }

  /// 绘制水印
  void _drawWatermark(Canvas canvas, Size size) {
    final watermarkPainter = TextPainter(
      text: const TextSpan(
        text: '✨',
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // 四角装饰
    final positions = [
      Offset(60, 60),
      Offset(size.width - 80, 60),
      Offset(60, size.height - 80),
      Offset(size.width - 80, size.height - 80),
    ];

    for (final pos in positions) {
      watermarkPainter.paint(canvas, pos);
    }
  }

  /// 获取模板颜色
  _TemplateColors _getTemplateColors(MonetTemplate template) {
    switch (template) {
      case MonetTemplate.waterLily:
        return _TemplateColors(
          background: [const Color(0xFFE8F5E9), const Color(0xFFFFF8E1)],
          accent: const Color(0xFF81C784),
          texture: const Color(0xFFA5D6A7),
          border: const Color(0xFFA5D6A7),
        );
      case MonetTemplate.sunset:
        return _TemplateColors(
          background: [const Color(0xFFFFE0B2), const Color(0xFFFFCDD2)],
          accent: const Color(0xFFFF8A65),
          texture: const Color(0xFFFFAB91),
          border: const Color(0xFFFFAB91),
        );
      case MonetTemplate.night:
        return _TemplateColors(
          background: [const Color(0xFF1A237E), const Color(0xFF311B92)],
          accent: const Color(0xFF7C4DFF),
          texture: const Color(0xFF9575CD),
          border: const Color(0xFF9575CD),
        );
      case MonetTemplate.rose:
        return _TemplateColors(
          background: [const Color(0xFFFCE4EC), const Color(0xFFF8BBD9)],
          accent: const Color(0xFFE91E63),
          texture: const Color(0xFFF48FB1),
          border: const Color(0xFFF48FB1),
        );
    }
  }

  /// 获取Aura颜色
  Color _getAuraColor(int score) {
    if (score >= 80) return const Color(0xFFFFD700);
    if (score >= 60) return const Color(0xFFFFE066);
    if (score >= 40) return const Color(0xFFFFAB76);
    return const Color(0xFF90CAF9);
  }
}

/// 莫奈模板
enum MonetTemplate {
  waterLily, // 睡莲
  sunset,    // 晚霞
  night,     // 星空
  rose,      // 玫瑰
}

/// 模板颜色
class _TemplateColors {
  final List<Color> background;
  final Color accent;
  final Color texture;
  final Color border;

  const _TemplateColors({
    required this.background,
    required this.accent,
    required this.texture,
    required this.border,
  });
}

/// 分享卡片数据
class ShareCardData {
  final Uint8List imageBytes;
  final MonetTemplate template;
  final DateTime generatedAt;

  const ShareCardData({
    required this.imageBytes,
    required this.template,
    required this.generatedAt,
  });

  /// 保存到本地
  Future<String?> saveToFile(String path) async {
    // 实际项目中使用 path_provider 保存
    return path;
  }
}

/// 分享管理器
class ShareManager {
  static ShareManager? _instance;
  static ShareManager get instance => _instance ??= ShareManager._();
  ShareManager._();

  /// 分享到微信
  Future<bool> shareToWechat(ShareCardData card) async {
    // 实际项目中使用 share_plus 或 wechat_share_kit
    // 模拟成功
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 分享到Instagram
  Future<bool> shareToInstagram(ShareCardData card) async {
    // 实际项目中使用 image_picker 或 share
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 保存到相册
  Future<bool> saveToGallery(ShareCardData card) async {
    // 实际项目中使用 image_gallery_saver
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

/// 分享触发器
class ShareTrigger {
  /// 成就达成分享
  static Future<ShareCardData> onAchievementUnlock({
    required String petName,
    required int level,
    required int auraScore,
    required String achievement,
  }) async {
    // 从语料库获取金句
    const quotes = [
      '今天的我，比昨天更闪耀',
      '每一口都是对自己的爱',
      '健康是最好的礼物',
      '和小熊一起，遇见更好的自己',
    ];
    final quote = quotes[DateTime.now().millisecond % quotes.length];

    return MonetGardenShare.instance.generatePostcard(
      petName: petName,
      level: level,
      auraScore: auraScore,
      dailyQuote: quote,
      achievement: achievement,
    );
  }

  /// 宠物进化分享
  static Future<ShareCardData> onPetEvolution({
    required String petName,
    required int level,
    required int auraScore,
  }) async {
    const achievements = [
      '宠物进化成功',
      '解锁新形态',
      '成长里程碑',
    ];
    final achievement = achievements[DateTime.now().millisecond % achievements.length];

    return MonetGardenShare.instance.generatePostcard(
      petName: petName,
      level: level,
      auraScore: auraScore,
      dailyQuote: '新的形态，新的开始 ✨',
      achievement: achievement,
    );
  }
}
