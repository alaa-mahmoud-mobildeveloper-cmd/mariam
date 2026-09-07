import '../entities/custom_task.dart';
import '../repositories/custom_tasks_repository.dart';

class GetTasksStream {
  final CustomTasksRepository repository;
  const GetTasksStream(this.repository);

  Stream<List<CustomTask>> call(DateTime date) => repository.watchTasksForDate(date);
}