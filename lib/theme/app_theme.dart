import 'package:flutter/material.dart';

class AppPalette {
  Color primaryGreen;
  Color accentGreen;
  Color background;
  Color textPrimary;
  Color textSecondary;

  AppPalette({
    required this.primaryGreen,
    required this.accentGreen,
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
  });

  static AppPalette current = AppPalette(
    primaryGreen: const Color(0xFF81C784),
    accentGreen: const Color(0xFF43A047),
    background: Colors.white,
    textPrimary: Colors.black87,
    textSecondary: Colors.black54,
  );

  static void update(AppPalette newPalette) {
    current = newPalette;
  }
}

ThemeData getAppTheme() {
  final c = AppPalette.current;
  return ThemeData(
    primaryColor: c.primaryGreen,
    scaffoldBackgroundColor: c.background,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: c.primaryGreen,
      secondary: c.accentGreen,
      surface: c.background,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: c.primaryGreen,
      foregroundColor: c.background,
      elevation: 0,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: c.textPrimary, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: c.textSecondary),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: c.primaryGreen,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
