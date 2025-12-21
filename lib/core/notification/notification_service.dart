import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static NotificationDetails notificationDetails = const NotificationDetails();

  static Future<void> init() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const settings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationPlugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> registerChannel({
    int id = 0,
    String title = 'Reminder',
    String body = 'It\'s time for your task',
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for reminders',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          showWhen: true,
        );
    notificationDetails = NotificationDetails(android: androidDetails);
  }
}
