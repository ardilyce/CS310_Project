import 'package:flutter/material.dart';

class AppUtility {
  static bool _isDarkMode = false;

  static const Color lightPrimaryBlue = Color(0xFF0055AA);
  static const Color darkPrimaryBlue = Color(0xFF1E4C8F);
  static const Color lightSecondaryBlue = Color(0xFFC5E2FF);
  static const Color darkSecondaryBlue = Color(0xFF1A2F4D);
  static const Color lightThirdBlue = Color(0xFF022047);
  static const Color darkThirdBlue = Color(0xFF081322);
  static const Color lightTextDark = Color(0xFF333333);
  static const Color darkTextDark = Color(0xFFE6EDF7);
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color lightTextGrey = Colors.grey;
  static const Color darkTextGrey = Color(0xFF9AA4B2);
  static const Color lightTextLight = Colors.white70;
  static const Color darkTextLight = Color(0xFFC9D4E3);
  static const Color lightTextLight2 = Colors.white54;
  static const Color darkTextLight2 = Color(0xFF9DA8B8);

  static void setDarkMode(bool value) {
    _isDarkMode = value;
  }

  static bool get isDarkMode => _isDarkMode;

  static Color get primaryBlue =>
      _isDarkMode ? darkPrimaryBlue : lightPrimaryBlue;
  static Color get secondaryBlue =>
      _isDarkMode ? darkSecondaryBlue : lightSecondaryBlue;
  static Color get thirdBlue =>
      _isDarkMode ? darkThirdBlue : lightThirdBlue;
  static Color get textDark => _isDarkMode ? darkTextDark : lightTextDark;
  static Color get textWhite => Colors.white;
  static Color get textLight => _isDarkMode ? darkTextLight : lightTextLight;
  static Color get textLight2 => _isDarkMode ? darkTextLight2 : lightTextLight2;
  static Color get background =>
      _isDarkMode ? darkBackground : lightBackground;
  static Color get textGrey => _isDarkMode ? darkTextGrey : lightTextGrey;

  // Dynamic Risk Colors
  static const Color riskGreen = Color(0xFF6BCD36); // 0-25
  static const Color riskYellow = Color(0xFFDABC44); // 25-50
  static const Color riskOrange = Color(0xFFD96938); // 50-75
  static const Color riskRed = Color(0xFFA12325); // 75-100

  static Color getColorForScore(int score) {
    if (score <= 15) return riskGreen;
    if (score <= 30) return riskYellow;
    if (score <= 70) return riskOrange;
    return riskRed;
  }

}
