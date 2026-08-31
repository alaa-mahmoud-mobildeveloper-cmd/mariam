import 'dart:io';

import '../entities/memory.dart';
import '../repositories/memories_repository.dart';

class AddMemory {
  final MemoriesRepository repository;

  const AddMemory(this.repository);

  Future<void> call(Memory memory, {List<File> photos = const []}) {
    return repository.addMemory(memory, photos: photos);
  }
}