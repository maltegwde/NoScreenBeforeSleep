import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:no_screen_before_sleep/MySettings.dart';
import 'package:no_screen_before_sleep/main.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

class ScreenNapSelect extends StatefulWidget {
  const ScreenNapSelect({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenNapSelect> createState() => _ScreenNapSelectState();
}

class _ScreenNapSelectState extends State<ScreenNapSelect> {
  late final NotificationService notificationService;

  TimeOfDay? selectedToD = TimeOfDay(hour: 12, minute: 0);

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    super.initState();

    // TODO: add Timer.periodic(Duration(seconds: 1), (Timer t) => doSomething());
    //  call settings.isScreenNapActive(). if true, open ScreenNapActive view
  }

  Future<TimeOfDay?> selectTimeDialog(BuildContext context) async {
    // TimeOfDay.now() gives wrong time (utc). workaround:
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    TimeOfDay initTime = TimeOfDay(hour: now.hour, minute: now.minute);

    TimeOfDay? selectedTime = await showTimePicker(
      initialTime: initTime,
      context: context,
      helpText: "When do you want to sleep?",
    );

    if (selectedTime != null) {
      print('Selected time: ${selectedTime.to24hours()}');
    }

    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    String textViewContent = "Set time for your next screen nap!";

    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 80, left: 80, right: 80),
                    alignment: Alignment.center,
                    child: Text(
                      textViewContent,
                      textScaleFactor: 2.8,
                      textAlign: TextAlign.center,
                    )),
                Container(
                    margin: const EdgeInsets.only(bottom: 150),
                    child: ElevatedButton(
                        onPressed: () async {
                          selectedToD = await selectTimeDialog(context);
                          if (selectedToD != null) {
                            var settings = MySettings();

                            tz.TZDateTime now = tz.TZDateTime.now(tz.local);
                            tz.TZDateTime screenNapStart = tz.TZDateTime(
                                tz.local,
                                now.year,
                                now.month,
                                now.day,
                                selectedToD!.hour,
                                selectedToD!.minute);

                            settings.setString(
                                "ScreenNapStart", screenNapStart.toString());

                            tz.TZDateTime screenNapEnd =
                                screenNapStart.add(settings.screenNapDuration!);

                            settings.setString(
                                "ScreenNapEnd", screenNapEnd.toString());

                            await notificationService
                                .scheduleNoScreenReminderNotification(
                              id: 1,
                              title: "Put your phone down",
                              body: "ScreenNap starts now.",
                              payload: "ScreenNapStart",
                              hour: selectedToD!.hour,
                              minute: selectedToD!.minute,
                            );
                          }
                        },
                        child: const Text('Select TimeOfDay'))),
              ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: openSettingsView, child: Icon(Icons.settings)),
    );
  }
}
