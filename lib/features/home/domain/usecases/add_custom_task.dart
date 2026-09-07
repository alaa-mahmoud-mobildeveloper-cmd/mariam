import '../entities/custom_task.dart';
import '../repositories/custom_tasks_repository.dart';

class AddCustomTask {
  final CustomTasksRepository repository;
  const AddCustomTask(this.repository);

  Future<void> call(CustomTask task) => repository.addTask(task);
}