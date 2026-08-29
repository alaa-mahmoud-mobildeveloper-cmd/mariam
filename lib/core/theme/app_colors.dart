import 'package:flutter/material.dart';

class AppColors {
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF66B2),
    onPrimary: Colors.white,
    secondary: Color(0xFFFF80BF),
    onSecondary: Colors.white,
    surface: Color(0xFF191322),
    onSurface: Color(0xFFF7D1E3),
    error: Color(0xFFCF6679),
    onError: Colors.black,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFD91A72),
    onPrimary: Colors.white,
    secondary: Color(0xFFFF66B2),
    onSecondary: Colors.black,
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF191322),
    error: Color(0xFFB00020),
    onError: Colors.white,
  );
}

class AppCustomColors {
  static const Color darkBackground = Color(0xFF0D0B12);
  static const Color darkCardBg = Color(0xFF191322);
  static const Color darkBorder = Color(0xFF2D2038);
  static const Color darkTextMuted = Color(0xFFA292A6);

  static const Color lightBackground = Color(0xFFF9F6FB);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5D9ED);
  static const Color lightTextMuted = Color(0xFF7A6B82);
}