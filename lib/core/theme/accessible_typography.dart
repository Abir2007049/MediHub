import 'package:flutter/material.dart';

class AccessibleTypography {
  // Heading 1: 32sp, w600, line-height 1.25
  static const headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  );

  // Heading 2: 24sp, w600, line-height 1.33
  static const headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  );

  // Heading 3: 20sp, w600, line-height 1.4
  static const headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  // Body: 16sp, w400, line-height 1.5
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.3,
  );

  // Body Small: 14sp, w400, line-height 1.43
  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  // Label: 12sp, w500, line-height 1.33
  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
  );
}
