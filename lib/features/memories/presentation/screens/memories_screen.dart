import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mariam/core/theme/theme_provider.dart';
import '../../data/datasources/memories_local_data_source.dart';
import '../../data/datasources/memories_remote_data_source.dart';
import '../../data/repositories/memories_repository_impl.dart';
import '../../domain/usecases/add_memory.dart';
import '../../domain/usecases/get_memories.dart';
import '../providers/memories_provider.dart';
import '../widgets/memories_app_bar.dart';
import '../widgets/memories_list.dart';
import 'add_memory_screen.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemoriesProvider>(
      create: (context) {
        final prefs = context.read<SharedPreferences>();
        final repository = MemoriesRepositoryImpl(
          remoteDataSource: MemoriesRemoteDataSourceImpl(FirebaseFirestore.instance),
          localDataSource: MemoriesLocalDataSourceImpl(prefs),
        );
        return MemoriesProvider(
          getMemories: GetMemories(repository),
          addMemoryUseCase: AddMemory(repository),
          repository: repository,
        )..loadMemories();
      },
      child: const _MemoriesView(),
    );
  }
}

class _MemoriesView extends StatelessWidget {
  const _MemoriesView();

  void _onAdd(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeNotifierProvider.value(value: context.read<MemoriesProvider>(), child: const AddMemoryScreen())));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final primary = themeProvider.isDarkMode ? const Color(0xFFFFB6D9) : const Color(0xFFFF80BF);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: const MemoriesAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'memories_fab',
        backgroundColor: primary,
        onPressed: () => _onAdd(context),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('ذكرى جديدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      body: SafeArea(child: MemoriesList(onAdd: () => _onAdd(context))),
    );
  }
}
