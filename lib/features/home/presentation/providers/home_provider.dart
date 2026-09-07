import 'package:flutter/foundation.dart';

import '../../domain/entities/prayer_times.dart';
import '../../domain/entities/quran_ayah.dart';
import '../../domain/repositories/home_repository.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}
class DailyDhikr {
  final String text;
  final int repeatCount;

  const DailyDhikr({
    required this.text,
    required this.repeatCount,
  });
}

class HomeProvider extends ChangeNotifier {
  final HomeRepository repository;

  HomeProvider({
    required this.repository,
  });

  HomeStatus status = HomeStatus.initial;

  PrayerTimes? prayerTimes;
  QuranAyah? ayah;
  DailyDhikr? dhikr;
  String? errorMessage;

  Future<void> loadHomeData({
    required double latitude,
    required double longitude,
  }) async {
    status = HomeStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final prayerResult = await repository.getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        method: 5,
        school: 0,
      );

      final ayahResult = await repository.getRandomAyah();

      prayerTimes = prayerResult;
      ayah = ayahResult;
      status = HomeStatus.loaded;
    } catch (error) {
      status = HomeStatus.error;
      errorMessage = 'حدث خطأ أثناء تحميل بيانات الصفحة الرئيسية';

      debugPrint('HomeProvider error: $error');
    }

    notifyListeners();
  }

  Future<void> refresh({
    required double latitude,
    required double longitude,
  }) {
    return loadHomeData(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
