import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

class SleepTimeSelectScreen extends StatefulWidget {
  const SleepTimeSelectScreen({Key? key}) : super(key: key);

  @override
  State<SleepTimeSelectScreen> createState() => _SleepTimeSelectScreenState();
}

class _SleepTimeSelectScreenState extends State<SleepTimeSelectScreen> {
  late final NotificationService notificationService;
  TimeOfDay selectedToD = TimeOfDay(hour: 12, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(MyHomePage.title),
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          return Center(
              child: ElevatedButton(
            onPressed: () async {
              await selectTimeDialog(context);
              await notificationService.scheduleFixedTimeLocalNotification(
                  id: 1,
                  title: "Put your phone down",
                  body: "Your NoScreen time starts now.",
                  payload: "Put your phone down now",
                  hour: selectedToD.hour,
                  minute: selectedToD.minute,
                  second: 0);
            },
            child: const Text('Select TimeOfDay'),
          ));
        }));
  }

  Future<void> selectTimeDialog(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
        helpText: "When do you want to sleep?");

    if (selectedTime != null) {
      selectedToD = selectedTime;
      print('Selected time: ${selectedToD.hour}:${selectedToD.minute}');
    }
  }
}
