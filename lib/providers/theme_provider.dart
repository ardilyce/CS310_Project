import 'package:flutter/material.dart';
import '../screens/utility_class.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    AppUtility.setDarkMode(value);
    notifyListeners();
  }

  void toggleDarkMode() {
    setDarkMode(!_isDarkMode);
  }
}
