import 'dart:async';
import 'package:flutter/material.dart';

/// 莫奈时钟系统 - 时间感知氛围渲染
/// 让UI随用户当地时间自动变色，模拟莫奈画作的光影变化
class MonetClock extends ChangeNotifier {
  static MonetClock? _instance;
  static MonetClock get instance => _instance ??= MonetClock._();
  MonetClock._();

  late Timer _timer;
  MonetTimePhase _currentPhase = MonetTimePhase.noon;
  
  MonetTimePhase get currentPhase => _currentPhase;
  
  void start() {
    _updatePhase();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updatePhase();
    });
  }
  
  void stop() {
    _timer.cancel();
  }
  
  void _updatePhase() {
    final hour = DateTime.now().hour;
    MonetTimePhase newPhase;
    
    if (hour >= 5 && hour < 8) {
      newPhase = MonetTimePhase.dawn;      // 清晨
    } else if (hour >= 8 && hour < 11) {
      newPhase = MonetTimePhase.morning;   // 上午
    } else if (hour >= 11 && hour < 14) {
      newPhase = MonetTimePhase.noon;      // 正午
    } else if (hour >= 14 && hour < 17) {
      newPhase = MonetTimePhase.afternoon; // 下午
    } else if (hour >= 17 && hour < 19) {
      newPhase = MonetTimePhase.sunset;    // 傍晚
    } else if (hour >= 19 && hour < 22) {
      newPhase = MonetTimePhase.evening;   // 傍晚夜晚
    } else {
      newPhase = MonetTimePhase.night;     // 深夜
    }
    
    if (newPhase != _currentPhase) {
      _currentPhase = newPhase;
      notifyListeners();
    }
  }
}

/// 时间阶段枚举
enum MonetTimePhase {
  dawn,      // 清晨 5-8点
  morning,   // 上午 8-11点
  noon,      // 正午 11-14点
  afternoon, // 下午 14-17点
  sunset,    // 傍晚 17-19点
  evening,   // 夜晚 19-22点
  night,     // 深夜 22-5点
}

/// 莫奈色板
class MonetPalette {
  MonetPalette._();

  // ================== 各时间段的颜色配置 ==================

  /// 清晨 - 浅紫微亮
  static MonetColors get dawn => MonetColors(
    phase: MonetTimePhase.dawn,
    background: const Color(0xFFF5F0FF),      // 淡紫
    backgroundGradient: [
      const Color(0xFFF5F0FF),
      const Color(0xFFFFE8E0),
    ],
    surface: Colors.white,
    surfaceVariant: const Color(0xFFFFF5F0),
    primary: const Color(0xFFE8D5FF),          // 柔紫
    accent: const Color(0xFFFFB5C5),           // 玫瑰粉
    textPrimary: const Color(0xFF4A4063),
    textSecondary: const Color(0xFF7A7590),
    petGlow: const Color(0xFFFFE4B5),           // 暖晨光
    petGlowIntensity: 0.4,
    shimmerBase: const Color(0xFFF5F0FF),
    shimmerHighlight: const Color(0xFFFFFFFF),
  );

  /// 上午 - 明亮暖黄
  static MonetColors get morning => MonetColors(
    phase: MonetTimePhase.morning,
    background: const Color(0xFFFFFBF0),       // 暖白
    backgroundGradient: [
      const Color(0xFFFFFBF0),
      const Color(0xFFFFF8E8),
    ],
    surface: Colors.white,
    surfaceVariant: const Color(0xFFFFF5E0),
    primary: const Color(0xFFFFE4A0),           // 暖黄
    accent: const Color(0xFFFFB5B5),            // 柔粉
    textPrimary: const Color(0xFF5D4E37),
    textSecondary: const Color(0xFF8B7D5E),
    petGlow: const Color(0xFFFFE066),           // 阳光金
    petGlowIntensity: 0.5,
    shimmerBase: const Color(0xFFFFFBF0),
    shimmerHighlight: const Color(0xFFFFFFFF),
  );

  /// 正午 - 明亮暖黄
  static MonetColors get noon => MonetColors(
    phase: MonetTimePhase.noon,
    background: const Color(0xFFFFFFFF),        // 纯白
    backgroundGradient: [
      const Color(0xFFFFFFFF),
      const Color(0xFFFFF8F0),
    ],
    surface: Colors.white,
    surfaceVariant: const Color(0xFFFFFBF5),
    primary: const Color(0xFFFFD93D),           // 明亮金
    accent: const Color(0xFFFFAB76),           // 暖橙
    textPrimary: const Color(0xFF4A4A4A),
    textSecondary: const Color(0xFF7D7D7D),
    petGlow: const Color(0xFFFFE066),           // 阳光
    petGlowIntensity: 0.6,
    shimmerBase: const Color(0xFFFFFBF0),
    shimmerHighlight: const Color(0xFFFFFFFF),
  );

  /// 下午 - 暖橙午后
  static MonetColors get afternoon => MonetColors(
    phase: MonetTimePhase.afternoon,
    background: const Color(0xFFFFF8F0),        // 暖调白
    backgroundGradient: [
      const Color(0xFFFFF8F0),
      const Color(0xFFFFEFE0),
    ],
    surface: Colors.white,
    surfaceVariant: const Color(0xFFFFF5E5),
    primary: const Color(0xFFFFAB76),           // 暖橙
    accent: const Color(0xFFE8A5C5),            // 柔粉
    textPrimary: const Color(0xFF5D4A37),
    textSecondary: const Color(0xFF8B7D6E),
    petGlow: const Color(0xFFFFCC66),           // 午后金
    petGlowIntensity: 0.5,
    shimmerBase: const Color(0xFFFFF8F0),
    shimmerHighlight: const Color(0xFFFFFFFF),
  );

  /// 傍晚 - 晚霞橙红
  static MonetColors get sunset => MonetColors(
    phase: MonetTimePhase.sunset,
    background: const Color(0xFFFFE8D5),        // 晚霞橙
    backgroundGradient: [
      const Color(0xFFFFE8D5),
      const Color(0xFFFFD0C0),
    ],
    surface: Colors.white,
    surfaceVariant: const Color(0xFFFFF0E5),
    primary: const Color(0xFFFF8C6B),           // 珊瑚橙
    accent: const Color(0xFFFF6B8A),            // 晚霞红
    textPrimary: const Color(0xFF5D3A2E),
    textSecondary: const Color(0xFF8B6E5E),
    petGlow: const Color(0xFFFF7744),           // 夕阳橙
    petGlowIntensity: 0.7,
    shimmerBase: const Color(0xFFFFE8D5),
    shimmerHighlight: const Color(0xFFFFFBF0),
  );

  /// 夜晚 - 幽静深蓝
  static MonetColors get evening => MonetColors(
    phase: MonetTimePhase.evening,
    background: const Color(0xFFE8E0F0),       // 夜紫
    backgroundGradient: [
      const Color(0xFFE8E0F0),
      const Color(0xFFD5E0F0),
    ],
    surface: const Color(0xFFF5F0FF),
    surfaceVariant: const Color(0xFFEEE8F5),
    primary: const Color(0xFFA5B5E8),           // 夜蓝
    accent: const Color(0xFFE8B5D5),            // 夜粉
    textPrimary: const Color(0xFF3D3D5D),
    textSecondary: const Color(0xFF6E6E8D),
    petGlow: const Color(0xFFA5C5FF),           // 月光蓝
    petGlowIntensity: 0.5,
    shimmerBase: const Color(0xFFE8E0F0),
    shimmerHighlight: const Color(0xFFF5F0FF),
  );

  /// 深夜 - 深蓝幽静
  static MonetColors get night => MonetColors(
    phase: MonetTimePhase.night,
    background: const Color(0xFF1A1A2E),        // 深夜蓝
    backgroundGradient: [
      const Color(0xFF1A1A2E),
      const Color(0xFF16213E),
    ],
    surface: const Color(0xFF252540),
    surfaceVariant: const Color(0xFF2E2E4A),
    primary: const Color(0xFF5C6BC0),          // 靛蓝
    accent: const Color(0xFF9C6BB5),            // 深紫
    textPrimary: const Color(0xFFE8E0F0),
    textSecondary: const Color(0xFFB0A8C5),
    petGlow: const Color(0xFF8090FF),           // 星光蓝
    petGlowIntensity: 0.8,  // 暗光模式下增强光晕
    shimmerBase: const Color(0xFF2E2E4A),
    shimmerHighlight: const Color(0xFF4A4A6A),
  );

  /// 根据时间段获取颜色
  static MonetColors getColors(MonetTimePhase phase) {
    switch (phase) {
      case MonetTimePhase.dawn: return dawn;
      case MonetTimePhase.morning: return morning;
      case MonetTimePhase.noon: return noon;
      case MonetTimePhase.afternoon: return afternoon;
      case MonetTimePhase.sunset: return sunset;
      case MonetTimePhase.evening: return evening;
      case MonetTimePhase.night: return night;
    }
  }

  /// 获取当前时间段颜色
  static MonetColors getCurrentColors() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 8) return dawn;
    if (hour >= 8 && hour < 11) return morning;
    if (hour >= 11 && hour < 14) return noon;
    if (hour >= 14 && hour < 17) return afternoon;
    if (hour >= 17 && hour < 19) return sunset;
    if (hour >= 19 && hour < 22) return evening;
    return night;
  }
}

/// 莫奈颜色集合
class MonetColors {
  final MonetTimePhase phase;
  final Color background;
  final List<Color> backgroundGradient;
  final Color surface;
  final Color surfaceVariant;
  final Color primary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color petGlow;
  final double petGlowIntensity;
  final Color shimmerBase;
  final Color shimmerHighlight;

  const MonetColors({
    required this.phase,
    required this.background,
    required this.backgroundGradient,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.petGlow,
    required this.petGlowIntensity,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  /// 阶段名称（中文）
  String get phaseName {
    switch (phase) {
      case MonetTimePhase.dawn: return '清晨';
      case MonetTimePhase.morning: return '上午';
      case MonetTimePhase.noon: return '正午';
      case MonetTimePhase.afternoon: return '下午';
      case MonetTimePhase.sunset: return '傍晚';
      case MonetTimePhase.evening: return '夜晚';
      case MonetTimePhase.night: return '深夜';
    }
  }

  /// 阶段描述
  String get phaseDescription {
    switch (phase) {
      case MonetTimePhase.dawn: return '新的一天开始了';
      case MonetTimePhase.morning: return '阳光正好';
      case MonetTimePhase.noon: return '正午时光';
      case MonetTimePhase.afternoon: return '午后惬意';
      case MonetTimePhase.sunset: return '晚霞满天';
      case MonetTimePhase.evening: return '华灯初上';
      case MonetTimePhase.night: return '夜深人静';
    }
  }
}

/// 莫奈主题构建器
class MonetThemeBuilder {
  static ThemeData build(MonetColors colors) {
    final isDark = colors.phase == MonetTimePhase.night || 
                   colors.phase == MonetTimePhase.evening;
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: colors.primary,
        onPrimary: isDark ? Colors.white : const Color(0xFF4A4A4A),
        secondary: colors.accent,
        onSecondary: Colors.white,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceContainerHighest: colors.surfaceVariant,
        onSurfaceVariant: colors.textSecondary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: colors.textPrimary),
        displayMedium: TextStyle(color: colors.textPrimary),
        displaySmall: TextStyle(color: colors.textPrimary),
        headlineLarge: TextStyle(color: colors.textPrimary),
        headlineMedium: TextStyle(color: colors.textPrimary),
        headlineSmall: TextStyle(color: colors.textPrimary),
        titleLarge: TextStyle(color: colors.textPrimary),
        titleMedium: TextStyle(color: colors.textPrimary),
        titleSmall: TextStyle(color: colors.textPrimary),
        bodyLarge: TextStyle(color: colors.textPrimary),
        bodyMedium: TextStyle(color: colors.textSecondary),
        bodySmall: TextStyle(color: colors.textSecondary),
        labelLarge: TextStyle(color: colors.textPrimary),
        labelMedium: TextStyle(color: colors.textSecondary),
        labelSmall: TextStyle(color: colors.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: isDark ? Colors.white : const Color(0xFF4A4A4A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
