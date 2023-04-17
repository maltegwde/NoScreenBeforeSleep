import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SleepTimeSelect extends StatefulWidget {
  const SleepTimeSelect({Key? key}) : super(key: key);

  @override
  State<SleepTimeSelect> createState() => _SleepTimeSelectState();
}

class _SleepTimeSelectState extends State<SleepTimeSelect> {
  late final NotificationService notificationService;
  TimeOfDay selectedToD = TimeOfDay(hour: 12, minute: 0);
  bool timeSelected = false;

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  Future<void> selectTimeDialog(BuildContext context) async {
    timeSelected = false;

    // TimeOfDay.now() gives wrong time (utc). workaround:
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    TimeOfDay initTime = TimeOfDay(hour: now.hour, minute: now.minute);

    TimeOfDay? selectedTime = await showTimePicker(
        initialTime: initTime,
        context: context,
        helpText: "When do you want to sleep?");

    if (selectedTime != null) {
      selectedToD = selectedTime;
      timeSelected = true;
      print("timeSelected: $timeSelected");
      print('Selected time: ${selectedToD.hour}:${selectedToD.minute}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(MyHomePage.title),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 80),
                      alignment: Alignment.center,
                      child: Text(
                        "By which time\n   do you plan\n     to sleep?",
                        textScaleFactor: 2.8,
                      )),
                  Container(
                      margin: const EdgeInsets.only(bottom: 150),
                      child: ElevatedButton(
                          onPressed: () async {
                            await selectTimeDialog(context);
                            if (timeSelected) {
                              await notificationService
                                  .scheduleNoScreenReminderNotification(
                                id: 1,
                                title: "Put your phone down",
                                body: "Your NoScreen time starts now.",
                                payload: "NoScreenTimeStart",
                                hour: selectedToD.hour,
                                minute: selectedToD.minute,
                              );
                            }
                          },
                          child: const Text('Select TimeOfDay'))),
                ]);
          },
        ));
  }
}
