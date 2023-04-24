import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:no_screen_before_sleep/pages/NoScreenTimeStarts.dart';
import 'package:no_screen_before_sleep/pages/SleepTimeSelect.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:no_screen_before_sleep/main.dart';

class NotificationService {
  NotificationService();

  final Duration noScreenBeforeSleepDuration = Duration(hours: 2, minutes: 0);

  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/notification_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Europe/Berlin"));

    await _localNotifications.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    /*
    final bigPicture = await DownloadUtil.downloadAndSaveFile(
        "https://images.unsplash.com/photo-1624948465027-6f9b51067557?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
        Platform.isIOS ? "drinkwater.jpg" : "drinkwater");
        */

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      groupKey: 'de.schneider.no_screen_before_sleep',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      color: const Color(0xff2196f3),
    );

    IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(threadIdentifier: "thread1");

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      behaviorSubject.add(details.payload!);
    }

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    print("showLocalNotification");
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleDelayedLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required Duration duration,
  }) async {
    print("scheduleDelayedLocalNotification");
    final platformChannelSpecifics = await _notificationDetails();

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = now.add(duration);

    print("Current time:   $now\nScheduled date: $scheduledTime");

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      platformChannelSpecifics,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> scheduleNoScreenReminderNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int hour,
    int minute = 0,
  }) async {
    print("scheduleNoScreenReminderNotification");

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime noScreenNotificationTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    noScreenNotificationTime =
        noScreenNotificationTime.subtract(noScreenBeforeSleepDuration);

    TimeOfDay notificationTime = TimeOfDay(
        hour: noScreenNotificationTime.hour,
        minute: noScreenNotificationTime.minute);

    scheduleFixedTimeLocalNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
        notificationTime: notificationTime);
  }

  Future<void> scheduleDailyLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required TimeOfDay notificationTime,
  }) async {
    print("scheduleDailyLocalNotification");
    scheduleFixedTimeLocalNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      notificationTime: notificationTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleFixedTimeLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required TimeOfDay notificationTime,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    print("scheduleFixedTimeLocalNotification");
    final platformChannelSpecifics = await _notificationDetails();

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    Duration diff = nextInstanceOfLocalTime(
            hour: notificationTime.hour, minute: notificationTime.minute)
        .difference(now);

    tz.TZDateTime scheduledDate = now.add(diff);

    print("Current time:   $now\nScheduled date: $scheduledDate");

    await _localNotifications.zonedSchedule(
        id, title, body, scheduledDate, platformChannelSpecifics,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: matchDateTimeComponents);
  }

  Future<void> showPeriodicLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required RepeatInterval interval,
  }) async {
    print("showPeriodicLocalNotification");
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.periodicallyShow(
      id,
      title,
      body,
      interval,
      platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: false,
    );
  }

  tz.TZDateTime nextInstanceOfLocalTime({
    required int hour,
    required int minute,
    int second = 0,
  }) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute, second);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    print('id $id');
  }

  void selectNotification(String? payload) {
    if (payload == null || payload.isEmpty) {
      return;
    }

    behaviorSubject.add(payload);

    if (payload == 'NoScreenTimeStart') {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => NoScreenTimeStarts(),
      ));
    } else if (payload == 'SetSleepTime') {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => SleepTimeSelect(launchedFromNotification: true),
      ));
    }
  }

  void cancelAllNotifications() => _localNotifications.cancelAll();
}
