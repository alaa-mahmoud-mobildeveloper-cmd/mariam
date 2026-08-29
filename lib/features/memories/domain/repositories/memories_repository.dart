

import 'package:mariam/features/memories/domain/entities/memory.dart';

/// عقد مجرد (Interface) - طبقة الـ domain متعرفش تفاصيل التخزين
/// (local storage / API / إلخ)، بس بتعرف "إيه العمليات المتاحة".
abstract class MemoriesRepository {
  Future<List<Memory>> getMemories();
  Future<void> addMemory(Memory memory);
}