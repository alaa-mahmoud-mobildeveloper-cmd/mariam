import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routes/route_app.dart';
import 'core/theme/theme_provider.dart';
import 'features/tasks/presentation/providers/tasks_provider.dart';
import 'features/notifications/presentation/providers/notifications_provider.dart';
import 'core/notifications/local_notification_service.dart';
import 'features/prayer_times/data/prayer_times_service.dart';
import 'features/prayer_times/presentation/providers/prayer_times_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  final localNotifications = LocalNotificationService();
  await localNotifications.initialize();
  await localNotifications.requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)..load()),
        ChangeNotifierProvider(create: (_) => TasksProvider(prefs)..loadTasks()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider(prefs)..load()),
        ChangeNotifierProvider(
          create: (_) => PrayerTimesProvider(
            PrayerTimesService(prefs),
            notifications: localNotifications,
          )..load(),
        ),
        Provider<SharedPreferences>.value(value: prefs),
      ],
      child: const MaryamApp(),
    ),
  );
}

class MaryamApp extends StatelessWidget {
  const MaryamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'مريم',
            builder: (context, widget) => Directionality(
              textDirection: TextDirection.rtl,
              child: widget ?? const SizedBox.shrink(),
            ),
            themeMode: themeProvider.themeMode,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          ),
        );
      },
    );
  }
}
