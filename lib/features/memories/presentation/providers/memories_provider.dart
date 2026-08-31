import 'dart:io';

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
  bool isSaving = false;

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

  Future<bool> addMemory(Memory memory, {List<File> photos = const []}) async {
    isSaving = true;
    notifyListeners();

    try {
      await _addMemory(memory, photos: photos);
      await loadMemories();
      return true;
    } catch (_) {
      errorMessage = 'حدث خطأ أثناء إضافة الذكرى';
      notifyListeners();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}