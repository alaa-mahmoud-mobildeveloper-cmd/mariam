class PrayerTime {
  final String name;
  final String arabicName;
  final String time;

  const PrayerTime({
    required this.name,
    required this.arabicName,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'arabicName': arabicName,
    'time': time,
  };

  factory PrayerTime.fromJson(Map<String, dynamic> json) => PrayerTime(
    name: json['name'] as String,
    arabicName: json['arabicName'] as String,
    time: json['time'] as String,
  );
}

class PrayerTimes {
  final DateTime date;
  final double latitude;
  final double longitude;
  final String timezone;
  final List<PrayerTime> prayers;

  const PrayerTimes({
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.prayers,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'timezone': timezone,
    'prayers': prayers.map((item) => item.toJson()).toList(),
  };

  factory PrayerTimes.fromJson(Map<String, dynamic> json) => PrayerTimes(
    date: DateTime.parse(json['date'] as String),
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    timezone: json['timezone'] as String? ?? 'UTC',
    prayers: (json['prayers'] as List<dynamic>)
        .map(
          (item) => PrayerTime.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
  );

  PrayerTime? get nextPrayer {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    for (final prayer in prayers) {
      final parts = prayer.time.split(':');
      if (parts.length != 2) continue;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) continue;
      if (hour * 60 + minute > currentMinutes) return prayer;
    }
    return prayers.isEmpty ? null : prayers.first;
  }
}
