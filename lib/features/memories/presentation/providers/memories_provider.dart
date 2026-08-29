import 'package:flutter/material.dart';

import '../../domain/entities/memory.dart';
import '../../domain/usecases/add_memory.dart';
import '../../domain/usecases/get_memories.dart';

enum MemoriesStatus { initial, loading, loaded, error }

class MemoriesProvider extends ChangeNotifier {
  final GetMemories _getMemories;
  final AddMemory _addMemory;

  MemoriesProvider({
    required GetMemories getMemories,
    required AddMemory addMemoryUseCase,
  })  : _getMemories = getMemories,
        _addMemory = addMemoryUseCase;

  MemoriesStatus status = MemoriesStatus.initial;
  List<Memory> memories = [];
  String? errorMessage;

  Future<void> loadMemories() async {
    status = MemoriesStatus.loading;
    notifyListeners();

    try {
      memories = await _getMemories();
      status = MemoriesStatus.loaded;
    } catch (_) {
      errorMessage = 'حدث خطأ أثناء تحميل الذكريات';
      status = MemoriesStatus.error;
    }
    notifyListeners();
  }

  Future<void> addMemory(Memory memory) async {
    try {
      await _addMemory(memory);
      await loadMemories();
    } catch (_) {
      errorMessage = 'حدث خطأ أثناء إضافة الذكرى';
      notifyListeners();
    }
  }
}