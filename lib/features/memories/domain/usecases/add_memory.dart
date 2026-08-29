import '../entities/memory.dart';
import '../repositories/memories_repository.dart';

class AddMemory {
  final MemoriesRepository repository;

  const AddMemory(this.repository);

  Future<void> call(Memory memory) => repository.addMemory(memory);
}