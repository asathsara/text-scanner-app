import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeKey = 'isDark';
  bool _isDark = false;

  ThemeProvider() {
    _loadThemeFromPrefs(); // Load theme on initialization
  }

  bool get isDark => _isDark;

  ThemeMode get currentThemeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDark);
  }

  void _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    notifyListeners(); // Notify listeners after loading
  }
}
