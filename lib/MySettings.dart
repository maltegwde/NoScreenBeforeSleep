import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/timezone.dart' as tz;

class MySettings {
  static final MySettings _singleton = MySettings._internal();

  MySettings._internal() {}

  TimeOfDay reminderTime = TimeOfDay(hour: 18, minute: 0);

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
    screenNapDuration = prefScreenNapDuration != null
        ? minutesToDuration(prefScreenNapDuration)
        : null;
    print("loaded from cache: ScreenNapDuration $screenNapDuration");

    // ScreenNapStart
    String? strScreenNapStart = prefs.getString("ScreenNapStart");
    screenNapStart = strScreenNapStart != null
        ? tz.TZDateTime.parse(tz.local, strScreenNapStart)
        : null;
    print("loaded from cache: ScreenNapStart ${screenNapStart.toString()}");

    // ScreenNapEnd
    String? strScreenNapEnd = prefs.getString("ScreenNapEnd");
    screenNapEnd = strScreenNapEnd != null
        ? tz.TZDateTime.parse(tz.local, strScreenNapEnd)
        : null;

    print("loaded from cache: ScreenNapEnd ${screenNapEnd.toString()}");
  }

  void setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print("# setString: $key:$value");
  }

  bool isScreenNapActive() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    if (screenNapStart == null || screenNapEnd == null) {
      return false;
    }

    bool screenNapActive =
        now.isAfter(screenNapStart!) && now.isBefore(screenNapEnd!);

    print("screenNapActive: $screenNapActive");
    return screenNapActive;
  }

  String getReminderTime() {
    return reminderTime.to24hours();
  }
}
