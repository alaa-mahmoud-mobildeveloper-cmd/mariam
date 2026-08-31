import 'dart:io';

import '../entities/memory.dart';

abstract class MemoriesRepository {
  Future<List<Memory>> getMemories();
  Future<void> addMemory(Memory memory, {List<File> photos = const []});
}