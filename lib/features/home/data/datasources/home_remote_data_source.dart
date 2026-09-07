import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mariam/features/home/domain/entities/prayer_times.dart';
import 'package:mariam/features/home/domain/entities/quran_ayah.dart';



abstract class HomeRemoteDataSource {
  Future<PrayerTimes> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method,
    int school,
  });

  Future<QuranAyah> getRandomAyah();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  static const _prayerBaseUrl = 'https://api.aladhan.com/v1';
  static const _quranBaseUrl = 'https://api.alquran.cloud/v1';

  @override
  Future<PrayerTimes> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method = 5,
    int school = 0,
  } ) async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final response = await dio.get(
      '$_prayerBaseUrl/timings/$date',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'method': method,
        'school': school,
      },
    );

    final body = Map<String, dynamic>.from(response.data);

    if (body['code'] != 200 || body['data'] == null) {
      throw Exception('فشل تحميل مواقيت الصلاة');
    }

    final data = Map<String, dynamic>.from(body['data']);
    final timings = Map<String, dynamic>.from(data['timings']);
    final hijriDate =
    Map<String, dynamic>.from(data['date']?['hijri'] ?? {});

    return PrayerTimes(
      fajr: _cleanTime(timings['Fajr']),
      sunrise: _cleanTime(timings['Sunrise']),
      dhuhr: _cleanTime(timings['Dhuhr']),
      asr: _cleanTime(timings['Asr']),
      maghrib: _cleanTime(timings['Maghrib']),
      isha: _cleanTime(timings['Isha']),
      date: hijriDate['date']?.toString() ?? '',
    );
  }

  @override
  Future<QuranAyah> getRandomAyah() async {
    final response = await dio.get(
      '$_quranBaseUrl/ayah/random/quran-uthmani',
    );

    final body = Map<String, dynamic>.from(response.data);

    if (body['code'] != 200 || body['data'] == null) {
      throw Exception('فشل تحميل الآية');
    }

    final data = Map<String, dynamic>.from(body['data']);
    final surah = Map<String, dynamic>.from(data['surah']);

    return QuranAyah(
      number: (data['number'] as num).toInt(),
      numberInSurah: (data['numberInSurah'] as num).toInt(),
      text: data['text']?.toString() ?? '',
      surahName: surah['name']?.toString() ?? '',
    );
  }

  String _cleanTime(dynamic value) {
    if (value == null) return '--:--';

    return value
        .toString()
        .replaceAll(RegExp(r'\s*\(.*?\)'), '')
        .trim();
  }
}
