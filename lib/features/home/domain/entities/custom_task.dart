enum TaskIcon { task, book, star, personal, prayer }

class CustomTask {
  final String id;
  final String title;
  final String category;
  final TaskIcon icon;
  final int hour;
  final int minute;
  final DateTime date; // اليوم اللي المهمة دي مخصصة له
  final bool completed;

  const CustomTask({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.hour,
    required this.minute,
    required this.date,
    this.completed = false,
  });

  CustomTask copyWith({bool? completed}) {
    return CustomTask(
      id: id,
      title: title,
      category: category,
      icon: icon,
      hour: hour,
      minute: minute,
      date: date,
      completed: completed ?? this.completed,
    );
  }
}
