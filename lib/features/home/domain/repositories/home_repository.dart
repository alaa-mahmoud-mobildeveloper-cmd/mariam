import '../entities/prayer_times.dart';
import '../entities/quran_ayah.dart';

abstract class HomeRepository {
  Future<PrayerTimes> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method,
    int school,
  } );

  Future<QuranAyah> getRandomAyah();
}
