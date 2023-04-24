import 'package:flutter/material.dart';

import 'package:no_screen_before_sleep/main.dart';
import 'package:no_screen_before_sleep/utils/NoScreenTimer.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

class NoScreenTimeStarts extends StatefulWidget {
  const NoScreenTimeStarts({Key? key}) : super(key: key);

  @override
  @override
  State<NoScreenTimeStarts> createState() => _NoScreenTimeStartsState();
}

class _NoScreenTimeStartsState extends State<NoScreenTimeStarts> {
  late final NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                      "Your NoScreen\n    time starts\n         now.",
                      textScaleFactor: 2.8,
                    )),
                Container(
                    margin: const EdgeInsets.only(bottom: 150),
                    child: ElevatedButton(
                        onPressed: () {
                          print("NoScreen time started!");
                          //TODO: start NoScreen time.

                          //var nst = NoScreenTimer();
                        },
                        child: const Text('OK'))),
              ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: openSettingsView, child: Icon(Icons.settings)),
    );
  }
}
