import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:no_screen_before_sleep/MySettings.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';
import 'package:no_screen_before_sleep/pages/ScreenNapActive.dart';
import 'package:no_screen_before_sleep/pages/SettingsView.dart';
import 'package:no_screen_before_sleep/pages/ScreenNapSelect.dart';

import 'package:no_screen_before_sleep/utils/notification_service.dart';
import 'package:no_screen_before_sleep/color_schemes.g.dart';

GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Main Navigator");

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

Duration minutesToDuration(int timeInMinutes) {
  int hours = timeInMinutes ~/ 60;
  int minutes = (timeInMinutes % 60);
  return Duration(
    hours: hours,
    minutes: minutes,
  );
}

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

  static const String title = "Screen📱Nap😴";

  var settings = MySettings();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (settings.isScreenNapActive()) {
      homeWidget = ScreenNapActive();
    } else {
      homeWidget = ScreenNapSelect();
    }

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
      home: homeWidget,
    );
  }
}
