import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  static const _darkModeKey = 'dark_mode';
  final SharedPreferences prefs;
  bool _isDarkMode = true;

  ThemeProvider(this.prefs);

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void load() {
    _isDarkMode = prefs.getBool(_darkModeKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    await prefs.setBool(_darkModeKey, isOn);
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: AppColors.lightColorScheme,
        scaffoldBackgroundColor: AppCustomColors.lightBackground,
        fontFamily: 'Cairo',
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: AppColors.darkColorScheme,
        scaffoldBackgroundColor: AppCustomColors.darkBackground,
        fontFamily: 'Cairo',
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      );

  Color get backgroundColor => _isDarkMode ? AppCustomColors.darkBackground : AppCustomColors.lightBackground;
  Color get cardColor => _isDarkMode ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
  Color get primaryText => _isDarkMode ? AppColors.darkColorScheme.onSurface : AppColors.lightColorScheme.onSurface;
  Color get secondaryText => _isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;
  Color get dividerColor => _isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
  Color get cardBorderColor => _isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
}
