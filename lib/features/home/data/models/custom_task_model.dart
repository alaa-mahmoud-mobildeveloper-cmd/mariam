import '../../domain/entities/custom_task.dart';

class CustomTaskModel extends CustomTask {
  const CustomTaskModel({
    required super.id,
    required super.title,
    required super.category,
    required super.icon,
    required super.hour,
    required super.minute,
    required super.date,
    super.completed,
  });

  factory CustomTaskModel.fromJson(Map<String, dynamic> json) {
    return CustomTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      icon: TaskIcon.values.firstWhere(
            (e) => e.name == json['icon'],
        orElse: () => TaskIcon.task,
      ),
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      date: DateTime.parse(json['date'] as String),
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'icon': icon.name,
      'hour': hour,
      'minute': minute,
      'date': _dateOnly(date).toIso8601String(),
      'completed': completed,
    };
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}