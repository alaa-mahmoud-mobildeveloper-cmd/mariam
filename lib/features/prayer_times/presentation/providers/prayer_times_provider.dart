import 'package:flutter/foundation.dart';

import '../../data/prayer_times_service.dart';
import '../../domain/entities/prayer_times.dart';
import '../../../../core/notifications/local_notification_service.dart';

class PrayerTimesProvider extends ChangeNotifier {
  final PrayerTimesService service;
  final LocalNotificationService? notifications;
  PrayerTimes? _prayerTimes;
  bool isLoading = false;
  String? errorMessage;

  PrayerTimesProvider(this.service, {this.notifications});

  PrayerTimes? get prayerTimes => _prayerTimes;
  PrayerTime? get nextPrayer => _prayerTimes?.nextPrayer;

  Future<void> load() async {
    _prayerTimes = service.readCache();
    notifyListeners();
    await refresh();
  }

  Future<void> refresh() async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _prayerTimes = await service.fetchCurrent();
      if (_prayerTimes != null && notifications != null) {
        await notifications!.schedulePrayerNotifications(_prayerTimes!);
      }
    } on PrayerTimesException catch (error) {
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'تعذر تحميل مواقيت الصلاة، تحقق من الإنترنت والموقع';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
