import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';
import 'package:no_screen_before_sleep/pages/SleepTimeSelect.dart';

import 'package:no_screen_before_sleep/utils/notification_service.dart';
import 'package:no_screen_before_sleep/color_schemes.g.dart';

GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Main Navigator");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  notificationService.initializePlatformNotifications();

  // daily notification at 6pm
  notificationService.scheduleDailyLocalNotification(
      id: 12,
      title: "Set your sleep time!",
      body: "When will you go to sleep?",
      payload: "SetSleepTime",
      notificationTime: TimeOfDay(hour: 17, minute: 31));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: MyHomePage.title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      home: const MyHomePage(),
    );
  }
}
