import 'package:flutter/material.dart';

class AuraPetTheme {
  // Primary Colors (Monet-inspired warm palette)
  static const Color primary = Color(0xFFFF9B7B);
  static const Color primaryDark = Color(0xFFFF8255);
  static const Color secondary = Color(0xFFFFD93D);
  static const Color accent = Color(0xFF6BCB77);
  static const Color water = Color(0xFF4D96FF);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color purple = Color(0xFF9B59B6);

  // Background Colors
  static const Color bgCream = Color(0xFFFFF8F0);
  static const Color bgPink = Color(0xFFFFE5E0);
  static const Color bgGreen = Color(0xFFE8F5E8);
  static const Color bgBlue = Color(0xFFD4ECFF);
  static const Color bgPurple = Color(0xFFF4E8FF);
  static const Color white = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textDark = Color(0xFF2D3436);
  static const Color textLight = Color(0xFF636E72);
  static const Color textMuted = Color(0xFFB2BEC3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [accent, Color(0xFF5BBF68)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient waterGradient = LinearGradient(
    colors: [Color(0xFF7BC4FF), water],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient subscriptionGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: primary.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: primary.withValues(alpha: 0.15),
          blurRadius: 30,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: primary.withValues(alpha: 0.25),
          blurRadius: 40,
          offset: const Offset(0, 12),
        ),
      ];

  // Text Styles
  static const TextStyle headingXl = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: textDark,
    height: 1.2,
  );

  static const TextStyle headingLg = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: textDark,
  );

  static const TextStyle headingMd = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textDark,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textDark,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textLight,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textLight,
  );

  static ThemeData get lightTheme => ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: bgCream,
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: white,
          error: danger,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: textDark),
          titleTextStyle: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButton: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecoration: InputDecoration(
          filled: true,
          fillColor: white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
        ),
      );
}
