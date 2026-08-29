import 'package:flutter/material.dart';
import 'package:mariam/features/home/presentation/screens/tabs/home_tab.dart';
import 'package:mariam/features/home/presentation/screens/tabs/settings_tab.dart';
import 'package:mariam/features/home/presentation/screens/tabs/statistics_tab.dart';
import 'package:mariam/features/home/presentation/screens/tabs/tasks_tab.dart';
import 'package:mariam/features/home/presentation/screens/tabs/worship_tab.dart';
import 'package:mariam/features/home/presentation/widgets/home_bottom_navigation.dart';

// تأكد من استيراد الشاشات الأخرى لديك إذا لم تكن مستوردة
// import 'package:mariam/features/home/presentation/screens/tabs/tasks_tab.dart';
// import 'package:mariam/features/home/presentation/screens/tabs/worship_tab.dart';
// import 'package:mariam/features/home/presentation/screens/tabs/statistics_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final pages = [
    const HomeTab(),
    const TasksTab(),
    const WorshipTab(),
    const StatisticsTab(),
    const SettingsTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}