import '../../domain/entities/prayer_times.dart';
import '../../domain/entities/quran_ayah.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<PrayerTimes> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method = 5,
    int school = 0,
  }) {
    return remoteDataSource.getPrayerTimes(
      latitude: latitude,
      longitude: longitude,
      method: method,
      school: school,
    );
  }

  @override
  Future<QuranAyah> getRandomAyah() {
    return remoteDataSource.getRandomAyah();
  }
}
