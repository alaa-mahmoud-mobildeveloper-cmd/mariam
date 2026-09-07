import 'package:flutter/material.dart';

enum TaskStatus {
  pending,
  completed,
  missed,
}

class DailyTask {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final bool isReligious;
  final DateTime date;

  TimeOfDay time;
  bool completed;

  DailyTask({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.isReligious,
    required this.time,
    required this.date,
    this.completed = false,
  });

  String get formattedTime {
    final hour24 = time.hour;
    final isAm = hour24 < 12;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = time.minute.toString().padLeft(2, '0');

    return '${hour12.toString().padLeft(2, '0')}:$minute ${isAm ? 'ص' : 'م'}';
  }

  bool get isToday {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  TaskStatus get status {
    if (completed) {
      return TaskStatus.completed;
    }

    // المهمة الخاصة بيوم قادم لم تفُت بعد.
    if (!isToday) {
      return TaskStatus.pending;
    }

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final taskMinutes = time.hour * 60 + time.minute;

    if (nowMinutes > taskMinutes) {
      return TaskStatus.missed;
    }

    return TaskStatus.pending;
  }

  DailyTask copyWith({
    String? id,
    String? title,
    String? category,
    IconData? icon,
    bool? isReligious,
    DateTime? date,
    TimeOfDay? time,
    bool? completed,
  }) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isReligious: isReligious ?? this.isReligious,
      date: date ?? this.date,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }
}
