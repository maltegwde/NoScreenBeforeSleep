import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettings {
  static final MySettings _singleton = MySettings._internal();

  MySettings._internal() {}

  TimeOfDay reminderTime = TimeOfDay(hour: 18, minute: 0);
  Duration? noScreenTimeStart;
  Duration? noScreenTimeDuration;

  TimeOfDay? selectedSleepTime;

  factory MySettings() {
    return _singleton;
  }

  Future<void> loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? s = prefs.getString("reminder-time");

    s ??= "${reminderTime.hour}:${reminderTime.minute}";

    reminderTime = TimeOfDay(
        hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));

    print("loaded from cache: reminderTime: $reminderTime");
  }

  String getReminderTime([bool formatted = false]) {
    String hours = reminderTime.hour.toString();
    String minutes = reminderTime.minute.toString();

    // 11:0 -> 11:00
    if (reminderTime.minute.toString().length == 1) {
      minutes = "0$minutes";
    }

    return "$hours:$minutes";
  }
}
