import 'package:mariam/features/home/domain/entities/custom_task.dart';


abstract class CustomTasksRepository {
  Stream<List<CustomTask>> watchTasksForDate(DateTime date);
  Future<void> addTask(CustomTask task);
  Future<void> toggleTask(String id, bool completed);
  Future<void> deleteTask(String id);
}