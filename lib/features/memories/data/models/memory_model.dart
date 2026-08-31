import '../../domain/entities/memory.dart';

class MemoryModel extends Memory {
  const MemoryModel({
    required super.id,
    required super.title,
    required super.date,
    required super.description,
    required super.icon,
    super.photos,
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
      photos: (json['photos'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
      'icon': icon.name,
      'photos': photos,
    };
  }

  factory MemoryModel.fromEntity(Memory memory) {
    return MemoryModel(
      id: memory.id,
      title: memory.title,
      date: memory.date,
      description: memory.description,
      icon: memory.icon,
      photos: memory.photos,
    );
  }
}