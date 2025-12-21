import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/utility_class.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  static const String _darkModeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  // Initialize theme from shared preferences
  Future<void> loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      AppUtility.setDarkMode(_isDarkMode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      // Default to light mode if there's an error
      _isDarkMode = false;
      AppUtility.setDarkMode(false);
      notifyListeners();
    }
  }

  void setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    AppUtility.setDarkMode(value);
    notifyListeners();
    
    // Save preference to shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, value);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  void toggleDarkMode() {
    setDarkMode(!_isDarkMode);
  }
}
