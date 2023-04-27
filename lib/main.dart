import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import 'package:no_screen_before_sleep/MySettings.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';
import 'package:no_screen_before_sleep/pages/SettingsView.dart';
import 'package:no_screen_before_sleep/pages/SleepTimeSelect.dart';

import 'package:no_screen_before_sleep/utils/notification_service.dart';
import 'package:no_screen_before_sleep/color_schemes.g.dart';

GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Main Navigator");

Future<dynamic> openView(StatefulWidget stflwdgt) async {
  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => MyHomePage(),
  ));
}

Future<dynamic> openHomePage() async {
  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => MyHomePage(),
  ));
}

Future<dynamic> openSettingsView() async {
  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => SettingsView(),
  ));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  notificationService.initializePlatformNotifications();

  MySettings settings = MySettings();
  await settings.loadValues();

  // daily notification at 6pm
  notificationService.scheduleDailyLocalNotification(
      id: 12,
      title: "Set your sleep time!",
      body: "When will you go to sleep?",
      payload: "SetSleepTime",
      notificationTime: settings.reminderTime);

  await initSettings();

  runApp(MyApp());
}

Future<void> initSettings() async {
  await Settings.init(
    cacheProvider: SharePreferenceCache(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static const String title = "📵before😴";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      home: const SleepTimeSelect(),
    );
  }
}
