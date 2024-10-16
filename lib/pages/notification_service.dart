import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(),
    ));
    tz.initializeTimeZones();
  }

  static scheduledNotification(
      int index, String title, String body, DateTime dateTime) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    var androidDetails = AndroidNotificationDetails(
        'important_notification', 'My Channel',
        importance: Importance.high, priority: Priority.high);
    var iOsDetails = const DarwinNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOsDetails);
    await _notification.zonedSchedule(
        index, title, body, scheduledDate, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }
}
