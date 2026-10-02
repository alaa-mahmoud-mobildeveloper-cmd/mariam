import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mariam/features/notifications/domain/entities/app_notification.dart';
import 'package:mariam/features/tasks/domain/entities/task.dart';

class NotificationsProvider extends ChangeNotifier {
  static const _storageKey = 'app_notifications';

  final SharedPreferences prefs;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  NotificationsProvider(this.prefs);

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((item) => !item.isRead).length;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _notifications = decoded
            .map((item) => AppNotification.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (_) {
        _notifications = [];
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> syncWithTasks(List<AppTask> tasks) async {
    var changed = false;
    final existingIds = _notifications.map((item) => item.id).toSet();
    final today = DateTime.now();
    for (final task in tasks) {
      final isToday = task.date.year == today.year && task.date.month == today.month && task.date.day == today.day;
      if (!isToday) continue;
      final reminderId = 'task-reminder-${task.id}';
      if (!task.completed && !existingIds.contains(reminderId)) {
        _notifications.add(AppNotification(
          id: reminderId,
          title: 'تذكير بمهمة اليوم',
          body: 'لديك مهمة غير مكتملة: ${task.title}',
          type: 'task',
          createdAt: DateTime.now(),
        ));
        changed = true;
      }
      final completedId = 'task-completed-${task.id}';
      if (task.completed && !existingIds.contains(completedId)) {
        _notifications.add(AppNotification(
          id: completedId,
          title: 'أحسنتِ يا مريم',
          body: 'تم إنجاز مهمة: ${task.title}',
          type: 'success',
          createdAt: DateTime.now(),
        ));
        changed = true;
      }
    }
    if (changed) {
      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (_notifications.length > 50) {
        _notifications = _notifications.take(50).toList();
      }
      await _save();
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index == -1 || _notifications[index].isRead) return;
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    await _save();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;
    _notifications = _notifications.map((item) => item.copyWith(isRead: true)).toList();
    await _save();
    notifyListeners();
  }

  Future<void> clear() async {
    _notifications = [];
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await prefs.setString(_storageKey, jsonEncode(_notifications.map((item) => item.toJson()).toList()));
  }
}
