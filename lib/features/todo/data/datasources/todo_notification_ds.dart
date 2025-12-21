import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes/features/todo/data/models/todo_model.dart';
import 'package:timezone/timezone.dart' as tz;

class TodoNotificationDataSource {
  final FlutterLocalNotificationsPlugin plugin;
  final NotificationDetails notificationDetails;

  TodoNotificationDataSource({
    required this.plugin,
    required this.notificationDetails,
  });

  Future<void> schedule(TodoModel todo) async {
    if (todo.id == null) return;

    final scheduled = tz.TZDateTime.from(todo.dateTime, tz.local);

    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await plugin.zonedSchedule(
      todo.id!,
      todo.title,
      todo.description,
      tz.TZDateTime.from(todo.dateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
