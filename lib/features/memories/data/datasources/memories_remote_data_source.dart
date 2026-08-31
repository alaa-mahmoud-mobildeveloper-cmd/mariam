import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../models/memory_model.dart';

abstract class MemoriesRemoteDataSource {
  Future<List<MemoryModel>> getMemories();
  Future<void> addMemory(MemoryModel memory, {List<File> photos});
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

  /// بيضغط الصورة ويحولها Base64. بيرجع null لو الصورة كبيرة جدًا حتى بعد الضغط.
  Future<String?> _compressAndEncode(File file) async {
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 55,
      minWidth: 900,
      minHeight: 900,
    );

    if (compressedBytes == null) return null;

    // حد أمان: لو الصورة المضغوطة لسه أكبر من 600KB، ارفضها
    // (Firestore حده 1MB للـ document كله، وممكن يبقى فيه أكتر من صورة)
    if (compressedBytes.lengthInBytes > 600 * 1024) return null;

    return base64Encode(compressedBytes);
  }

  Future<List<String>> _encodePhotos(List<File> photos) async {
    final results = <String>[];
    for (final file in photos) {
      final encoded = await _compressAndEncode(file);
      if (encoded != null) results.add(encoded);
    }
    return results;
  }

  @override
  Future<void> addMemory(MemoryModel memory, {List<File> photos = const []}) async {
    final docRef = memory.id.isEmpty ? _collection.doc() : _collection.doc(memory.id);

    final encodedPhotos = photos.isEmpty ? <String>[] : await _encodePhotos(photos);

    final data = memory.toJson()
      ..['id'] = docRef.id
      ..['photos'] = encodedPhotos;

    await docRef.set(data);
  }
}