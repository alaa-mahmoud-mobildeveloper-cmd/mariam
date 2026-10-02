import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/prayer_times.dart';

class PrayerTimesService {
  static const _cacheKey = 'cached_prayer_times';
  final Dio dio;
  final SharedPreferences prefs;

  PrayerTimesService(this.prefs, {Dio? dio}) : dio = dio ?? Dio();

  Future<Position> _currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const PrayerTimesException('خدمة الموقع غير مفعلة');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const PrayerTimesException('تم رفض صلاحية الموقع');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const PrayerTimesException(
        'صلاحية الموقع مرفوضة نهائيًا من إعدادات الجهاز',
      );
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }

  Future<PrayerTimes> fetchCurrent() async {
    final position = await _currentPosition();
    final response = await dio.get<Map<String, dynamic>>(
      'https://api.aladhan.com/v1/timings',
      queryParameters: {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'method': 5,
      },
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final timings = data?['timings'] as Map<String, dynamic>?;
    if (timings == null)
      throw const PrayerTimesException('استجابة مواقيت الصلاة غير صالحة');
    final names = const {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };
    final prayers = names.entries
        .map(
          (entry) => PrayerTime(
            name: entry.key,
            arabicName: entry.value,
            time: (timings[entry.key] as String).split(' ').first,
          ),
        )
        .toList();
    final result = PrayerTimes(
      date: DateTime.now(),
      latitude: position.latitude,
      longitude: position.longitude,
      timezone:
          (data?['meta'] as Map<String, dynamic>?)?['timezone'] as String? ??
          'UTC',
      prayers: prayers,
    );
    await prefs.setString(_cacheKey, jsonEncode(result.toJson()));
    return result;
  }

  PrayerTimes? readCache() {
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return null;
    try {
      return PrayerTimes.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

class PrayerTimesException implements Exception {
  final String message;
  const PrayerTimesException(this.message);
  @override
  String toString() => message;
}
