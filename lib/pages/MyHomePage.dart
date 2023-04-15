import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MySecondScreen.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const String title = "📵before😴";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NotificationService notificationService;
  TimeOfDay selectedToD = TimeOfDay(hour: 22, minute: 0);

  @override
  void initState() {
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MySecondScreen(payload: payload)));
      });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyHomePage.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Image.asset(
              "android/app/src/main/res/mipmap/ic_launcher.png",
              width: 240,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await selectTimeDialog(context);
                    await notificationService
                        .scheduleFixedTimeLocalNotification(
                            id: 1,
                            title: "Put your phone down",
                            body: "Your NoScreen time starts now.",
                            payload: "You just took water! Huurray!",
                            hour: selectedToD.hour,
                            minute: selectedToD.minute,
                            second: 0);
                  },
                  child: const Text("Schedule fixed time notification")),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                onPressed: () async {
                  await notificationService.scheduleDelayedLocalNotification(
                      id: 2,
                      title: "Drink Water",
                      body: "Time to drink some water!",
                      payload: "You just took water! Huurray!",
                      duration: Duration(seconds: 5));
                },
                child: const Text("Schedule delayed notification "))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  notificationService.cancelAllNotifications();
                },
                child: const Text(
                  "Cancel All Notifications",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
