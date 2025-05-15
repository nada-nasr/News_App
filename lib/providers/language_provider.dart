import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  // Data
  String currentLocal = 'en';
  static const String languageKey = 'app_language';

  LanguageProvider() {
    loadLanguage();
  }

  void changeLanguage(String newLocal) {
    if (currentLocal == newLocal) {
      return;
    }
    currentLocal = newLocal;
    saveLanguage(newLocal);
    notifyListeners();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(languageKey);
    if (savedLanguage != null) {
      currentLocal = savedLanguage;
    }
    notifyListeners();
  }

  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, languageCode);
  }

  Locale get currentLocale {
    return Locale(currentLocal);
  }
}