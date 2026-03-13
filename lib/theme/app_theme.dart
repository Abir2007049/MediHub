import 'package:flutter/material.dart';

/// Get the patient-themed app theme (calming, trust-building)
ThemeData getPatientTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Primary colors: Calming teal/mint palette
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF00897B), // Teal
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFB2DFDB), // Light teal
      onPrimaryContainer: Color(0xFF004D40),
      secondary: Color(0xFF26A69A), // Mint
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFB2EBE7), // Light mint
      onSecondaryContainer: Color(0xFF00463F),
      surface: Color(0xFFFAFAFA), // Off-white
      onSurface: Color(0xFF1A1A1A), // Near black
      outline: Color(0xFFBDBDBD), // Medium gray
      outlineVariant: Color(0xFFE0E0E0), // Light gray
      error: Color(0xFFD32F2F), // Red
      onError: Colors.white,
      errorContainer: Color(0xFFFFCDD2),
      onErrorContainer: Color(0xFF8B0000),
      scrim: Color(0xFF000000),
    ),

    // Typography
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0,
        color: Color(0xFF1A1A1A),
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: 0,
        color: Color(0xFF1A1A1A),
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0,
        color: Color(0xFF1A1A1A),
      ),
      headlineLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0,
        color: Color(0xFF1A1A1A),
      ),
      headlineMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.44,
        letterSpacing: 0,
        color: Color(0xFF1A1A1A),
      ),
      headlineSmall: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.15,
        color: Color(0xFF1A1A1A),
      ),
      titleLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.15,
        color: Color(0xFF1A1A1A),
      ),
      titleMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: Color(0xFF1A1A1A),
      ),
      titleSmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.1,
        color: Color(0xFF1A1A1A),
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
        color: Color(0xFF1A1A1A),
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: Color(0xFF424242),
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: Color(0xFF424242),
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: Colors.white,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: Color(0xFF757575),
      ),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
        color: Color(0xFF757575),
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFAFAFA),
      foregroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A), size: 24),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00897B), width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 3),
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF424242),
      ),
      hintStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF757575),
      ),
      helperStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF757575),
      ),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return const Color(0xFF00897B);
        }
        return const Color(0xFF757575);
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return const Color(0xFF00897B);
        }
        return const Color(0xFF757575);
      }),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00897B),
        side: const BorderSide(color: Color(0xFF00897B), width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: Color(0xFF00897B), size: 24),

    // Other
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    canvasColor: const Color(0xFFFFFFFF),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
      space: 16,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF00897B),
      linearMinHeight: 4,
    ),
  );
}

/// Get the doctor-themed app theme (professional, authoritative)
ThemeData getDoctorTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Primary colors: Professional navy/indigo palette
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1A3A7A), // Navy blue
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD1E1FF), // Light blue
      onPrimaryContainer: Color(0xFF001C4A),
      secondary: Color(0xFF3E4B7C), // Indigo
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFD4DFF5), // Light indigo
      onSecondaryContainer: Color(0xFF1D2442),
      surface: Color(0xFFFDFDFD), // Pure white
      onSurface: Color(0xFF0E1117), // Dark gray-blue
      outline: Color(0xFF8B92A1), // Steel gray
      outlineVariant: Color(0xFFC9D0DC), // Light gray
      error: Color(0xFFBA1B1B), // Muted red
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      scrim: Color(0xFF000000),
    ),

    // Typography
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0,
        color: Color(0xFF0E1117),
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.29,
        letterSpacing: 0,
        color: Color(0xFF0E1117),
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
        letterSpacing: 0,
        color: Color(0xFF0E1117),
      ),
      headlineLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: 0,
        color: Color(0xFF0E1117),
      ),
      headlineMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.44,
        letterSpacing: 0,
        color: Color(0xFF0E1117),
      ),
      headlineSmall: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.15,
        color: Color(0xFF0E1117),
      ),
      titleLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.15,
        color: Color(0xFF0E1117),
      ),
      titleMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: Color(0xFF0E1117),
      ),
      titleSmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.1,
        color: Color(0xFF0E1117),
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
        color: Color(0xFF0E1117),
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: Color(0xFF424242),
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: Color(0xFF57636B),
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: Colors.white,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: Color(0xFF8B92A1),
      ),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
        color: Color(0xFF8B92A1),
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFDFDFD),
      foregroundColor: const Color(0xFF0E1117),
      elevation: 1,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0E1117),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF0E1117), size: 24),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFDFDFD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD0D7DE), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD0D7DE), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1A3A7A), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFBA1B1B), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFBA1B1B), width: 2),
      ),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF424242),
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8B92A1),
      ),
      helperStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8B92A1),
      ),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return const Color(0xFF1A3A7A);
        }
        return const Color(0xFF8B92A1);
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return const Color(0xFF1A3A7A);
        }
        return const Color(0xFF8B92A1);
      }),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A3A7A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1A3A7A),
        side: const BorderSide(color: Color(0xFF1A3A7A), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: Color(0xFF1A3A7A), size: 24),

    // Other
    scaffoldBackgroundColor: const Color(0xFFFDFDFD),
    canvasColor: const Color(0xFFFFFFFF),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFD0D7DE),
      thickness: 1,
      space: 16,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF1A3A7A),
      linearMinHeight: 4,
    ),
  );
}

// Deprecated - kept for backward compatibility
ThemeData getAppTheme() => getPatientTheme();
