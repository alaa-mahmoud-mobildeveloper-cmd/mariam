import 'package:flutter/material.dart';
import 'package:mariam/features/home/presentation/screens/home_screen.dart';
import 'package:mariam/features/splash/presentation/screens/splash_screen.dart';
import 'package:mariam/features/gift/presentation/screens/gift_welcome_screen.dart';

import '../../features/memories/presentation/screens/memories_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String gift= '/gift';
  static const String memories = '/memories';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case memories:
        return MaterialPageRoute(
          builder: (_) => const MemoriesScreen(),
        );
      case gift:
        return MaterialPageRoute(
          builder: (_) => const GiftWelcomeScreen(recipientName: 'Mariam Ahmed'),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('لا يوجد مسار مطبق لـ ${settings.name}'),
            ),
          ),
        );
    }
  }
}
