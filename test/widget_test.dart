import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mariam/features/tasks/domain/entities/task.dart';

void main() {
  test('AppTask serializes and restores its data', () {
    final original = AppTask(
      id: 'task-1',
      title: 'قراءة القرآن',
      category: 'قرآن',
      time: const TimeOfDay(hour: 7, minute: 30),
      icon: Icons.menu_book_rounded,
      completed: true,
      date: DateTime(2026, 10, 2),
    );

    final restored = AppTask.fromJson(original.toJson());
    expect(restored.id, original.id);
    expect(restored.title, original.title);
    expect(restored.category, original.category);
    expect(restored.time, original.time);
    expect(restored.completed, isTrue);
  });
}
