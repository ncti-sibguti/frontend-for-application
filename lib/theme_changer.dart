import 'package:flutter/material.dart';
import 'package:ncti/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  static const _isDarkThemeKey = 'isDarkTheme';

  bool _isDark = false;

  ThemeModel() {
    debugPrint('я тут');
  }

  bool get isDark => _isDark;

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = !_isDark;
    prefs.setBool(_isDarkThemeKey, _isDark);
    debugPrint('записана $_isDark тема');
    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_isDarkThemeKey) ?? false;
    _isDark = isDark;
    debugPrint('получена $_isDark тема');
    notifyListeners();
  }

  ThemeData get currentTheme => _isDark ? AppTheme.dark : AppTheme.light;
}
