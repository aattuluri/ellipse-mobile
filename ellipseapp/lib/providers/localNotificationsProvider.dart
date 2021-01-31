import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Serves as a way to communicate with the notification system.
class LocalNotificationsProvider with ChangeNotifier {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static final _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
        'Notes', 'Launches notifications', 'Get Remainders',
        playSound: true,
        enableVibration: true,
        priority: Priority.high,
        importance: Importance.max),
    iOS: IOSNotificationDetails(presentSound: true),
  );

  /// Initializes the notifications system
  Future<void> init() async {
    try {
      //_configureLocalTimeZone();
      print('Notification Initializing');
      await _notifications.initialize(
          InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings(),
          ),
          onSelectNotification: onSelectNotification);
      print('Notification Initialized');
    } catch (e) {
      print(e);
    }
  }

  Future onSelectNotification(String payload) async {
    //Navigator.pushNamed(context, Routes.viewNote, arguments: {'id': payload});
  }

  /// Cancels notifications with id
  static Future<void> cancelAllNotification(int id) async {
    await _notifications.cancel(0);
  }

  /// Cancels all pending notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Schedule new notifications
  static Future<void> scheduleNotifications(
    BuildContext context, {
    int id,
    String title,
    String subtitle,
    DateTime date,
    String payload,
  }) async {
    try {
      final localTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(localTimeZone));
      /*
      await _notifications.show(0, title, subtitle, _notificationDetails,
       payload: 'AndroidCoding.in');*/

      await _notifications.zonedSchedule(
        id,
        title,
        subtitle,
        tz.TZDateTime.from(date, tz.getLocation(localTimeZone)),
        _notificationDetails,
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
    } catch (e) {
      print(e);
    }
  }
}
