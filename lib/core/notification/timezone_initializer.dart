import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class TimezoneInitializer {
  static bool _initialized = false;

  static Future<void> timeZoneInit() async {
    try {
      if (_initialized) return;
      tz.initializeTimeZones();
      Location location = getLocation('Asia/Kolkata');
      setLocalLocation(location);

      _initialized = true;
    } on Exception {
      Location location = getLocation('Asia/Kolkata');
      setLocalLocation(location);
      _initialized = false;
    }
  }
}
