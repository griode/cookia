import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialization local notification
  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

// show simple notification
  static Future<void> showNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Channel 1',
      'Instance Notification',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _localNotificationsPlugin.show(0, title, body, notificationDetails,
        payload: 'item x');
  }

  // show periodic notification
  // static Future<void> periodicNotification() async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'chanel 2',
  //     'Rappel periodic notification',
  //     channelDescription: 'your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await _localNotificationsPlugin.periodicallyShow(
  //     1,
  //     'plain title',
  //     'plain body',
  //     RepeatInterval.everyMinute,
  //     notificationDetails,
  //     payload: 'item x',
  //   );
  // }
}
