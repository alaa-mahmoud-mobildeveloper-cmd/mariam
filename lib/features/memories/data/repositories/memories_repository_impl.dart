import '../../domain/entities/memory.dart';
import '../../domain/repositories/memories_repository.dart';
import '../datasources/memories_local_data_source.dart';
import '../datasources/memories_remote_data_source.dart';
import '../models/memory_model.dart';

class MemoriesRepositoryImpl implements MemoriesRepository {
  final MemoriesRemoteDataSource remoteDataSource;
  final MemoriesLocalDataSource localDataSource;

  const MemoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Memory>> getMemories() async {
    try {
      final remoteMemories = await remoteDataSource.getMemories();
      await localDataSource.cacheMemories(remoteMemories);
      return remoteMemories;
    } catch (_) {
      // مفيش نت أو حصل خطأ في Firestore -> ارجع للنسخة المحفوظة محليًا
      return localDataSource.getCachedMemories();
    }
  }

  @override
  Future<void> addMemory(Memory memory) async {
    final model = MemoryModel.fromEntity(memory);

    // يتضاف على Firestore أولًا (مصدر الحقيقة)
    await remoteDataSource.addMemory(model);

    // وبعدين يتحدّث الكاش المحلي عشان يفضل متزامن
    final cached = await localDataSource.getCachedMemories();
    await localDataSource.cacheMemories([...cached, model]);
  }
}