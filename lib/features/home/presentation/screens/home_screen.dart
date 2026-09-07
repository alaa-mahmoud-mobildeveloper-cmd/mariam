import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mariam/features/home/data/datasources/home_remote_data_source.dart';
import 'package:mariam/features/home/data/repositories/home_repository_impl.dart';
import 'package:mariam/features/home/presentation/providers/home_provider.dart';
import 'package:mariam/features/home/presentation/screens/tabs/home_tab.dart';
import 'package:mariam/features/home/presentation/screens/tabs/settings_tab.dart';
import 'package:mariam/features/home/presentation/screens/tabs/tasks_tab.dart';
import 'package:mariam/features/home/presentation/screens/tabs/worship_tab.dart';
import 'package:mariam/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:mariam/features/memories/presentation/screens/memories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    final repository = HomeRepositoryImpl(
      remoteDataSource: HomeRemoteDataSourceImpl(dio),
    );

    final homeProvider = HomeProvider(
      repository: repository,
    );

    pages = [
      ChangeNotifierProvider<HomeProvider>.value(
        value: homeProvider,
        child: const HomeTab(),
      ),
      const TasksTab(),
      const WorshipTab(),
      const MemoriesScreen(),
      const SettingsTab(),
    ];

    homeProvider.loadHomeData(
      latitude: 30.0444,
      longitude: 31.2357,
    );
  }

  @override
  void dispose() {
    final provider = pages.first;
    if (provider is ChangeNotifierProvider<HomeProvider>) {
      // لا نعتمد على هذا الأسلوب للتخلص من الـProvider.
      // الأفضل ترك الـProvider يُدار بواسطة create.
    }
    super.dispose();
  }

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
