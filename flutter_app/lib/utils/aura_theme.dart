import 'package:flutter/material.dart';

/// Aura-Pet 极简空气感主题
/// 锁定柔和淡蓝渐变 + Poppins 字体
class AuraPetTheme {
  AuraPetTheme._();

  // ================== 核心配色 ==================

  /// 极简空气蓝渐变背景
  static const Color backgroundStart = Color(0xFFEDF6FA);
  static const Color backgroundEnd = Color(0xFFC1DDF1);
  
  /// 主色调
  static const Color primary = Color(0xFF6B9EB8);
  static const Color primaryLight = Color(0xFF8FBDD3);
  static const Color primaryDark = Color(0xFF4A7A94);
  
  /// 强调色
  static const Color accent = Color(0xFFFF8BA0);
  static const Color accentLight = Color(0xFFFFB4C4);
  
  /// 心形粉色系
  static const Color heartPink = Color(0xFFFF6B8A);
  static const Color heartLight = Color(0xFFFFB4C4);
  
  /// 功能色
  static const Color success = Color(0xFF7BC47F);
  static const Color warning = Color(0xFFFFB74D);
  static const Color danger = Color(0xFFE57373);
  
  /// 文字色
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);
  
  /// 表面色
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceOverlay = Color(0xFFF5FAFC);
  
  /// 小熊色系
  static const Color raccoonGray = Color(0xFF8E9EAB);
  static const Color raccoonDark = Color(0xFF6B7A8A);
  static const Color raccoonLight = Color(0xFFB8C5D0);
  static const Color noseBlack = Color(0xFF2D3436);
  static const Color eyeShine = Color(0xFFFFFFFF);
  
  /// Aura光晕色
  static const Color auraGlow = Color(0xFFFF9EC4);
  static const Color auraGlowSoft = Color(0xFFFFE4EE);

  // ================== 渐变配置 ==================

  /// 背景渐变
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundStart, backgroundEnd],
  );

  /// Aura光晕渐变
  static LinearGradient auraGlowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      auraGlow.withValues(alpha: 0.6),
      auraGlowSoft.withValues(alpha: 0.3),
      Colors.transparent,
    ],
  );

  /// 心形气泡渐变
  static LinearGradient heartBubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      heartLight.withValues(alpha: 0.8),
      heartPink.withValues(alpha: 0.6),
    ],
  );

  // ================== 阴影 ==================

  /// 轻柔阴影 (空气感)
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// 中等阴影
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.12),
      blurRadius: 30,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  /// 心形阴影
  static List<BoxShadow> get heartShadow => [
    BoxShadow(
      color: heartPink.withValues(alpha: 0.3),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];

  // ================== Flutter ThemeData ==================

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // 背景色
    scaffoldBackgroundColor: backgroundStart,
    
    // 主色
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: accent,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      error: danger,
    ),
    
    // 字体
    fontFamily: 'Poppins',
    
    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    
    // 卡片
    cardTheme: CardTheme(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.zero,
    ),
    
    // 按钮
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: textPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    
    // 文字按钮
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // 输入框
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: textLight,
      ),
    ),
    
    // 底部导航
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      elevation: 0,
      selectedItemColor: primary,
      unselectedItemColor: textLight,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // 文本主题
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
    ),
  );
}

/// 极简空气感间距常量
class AuraSpacing {
  AuraSpacing._();
  
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

/// 极简圆角常量
class AuraRadius {
  AuraRadius._();
  
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 100;
}
