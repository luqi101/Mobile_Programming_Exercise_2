import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color ink = Color(0xFF172027);
  static const Color deepTeal = Color(0xFF0F7C80);
  static const Color seaGlass = Color(0xFF6EC6BC);
  static const Color ember = Color(0xFFE16F4D);
  static const Color gold = Color(0xFFF3B64A);
  static const Color mist = Color(0xFFF4F7F4);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: deepTeal,
      brightness: Brightness.light,
      primary: deepTeal,
      secondary: ember,
      tertiary: gold,
      surface: mist,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: mist,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(color: ink, letterSpacing: 0),
        bodyMedium: TextStyle(color: ink, letterSpacing: 0),
        labelLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: deepTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepTeal,
          side: const BorderSide(color: deepTeal, width: 1.4),
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: ink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
