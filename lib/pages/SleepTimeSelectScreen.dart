import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';

class SleepTimeSelectScreen extends StatefulWidget {
  const SleepTimeSelectScreen({Key? key}) : super(key: key);

  @override
  State<SleepTimeSelectScreen> createState() => _SleepTimeSelectScreenState();
}

class _SleepTimeSelectScreenState extends State<SleepTimeSelectScreen> {
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
            onPressed: () {
              //showPicker(context);
              /*
              Future<TimeOfDay?> selectedTime = showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );
              */

              getTime(context);
            },
            child: const Text('Select TimeOfDay'),
          ));
        }));
  }

  Future<void> getTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      helpText: "When do you want to sleep?",
    );

    if (selectedTime != null) {
      selectedToD = selectedTime;
      print('Selected time: ${selectedToD.hour}:${selectedToD.minute}');
    }
  }
}
