import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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
      helpText:
          'Select the time for the "When will you go to sleep?" notification',
    );

    if (selectedTime != null) {
      await loadReminderTime();

      setState(() {
        str_reminder_time = selectedTime.format(context);
      });

      print('Selected time: $str_reminder_time');
      print("Writing $selectedTime to cache");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("reminder-time",
          str_reminder_time); // ensure, that reminder time is formatted correctly
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
              SimpleSettingsTile(
                title: str_reminder_time,
                titleTextStyle: TextStyle(fontSize: 20),
                subtitle:
                    'When do you want to be notified to set your sleep time?',
                onTap: () => selectTimeDialog(context),
              ),
              DropDownSettingsTile<int>(
                title: 'NoScreenTime start',
                subtitle:
                    'Choose the duration of screen-free time before sleep',
                settingKey: 'noscreentime-start',
                values: <int, String>{
                  15: '15min prior',
                  30: '30min prior',
                  60: '1 hour prior',
                  120: '2 hours prior',
                },
                selected: 60,
                onChange: (value) {
                  debugPrint('noscreentime-start: $value');
                },
              ),
              TextInputSettingsTile(
                title: 'NoScreenTime duration',
                settingKey: 'noscreentime-duration',
                initialValue: '6',
                keyboardType: TextInputType.number,
                /*
                  validator: (String? timeLengthInput) {
                    if (timeLengthInput != null &&
                        (int.parse(timeLengthInput) > 3)) {
                      //setState(() => _infos = infoList);
                      return null;
                    }
                    //TODO: insert good error message
                    return "NoScreen Time length error.";
                  },
                  */
                borderColor: Colors.blueAccent,
                errorColor: Colors.deepOrangeAccent,
                onChange: (value) {
                  debugPrint('noscreentime-duration: $value');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
