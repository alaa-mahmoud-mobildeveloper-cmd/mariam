import 'dart:async';
import 'package:flutter/material.dart';

import '../../domain/entities/custom_task.dart';
import '../../domain/repositories/custom_tasks_repository.dart';

class CustomTasksProvider extends ChangeNotifier {
  final CustomTasksRepository repository;

  CustomTasksProvider(this.repository) {
    _subscribe();
  }

  List<CustomTask> tasks = [];
  bool isLoading = true;
  StreamSubscription<List<CustomTask>>? _sub;

  void _subscribe() {
    final today = DateTime.now();
    _sub = repository.watchTasksForDate(today).listen((data) {
      tasks = data;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addTask(CustomTask task) => repository.addTask(task);

  Future<void> toggleTask(String id, bool completed) =>
      repository.toggleTask(id, completed);

  Future<void> deleteTask(String id) => repository.deleteTask(id);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}