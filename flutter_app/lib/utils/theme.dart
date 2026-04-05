import 'package:flutter/material.dart';

/// ============================================
// AURA-PET: Theme 系统
// 支持莫奈色系/极简色系切换
/// ============================================

enum ThemeType { monet, minimalist, ocean, forest, sunset }

class AuraTheme {
  final ThemeType type;
  final String name;
  
  // 主色调
  final Color primary;
  final Color secondary;
  final Color accent;
  
  // 背景色
  final Color background;
  final Color surface;
  final Color card;
  
  // 文字色
  final Color textPrimary;
  final Color textSecondary;
  
  // 渐变
  final List<Color> gradient;
  
  // 磨砂玻璃效果
  final Color glassBg;
  final Color glassBorder;
  
  const AuraTheme({
    required this.type,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.gradient,
    required this.glassBg,
    required this.glassBorder,
  });
  
  // 莫奈色系 - 默认
  static const monet = AuraTheme(
    type: ThemeType.monet,
    name: '莫奈花园',
    primary: Color(0xFFFF6B9D),
    secondary: Color(0xFFA855F7),
    accent: Color(0xFF4ADE80),
    background: Color(0xFF0D1117),
    surface: Color(0xFF161B22),
    card: Color(0xFF21262D),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF8B949E),
    gradient: [Color(0xFFFF6B9D), Color(0xFFA855F7)],
    glassBg: Color(0x0FFFFFFF),
    glassBorder: Color(0x1FFFFFFF),
  );
  
  // 极简色系
  static const minimalist = AuraTheme(
    type: ThemeType.minimalist,
    name: '极简主义',
    primary: Color(0xFF000000),
    secondary: Color(0xFF666666),
    accent: Color(0xFF007AFF),
    background: Colors.white,
    surface: Color(0xFFF5F5F5),
    card: Colors.white,
    textPrimary: Colors.black,
    textSecondary: Color(0xFF999999),
    gradient: [Color(0xFF000000), Color(0xFF333333)],
    glassBg: Color(0x0A000000),
    glassBorder: Color(0x14000000),
  );
  
  // 海洋色系
  static const ocean = AuraTheme(
    type: ThemeType.ocean,
    name: '深海蓝',
    primary: Color(0xFF007AFF),
    secondary: Color(0xFF5856D6),
    accent: Color(0xFF34C759),
    background: Color(0xFF001A2C),
    surface: Color(0xFF002244),
    card: Color(0xFF003366),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF7AA2C4),
    gradient: [Color(0xFF007AFF), Color(0xFF5856D6)],
    glassBg: Color(0x0DFFFFFF),
    glassBorder: Color(0x1F7AA2C4),
  );
  
  // 森林色系
  static const forest = AuraTheme(
    type: ThemeType.forest,
    name: '绿野仙踪',
    primary: Color(0xFF34C759),
    secondary: Color(0xFF30D158),
    accent: Color(0xFFFFD60A),
    background: Color(0xFF0A1A0A),
    surface: Color(0xFF1A2E1A),
    card: Color(0xFF2A3E2A),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF8BC88B),
    gradient: [Color(0xFF34C759), Color(0xFF30D158)],
    glassBg: Color(0x0DFFFFFF),
    glassBorder: Color(0x1F8BC88B),
  );
  
  // 日落色系
  static const sunset = AuraTheme(
    type: ThemeType.sunset,
    name: '落日橘',
    primary: Color(0xFFFF9500),
    secondary: Color(0xFFFF6B00),
    accent: Color(0xFF5856D6),
    background: Color(0xFF1A0A05),
    surface: Color(0xFF2E1A10),
    card: Color(0xFF442A1A),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFE8A87C),
    gradient: [Color(0xFFFF9500), Color(0xFFFF6B00)],
    glassBg: Color(0x1AFFFFFF),
    glassBorder: Color(0x2FE8A87C),
  );
  
  static AuraTheme fromType(ThemeType type) {
    switch (type) {
      case ThemeType.monet: return monet;
      case ThemeType.minimalist: return minimalist;
      case ThemeType.ocean: return ocean;
      case ThemeType.forest: return forest;
      case ThemeType.sunset: return sunset;
    }
  }
  
  // 转换为 Flutter ThemeData
  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: background.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      cardColor: card,
      colorScheme: ColorScheme(
        brightness: background.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        tertiary: accent,
        error: const Color(0xFFFF3B30),
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textSecondary),
      ),
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: glassBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }
  
  // 渐变画刷
  LinearGradient get primaryGradient => LinearGradient(
    colors: gradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  RadialGradient get glowGradient => RadialGradient(
    colors: [
      primary.withValues(alpha: 0.4),
      primary.withValues(alpha: 0.1),
      Colors.transparent,
    ],
  );
  
  // 磨砂玻璃容器样式
  BoxDecoration get glassDecoration => BoxDecoration(
    color: glassBg,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: glassBorder),
  );
}
