import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/memory_model.dart';

abstract class MemoriesLocalDataSource {
  Future<List<MemoryModel>> getCachedMemories();
  Future<void> cacheMemories(List<MemoryModel> memories);
}

class MemoriesLocalDataSourceImpl implements MemoriesLocalDataSource {
  final SharedPreferences prefs;
  static const _key = 'cached_memories';

  const MemoriesLocalDataSourceImpl(this.prefs);

  @override
  Future<List<MemoryModel>> getCachedMemories() async {
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final decoded = jsonDecode(jsonString) as List;
    return decoded
        .map((e) => MemoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheMemories(List<MemoryModel> memories) async {
    final encoded = jsonEncode(memories.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}