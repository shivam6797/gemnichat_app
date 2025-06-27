import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String isFirstTimeKey = 'isFirstTime';
  static const String themeModeKey = 'themeMode'; // 🔑 theme key

  // Existing
  static Future<void> setFirstTime(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstTimeKey, isFirst);
  }

  static Future<bool> getIsFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstTimeKey) ?? true;
  }

  // 🔥 New for Theme
  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeModeKey, mode.name); // saves "light", "dark", "system"
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(themeModeKey);

    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
