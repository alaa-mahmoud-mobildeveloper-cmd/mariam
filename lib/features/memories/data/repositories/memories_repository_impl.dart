import 'dart:io';

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
      return localDataSource.getCachedMemories();
    }
  }

  @override
  Future<void> addMemory(Memory memory, {List<File> photos = const []}) async {
    final model = MemoryModel.fromEntity(memory);
    await remoteDataSource.addMemory(model, photos: photos);

    final cached = await localDataSource.getCachedMemories();
    await localDataSource.cacheMemories([...cached, model]);
  }
}