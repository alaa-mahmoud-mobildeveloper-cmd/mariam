import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/prayer_times/domain/entities/prayer_times.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await plugin.initialize(InitializationSettings(android: android, iOS: ios));
  }

  Future<bool> requestPermissions() async {
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidGranted =
        await android?.requestNotificationsPermission() ?? true;
    final ios = plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted =
        await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;
    return androidGranted && iosGranted;
  }

  Future<void> showTestNotification() async {
    await plugin.show(
      9000,
      'مريم',
      'الإشعارات تعمل بنجاح',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'mariam_general',
          'إشعارات مريم',
          channelDescription: 'التنبيهات العامة للتطبيق',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> schedulePrayerNotifications(PrayerTimes prayerTimes) async {
    try {
      tz.setLocalLocation(tz.getLocation(prayerTimes.timezone));
    } catch (_) {
      // إذا لم تكن المنطقة معروفة نستخدم المنطقة الافتراضية.
    }
    await cancelPrayerNotifications();
    final today = DateTime.now();
    for (var index = 0; index < prayerTimes.prayers.length; index++) {
      final prayer = prayerTimes.prayers[index];
      final parts = prayer.time.split(':');
      if (parts.length != 2) continue;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) continue;
      final scheduled = tz.TZDateTime(
        tz.local,
        today.year,
        today.month,
        today.day,
        hour,
        minute,
      ).subtract(const Duration(minutes: 10));
      if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) continue;
      await plugin.zonedSchedule(
        9100 + index,
        'اقترب موعد الصلاة',
        'باقي 10 دقائق على صلاة ${prayer.arabicName}',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mariam_general',
            'إشعارات مريم',
            channelDescription: 'التنبيهات العامة للتطبيق',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelPrayerNotifications() async {
    for (var id = 9100; id < 9120; id++) {
      await plugin.cancel(id);
    }
  }
}
