import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:no_screen_before_sleep/MySettings.dart';
import 'package:no_screen_before_sleep/main.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

class ScreenNapActive extends StatefulWidget {
  const ScreenNapActive({Key? key}) : super(key: key);

  @override
  State<ScreenNapActive> createState() => _ScreenNapActiveState();
}

class _ScreenNapActiveState extends State<ScreenNapActive> {
  late NotificationService notificationService;

  Timer? timer;

  String timeLeft = "Waiting...";

  var settings = MySettings();

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => doSomething());
  }

  void doSomething() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    Duration tp = settings.screenNapEnd!.difference(now);

    setState(() {
      timeLeft = tp.toString().split(".").first;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color.fromARGB(255, 235, 75, 26);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
      ),
      body: Builder(
        builder: (context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin:
                        const EdgeInsets.only(bottom: 180, left: 80, right: 80),
                    alignment: Alignment.center,
                    child: Text(
                      "ScreenNap running: $timeLeft",
                      textScaleFactor: 2.8,
                      textAlign: TextAlign.center,
                    )),
              ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: openSettingsView, child: Icon(Icons.settings)),
    );
  }
}
