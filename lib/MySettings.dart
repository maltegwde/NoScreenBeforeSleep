import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/timezone.dart' as tz;

class MySettings {
  static final MySettings _singleton = MySettings._internal();

  MySettings._internal() {}

  TimeOfDay reminderTime = TimeOfDay(hour: 18, minute: 0);

  //TimeOfDay? screenNapStart;
  Duration? screenNapDuration;

  tz.TZDateTime? screenNapStart;
  tz.TZDateTime? screenNapEnd;

  factory MySettings() {
    return _singleton;
  }

  Future<void> loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // reminderTime
    //prefs.setString("reminder-time", "13:44");
    String? prefReminderTime = prefs.getString("reminder-time");
    prefReminderTime ??= "${reminderTime.hour}:${reminderTime.minute}";

    reminderTime = TimeOfDay(
        hour: int.parse(prefReminderTime.split(":")[0]),
        minute: int.parse(prefReminderTime.split(":")[1]));
    print("loaded from cache: reminderTime: $reminderTime");

    // ScreenNap-duration
    int? prefScreenNapDuration = prefs.getInt("ScreenNap-duration");
    screenNapDuration = minutesToDuration(prefScreenNapDuration!);
    print("loaded from cache: ScreenNapDuration $screenNapDuration");

    // ScreenNapStart
    String? strScreenNapStart = prefs.getString("ScreenNapStart");
    screenNapStart = tz.TZDateTime.parse(tz.local, strScreenNapStart!);
    print("loaded from cache: ScreenNapStart ${screenNapStart.toString()}");

    // ScreenNapEnd
    String? strScreenNapEnd = prefs.getString("ScreenNapEnd");
    screenNapEnd = tz.TZDateTime.parse(tz.local, strScreenNapEnd!);
    print("loaded from cache: ScreenNapEnd ${screenNapEnd.toString()}");
  }

  void setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print("# setString: $key:$value");
  }

  bool isScreenNapActive() {
    print("screenNapDuration: ${screenNapDuration.toString()}");
    print("prefScreenNapStart: ${screenNapStart.toString()}");
    print("prefScreenNapEnd: ${screenNapEnd.toString()}");

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    return now.isAfter(screenNapStart!) && now.isBefore(screenNapEnd!);
  }

  String getReminderTime() {
    return reminderTime.to24hours();
  }
}
