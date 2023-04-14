import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MySecondScreen.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NotificationService notificationService;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("    No📱\nBefore😴"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 100),
            child: Image.asset("assets/images/justwater.png", scale: 0.6),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await notificationService.showLocalNotification(
                        id: 0,
                        title: "Drink Water",
                        body: "Time to drink some water!",
                        payload: "You just took water! Huurray!");
                  },
                  child: const Text("Drink Now")),
              ElevatedButton(
                  onPressed: () async {
                    await notificationService
                        .scheduleFixedTimeLocalNotification(
                            id: 1,
                            title: "Drink Water",
                            body: "Time to drink some water!",
                            payload: "You just took water! Huurray!",
                            hour: 0,
                            minute: 5,
                            second: 45);
                  },
                  onLongPress: () async {
                    await notificationService.showScheduledLocalNotification(
                        id: 2,
                        title: "Drink Water",
                        body: "Time to drink some water!",
                        payload: "You just took water! Huurray!",
                        seconds: 2);
                  },
                  child: const Text("Schedule Drink "))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  notificationService.cancelAllNotifications();
                },
                child: const Text(
                  "Cancel All Drinks",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
