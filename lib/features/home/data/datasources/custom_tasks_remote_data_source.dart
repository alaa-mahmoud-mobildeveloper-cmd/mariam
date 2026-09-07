import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/custom_task_model.dart';

class CustomTasksRemoteDataSource {
  final FirebaseFirestore firestore;
  const CustomTasksRemoteDataSource(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('custom_tasks');

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Stream<List<CustomTaskModel>> watchTasksForDate(DateTime date) {
    return _collection
        .where('dateKey', isEqualTo: _dateKey(date))
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CustomTaskModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList());
  }

  Future<void> addTask(CustomTaskModel task) async {
    final docRef = _collection.doc();
    final data = task.toJson()
      ..['id'] = docRef.id
      ..['dateKey'] = _dateKey(task.date);
    await docRef.set(data);
  }

  Future<void> toggleTask(String id, bool completed) async {
    await _collection.doc(id).update({'completed': completed});
  }

  Future<void> deleteTask(String id) async {
    await _collection.doc(id).delete();
  }
}