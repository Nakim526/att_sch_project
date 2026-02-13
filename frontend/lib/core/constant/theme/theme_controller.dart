import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void setLight() async {
    _themeMode = ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', 'light');
    notifyListeners();
  }

  void setDark() async {
    _themeMode = ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', 'dark');
    notifyListeners();
  }

  void setSystem() async {
    _themeMode = ThemeMode.system;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', 'system');
    notifyListeners();
  }

  void toggle() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
