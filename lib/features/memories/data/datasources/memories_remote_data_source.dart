import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/memory_model.dart';

abstract class MemoriesRemoteDataSource {
  Future<List<MemoryModel>> getMemories();
  Future<void> addMemory(MemoryModel memory);
}

class MemoriesRemoteDataSourceImpl implements MemoriesRemoteDataSource {
  final FirebaseFirestore firestore;

  const MemoriesRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('memories');

  @override
  Future<List<MemoryModel>> getMemories() async {
    final snapshot = await _collection.orderBy('date').get();
    return snapshot.docs
        .map((doc) => MemoryModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<void> addMemory(MemoryModel memory) async {
    // لو الـ id فاضي، خلي Firestore يولّد id تلقائي
    final docRef = memory.id.isEmpty
        ? _collection.doc()
        : _collection.doc(memory.id);

    final data = memory.toJson()..['id'] = docRef.id;
    await docRef.set(data);
  }
}