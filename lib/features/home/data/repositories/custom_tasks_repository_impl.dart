import '../../domain/entities/custom_task.dart';
import '../../domain/repositories/custom_tasks_repository.dart';
import '../datasources/custom_tasks_remote_data_source.dart';
import '../models/custom_task_model.dart';

class CustomTasksRepositoryImpl implements CustomTasksRepository {
  final CustomTasksRemoteDataSource remoteDataSource;
  const CustomTasksRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<CustomTask>> watchTasksForDate(DateTime date) {
    return remoteDataSource.watchTasksForDate(date);
  }

  @override
  Future<void> addTask(CustomTask task) {
    return remoteDataSource.addTask(CustomTaskModel(
      id: task.id,
      title: task.title,
      category: task.category,
      icon: task.icon,
      hour: task.hour,
      minute: task.minute,
      date: task.date,
      completed: task.completed,
    ));
  }

  @override
  Future<void> toggleTask(String id, bool completed) {
    return remoteDataSource.toggleTask(id, completed);
  }

  @override
  Future<void> deleteTask(String id) {
    return remoteDataSource.deleteTask(id);
  }
}