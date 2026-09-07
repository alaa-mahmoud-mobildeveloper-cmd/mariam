import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mariam/core/theme/theme_provider.dart';
import 'package:mariam/features/home/data/datasources/custom_tasks_remote_data_source.dart';
import 'package:mariam/features/home/data/repositories/custom_tasks_repository_impl.dart';
import 'package:mariam/features/home/presentation/providers/custom_tasks_provider.dart';
import 'package:mariam/features/home/presentation/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:mariam/core/routes/route_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart'; // هيتولّد تلقائيًا من flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(
          create: (_) => CustomTasksProvider(
            CustomTasksRepositoryImpl(
              CustomTasksRemoteDataSource(FirebaseFirestore.instance),
            ),
          ),
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
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'مريم',
              builder: (context, widget) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: widget!,
                );
              },
              themeMode: themeProvider.themeMode,
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRoutes.generateRoute,
            );
          },
        );
      },
    );
  }
}