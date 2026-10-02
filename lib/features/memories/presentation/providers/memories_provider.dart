import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/memory.dart';
import '../../domain/usecases/add_memory.dart';
import '../../domain/usecases/get_memories.dart';
import '../../domain/repositories/memories_repository.dart';

class MemoriesProvider extends ChangeNotifier {
  final GetMemories _getMemories;
  final AddMemory _addMemory;
  final MemoriesRepository _repository;

  MemoriesProvider({required GetMemories getMemories, required AddMemory addMemoryUseCase, required MemoriesRepository repository})
      : _getMemories = getMemories,
        _addMemory = addMemoryUseCase,
        _repository = repository;

  MemoriesStatus status = MemoriesStatus.initial;
  List<Memory> memories = [];
  String? errorMessage;
  bool isSaving = false;
  bool isDeleting = false;

  Future<void> loadMemories() async {
    status = MemoriesStatus.loading;
    notifyListeners();
    try {
      memories = await _getMemories();
      status = MemoriesStatus.loaded;
      errorMessage = null;
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

  Future<bool> deleteMemory(String id) async {
    isDeleting = true;
    notifyListeners();
    try {
      await _repository.deleteMemory(id);
      memories = memories.where((memory) => memory.id != id).toList();
      return true;
    } catch (_) {
      errorMessage = 'حدث خطأ أثناء حذف الذكرى';
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }
}

enum MemoriesStatus { initial, loading, loaded, error }
