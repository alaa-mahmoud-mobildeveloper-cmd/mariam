import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/task.dart';

class TasksProvider extends ChangeNotifier {
  static const _storageKey = 'app_tasks';
  final SharedPreferences prefs;

  TasksProvider(this.prefs);

  List<AppTask> _tasks = [];
  bool isLoading = false;
  String? errorMessage;

  List<AppTask> get tasks => List.unmodifiable(_tasks);
  int get completedCount => _tasks.where((task) => task.completed).length;
  int get totalCount => _tasks.length;
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();
    try {
      final raw = prefs.getString(_storageKey);
      if (raw == null) {
        _tasks = _defaultTasks();
        await _persist();
      } else {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _tasks = decoded
            .map((item) => AppTask.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
      errorMessage = null;
    } catch (_) {
      errorMessage = 'تعذر تحميل المهام';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask({
    required String title,
    required String category,
    required TimeOfDay time,
    required IconData icon,
    DateTime? date,
  }) async {
    _tasks = [
      ..._tasks,
      AppTask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        category: category,
        time: time,
        icon: icon,
        completed: false,
        date: date ?? DateTime.now(),
      ),
    ];
    await _persist();
    notifyListeners();
  }

  Future<void> toggleTask(String id) async {
    _tasks = _tasks
        .map((task) => task.id == id ? task.copyWith(completed: !task.completed) : task)
        .toList();
    await _persist();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    _tasks = _tasks.where((task) => task.id != id).toList();
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() => prefs.setString(
        _storageKey,
        jsonEncode(_tasks.map((task) => task.toJson()).toList()),
      );

  List<AppTask> _defaultTasks() {
    final today = DateTime.now();
    return [
      AppTask(id: 'default-1', title: 'أذكار الصباح', category: 'عبادات', time: const TimeOfDay(hour: 7, minute: 0), icon: Icons.wb_sunny_outlined, completed: false, date: today),
      AppTask(id: 'default-2', title: 'قراءة ورد القرآن', category: 'قرآن', time: const TimeOfDay(hour: 9, minute: 0), icon: Icons.menu_book_rounded, completed: false, date: today),
      AppTask(id: 'default-3', title: 'مراجعة المهام اليومية', category: 'شخصي', time: const TimeOfDay(hour: 11, minute: 0), icon: Icons.edit_note_rounded, completed: false, date: today),
    ];
  }
}
