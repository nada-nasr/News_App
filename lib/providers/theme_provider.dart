import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String themeKey = 'app_theme';
  ThemeMode currentTheme = ThemeMode.dark;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final themeString = await getTheme();
    if (themeString == 'dark') {
      currentTheme = ThemeMode.dark;
    } else {
      currentTheme = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(themeKey);
  }

  void changeTheme(ThemeMode newTheme) async {
    if (currentTheme == newTheme) {
      return;
    }
    currentTheme = newTheme;
    notifyListeners();
    await saveTheme(newTheme);
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString = themeMode == ThemeMode.dark ? 'dark' : 'light';
    await prefs.setString(themeKey, themeString);
  }

  bool isDarkMode() {
    return currentTheme == ThemeMode.dark;
  }
}
