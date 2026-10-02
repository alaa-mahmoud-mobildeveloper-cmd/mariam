import 'package:flutter/material.dart';

IconData _iconFromCodePoint(int? codePoint) {
  switch (codePoint) {
    case 0xe8b5:
      return Icons.wb_sunny_outlined;
    case 0xe3e7:
      return Icons.menu_book_rounded;
    case 0xe3f4:
      return Icons.mosque_outlined;
    case 0xe87d:
      return Icons.favorite_outline_rounded;
    default:
      return Icons.task_alt_rounded;
  }
}

class AppTask {
  final String id;
  final String title;
  final String category;
  final TimeOfDay time;
  final IconData icon;
  final bool completed;
  final DateTime date;

  const AppTask({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.icon,
    required this.completed,
    required this.date,
  });

  AppTask copyWith({
    String? title,
    String? category,
    TimeOfDay? time,
    IconData? icon,
    bool? completed,
    DateTime? date,
  }) => AppTask(
        id: id,
        title: title ?? this.title,
        category: category ?? this.category,
        time: time ?? this.time,
        icon: icon ?? this.icon,
        completed: completed ?? this.completed,
        date: date ?? this.date,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'hour': time.hour,
        'minute': time.minute,
        'icon': icon.codePoint,
        'fontFamily': icon.fontFamily,
        'completed': completed,
        'date': date.toIso8601String(),
      };

  factory AppTask.fromJson(Map<String, dynamic> json) => AppTask(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String? ?? 'شخصي',
        time: TimeOfDay(
          hour: (json['hour'] as num?)?.toInt() ?? 9,
          minute: (json['minute'] as num?)?.toInt() ?? 0,
        ),
        icon: _iconFromCodePoint((json['icon'] as num?)?.toInt()),
        completed: json['completed'] as bool? ?? false,
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      );

  String get formattedTime {
    final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute ${time.period == DayPeriod.am ? 'ص' : 'م'}';
  }
}
