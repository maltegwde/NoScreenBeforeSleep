import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:no_screen_before_sleep/color_schemes.g.dart';

import 'package:no_screen_before_sleep/main.dart';
import 'package:no_screen_before_sleep/MySettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key, settings});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  MySettings settings = MySettings();

  String str_reminder_time = "Loading...";

  Future<void> loadReminderTime() async {
    await settings.loadValues();

    setState(() {
      str_reminder_time = settings.getReminderTime();
    });
  }

  @override
  void initState() {
    super.initState();
    loadReminderTime();
  }

  Future<TimeOfDay?> selectTimeDialog(BuildContext context) async {
    //settings.loadValues();  // reload values whenever you

    TimeOfDay? selectedTime = await showTimePicker(
      initialTime: settings.reminderTime, // set initial time to the saved one
      context: context,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      helpText:
          'Select the time for the "When will you go to sleep?" notification',
    );

    if (selectedTime != null) {
      await loadReminderTime();

      setState(() {
        str_reminder_time = selectedTime.to24hours();
      });

      print('Selected time: $str_reminder_time');
      print("Writing $selectedTime to cache");

      settings.setString("reminder-time", str_reminder_time);
    }

    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsScreen(
        title: MyApp.title,
        children: [
          SettingsGroup(
            title: 'Settings',
            children: <Widget>[
              /*
              SimpleSettingsTile(
                title: str_reminder_time,
                titleTextStyle: TextStyle(fontSize: 20),
                subtitle:
                    'When do you want to be notified to schedule a ScreenNap?',
                onTap: () => selectTimeDialog(context),
              ),
              */
              DropDownSettingsTile<int>(
                title: 'ScreenNap duration',
                subtitle: 'Adjust the duration of a screen nap',
                settingKey: 'ScreenNap-duration',
                values: <int, String>{
                  30: '30 minutes',
                  60: '1 hour',
                  120: '2 hours',
                  240: '4 hours',
                  360: '6 hours',
                },
                selected: 240,
                onChange: (value) {
                  debugPrint('ScreenNap-duration: $value');
                  settings.screenNapDuration = minutesToDuration(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
