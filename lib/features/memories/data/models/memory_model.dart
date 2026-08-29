import '../../domain/entities/memory.dart';

/// الموديل بيرث من الـ entity ويضيف تفاصيل التحويل من/إلى JSON،
/// عشان الـ domain يفضل نضيف من تفاصيل التخزين.
class MemoryModel extends Memory {
  const MemoryModel({
    required super.id,
    required super.title,
    required super.date,
    required super.description,
    required super.icon,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      icon: MemoryIcon.values.firstWhere(
            (e) => e.name == json['icon'],
        orElse: () => MemoryIcon.heart,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
      'icon': icon.name,
    };
  }

  factory MemoryModel.fromEntity(Memory memory) {
    return MemoryModel(
      id: memory.id,
      title: memory.title,
      date: memory.date,
      description: memory.description,
      icon: memory.icon,
    );
  }
}