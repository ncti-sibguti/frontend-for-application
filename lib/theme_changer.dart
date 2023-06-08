import 'package:flutter/material.dart';
import '/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  static const _isDarkThemeKey = 'isDarkTheme';

  bool _isDark = false;

  bool get isDark => _isDark;

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = !_isDark;
    prefs.setBool(_isDarkThemeKey, _isDark);

    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_isDarkThemeKey) ?? false;
    _isDark = isDark;

    notifyListeners();
  }

  ThemeData get currentTheme => _isDark ? AppTheme.dark : AppTheme.light;
}
