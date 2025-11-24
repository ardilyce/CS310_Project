import 'package:flutter/material.dart';

class AppUtility {
  static const Color primaryBlue = Color(0xFF0A4DBA);
  static const Color secondaryBlue = Color(0xFF022047);
  static const Color textDark = Color(0xFF333333);
  static const Color background = Colors.white;

  // Dynamic Risk Colors
  static const Color riskGreen = Color(0xFF72C936); // 0-25
  static const Color riskYellow = Color(0xFFEBC334); // 25-50
  static const Color riskOrange = Color(0xFFE66A34); // 50-75
  static const Color riskRed = Color(0xFFA82222); // 75-100

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
