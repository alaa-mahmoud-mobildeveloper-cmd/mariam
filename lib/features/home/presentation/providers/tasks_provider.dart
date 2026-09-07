import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mariam/features/home/data/models/daily_task.dart';

class TasksProvider extends ChangeNotifier {
  TasksProvider() {
    // تحديث الواجهة كل دقيقة حتى تتغير حالة المهام الفائتة تلقائيًا.
    _tickTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) => notifyListeners(),
    );
  }

  final List<DailyTask> _tasks = [
    DailyTask(
      id: 'morning_adhkar',
      title: 'أذكار الصباح',
      category: 'عبادات',
      icon: Icons.wb_sunny_outlined,
      isReligious: true,
      time: const TimeOfDay(hour: 7, minute: 0),
      date: _today(),
    ),
    DailyTask(
      id: 'quran_wird',
      title: 'قراءة ورد القرآن',
      category: 'قرآن',
      icon: Icons.menu_book_rounded,
      isReligious: true,
      time: const TimeOfDay(hour: 9, minute: 0),
      date: _today(),
    ),
    DailyTask(
      id: 'daily_review',
      title: 'مراجعة المهام اليومية',
      category: 'شخصي',
      icon: Icons.edit_note_rounded,
      isReligious: false,
      time: const TimeOfDay(hour: 11, minute: 0),
      date: _today(),
    ),
    DailyTask(
      id: 'duha_prayer',
      title: 'صلاة الضحى',
      category: 'عبادات',
      icon: Icons.mosque_outlined,
      isReligious: true,
      time: const TimeOfDay(hour: 12, minute: 30),
      date: _today(),
    ),
    DailyTask(
      id: 'kahf_surah',
      title: 'قراءة سورة الكهف',
      category: 'قرآن',
      icon: Icons.auto_stories_outlined,
      isReligious: true,
      time: const TimeOfDay(hour: 16, minute: 0),
      date: _today(),
    ),
  ];

  DateTime _lastResetDate = _today();
  Timer? _tickTimer;

  // نحفظ التاريخ بدون الساعة حتى تكون المقارنة حسب اليوم فقط.
  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _resetIfNewDay() {
    final today = _today();

    if (_isSameDay(today, _lastResetDate)) return;

    for (final task in _tasks) {
      task.completed = false;
    }

    _lastResetDate = today;
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  List<DailyTask> get tasks {
    _resetIfNewDay();
    return List.unmodifiable(_tasks);
  }

  List<DailyTask> get visibleTasks {
    _resetIfNewDay();
    return _tasks.where((task) => !task.completed).toList();
  }

  /// المهام غير المكتملة ولم يحن وقتها بعد.
  List<DailyTask> get pendingTasks {
    _resetIfNewDay();
    return _tasks
        .where((task) => task.status == TaskStatus.pending)
        .toList();
  }

  /// المهام المكتملة فقط.
  List<DailyTask> get completedTasks {
    _resetIfNewDay();
    return _tasks.where((task) => task.completed).toList();
  }

  int get completedCount {
    _resetIfNewDay();
    return _tasks.where((task) => task.completed).length;
  }

  int get totalCount => _tasks.length;

  double get progress {
    final total = totalCount;
    return total == 0 ? 0 : completedCount / total;
  }

  void toggleTask(String id) {
    _resetIfNewDay();

    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final task = _tasks[index];

    // لا يمكن إكمال مهمة فات وقتها حسب منطق التطبيق الحالي.
    if (task.status == TaskStatus.missed) return;

    task.completed = !task.completed;
    notifyListeners();
  }

  void updateTaskTime(String id, TimeOfDay newTime) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    _tasks[index].time = newTime;
    notifyListeners();
  }
}
