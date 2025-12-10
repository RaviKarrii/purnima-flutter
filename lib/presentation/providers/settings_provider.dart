import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_strings.dart';

class SettingsProvider with ChangeNotifier {
  String _language = 'en';

  ThemeMode _themeMode = ThemeMode.light;

  String get language => _language;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'en';
    
    final themeString = prefs.getString('themeMode') ?? 'light';
    switch (themeString) {
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
    }
    
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (mode) {
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
      default:
        themeString = 'light';
    }
    await prefs.setString('themeMode', themeString);
    notifyListeners();
  }

  String getString(String key) {
    return AppStrings.get(key, _language);
  }
}
