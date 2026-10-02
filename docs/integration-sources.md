# Integration sources

- AlAdhan Prayer Times API: https://aladhan.com/prayer-times-api
  - The service provides prayer times by coordinates. This project uses `GET https://api.aladhan.com/v1/timings?latitude=...&longitude=...&method=5` and reads `data.timings` plus `data.meta.timezone`.
- Geolocator package: https://pub.dev/packages/geolocator
  - Android requires `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION` in AndroidManifest.xml.
  - iOS requires `NSLocationWhenInUseUsageDescription` in Info.plist.
  - The runtime flow checks location service, checks/request permissions, handles denied and deniedForever, then calls `getCurrentPosition`.
- flutter_local_notifications: https://pub.dev/packages/flutter_local_notifications
  - Scheduled Android notifications require RECEIVE_BOOT_COMPLETED and scheduled notification receivers in AndroidManifest.xml.
  - `zonedSchedule` uses a TZDateTime from the timezone package; this project uses inexactAllowWhileIdle to avoid exact-alarm permission requirements.
  - Android 13+ notification permission is requested with the Android plugin implementation; iOS permissions are requested through Darwin implementation.
- timezone: https://pub.dev/packages/timezone
  - Initialize using `timezone/data/latest.dart` and `initializeTimeZones()` before creating TZDateTime values.
