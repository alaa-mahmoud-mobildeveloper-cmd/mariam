import 'package:flutter/material.dart';
import 'app_colors.dart'; // تأكد من وضع ملف الألوان في نفس المسار

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      scaffoldBackgroundColor: AppCustomColors.darkBackground,
      fontFamily: 'Cairo',

    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      scaffoldBackgroundColor: AppCustomColors.lightBackground,
      fontFamily: 'Cairo',

    );
  }
}