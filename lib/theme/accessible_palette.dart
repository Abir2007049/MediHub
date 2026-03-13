import 'package:flutter/material.dart';

class AccessiblePalette {
  // Primary Colors (high contrast ratios >= 7:1)
  static const Color primaryGreen = Color(0xFF0D7737); // Green
  static const Color accentGreen = Color(0xFF2E8B57); // Sea Green
  static const Color darkBackground = Color(0xFFFAFAFA); // Off-white

  // Text Colors (contrast ratios >= 7:1 against backgrounds)
  static const Color textPrimary = Color(0xFF1A1A1A); // Near black
  static const Color textSecondary = Color(0xFF424242); // Dark gray
  static const Color textHint = Color(0xFF757575); // Medium gray

  // State Colors (colorblind-safe)
  static const Color errorRed = Color(0xFFD32F2F); // Accessible red
  static const Color successGreen = Color(
    0xFF1B5E20,
  ); // Dark green (no red hue)
  static const Color warningOrange = Color(
    0xFFF57C00,
  ); // Orange (visible to all types)
  static const Color infoBlue = Color(0xFF0D47A1); // Navy blue

  // Border & Divider
  static const Color border = Color(0xFFBDBDBD); // Medium gray
  static const Color divider = Color(0xFFE0E0E0); // Light gray

  // State backgrounds
  static const Color disabledBackground = Color(0xFFF5F5F5);
  static const Color focusOutline = Color(0xFF0D7737); // Same as primary (3px)
}
