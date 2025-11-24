import 'package:flutter/material.dart';

class AppUtility {
  static const Color primaryBlue = Color(0xFF0055AA);
  static const Color secondaryBlue = Color(0xFFC5E2FF);
  static const Color thirdBlue = Color(0xFF022047);
  static const Color textDark = Color(0xFF333333);
  static const Color textWhite = Colors.white;
  static const Color textLight = Colors.white70;
  static const Color textLight2 = Colors.white54;
  static const Color background = Colors.white;

  // Dynamic Risk Colors
  static const Color riskGreen = Color(0xFF6BCD36); // 0-25
  static const Color riskYellow = Color(0xFFDABC44); // 25-50
  static const Color riskOrange = Color(0xFFD96938); // 50-75
  static const Color riskRed = Color(0xFFA12325); // 75-100

  static Color getColorForScore(int score) {
    if (score <= 25) return riskGreen;
    if (score <= 50) return riskYellow;
    if (score <= 75) return riskOrange;
    return riskRed;
  }

  static String getRiskForScore(int score) {
    if (score <= 25) return "no risk";
    if (score <= 50) return "low risk";
    if (score <= 75) return "medium risk";
    return "high risk";
  }
}
