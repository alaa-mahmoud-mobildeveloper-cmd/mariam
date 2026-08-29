import 'package:flutter/material.dart';
// تأكد من تعديل المسار حسب مكان ملف الألوان لديك
import 'app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners();
  }

  // الثيمات الجاهزة للاستخدام في MaterialApp (theme & darkTheme)
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppCustomColors.lightBackground,
    fontFamily: 'Cairo',
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    scaffoldBackgroundColor: AppCustomColors.darkBackground,
    fontFamily: 'Cairo',
  );

  // الألوان الخاصة بالتطبيقات والعناصر بناءً على الألوان الجديدة
  Color get backgroundColor =>
      _isDarkMode ? AppCustomColors.darkBackground : AppCustomColors.lightBackground;

  Color get cardColor =>
      _isDarkMode ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;

  Color get primaryText =>
      _isDarkMode ? AppColors.darkColorScheme.onSurface : AppColors.lightColorScheme.onSurface;

  Color get secondaryText =>
      _isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

  Color get dividerColor =>
      _isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;

  Color get cardBorderColor =>
      _isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
}