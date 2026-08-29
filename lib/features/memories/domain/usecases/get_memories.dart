import '../entities/memory.dart';
import '../repositories/memories_repository.dart';

/// Use case بيمثل حالة استخدام واحدة بس: "هات كل الذكريات".
class GetMemories {
  final MemoriesRepository repository;

  const GetMemories(this.repository);

  Future<List<Memory>> call() => repository.getMemories();
}