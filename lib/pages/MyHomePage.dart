import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';

import 'package:no_screen_before_sleep/utils/notification_service.dart';
import 'package:no_screen_before_sleep/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int totalTimeMinutes = 0;
  List<AppUsageInfo> _infos = [];
  late final NotificationService notificationService;
  TimeOfDay selectedToD = TimeOfDay(hour: 22, minute: 0);

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime now = DateTime.now();
      //DateTime startDate = endDate.subtract(Duration(days: 1));

      // 0:00 of today
      DateTime startDate = DateTime(now.year, now.month, now.day);

      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, now);
      setState(() => _infos = infoList);

      print(infoList);

      totalTimeMinutes = 0;

      for (var application in infoList) {
        print(application.appName);
        print(application.usage.inMinutes);

        if (application.appName != "no_screen_before_sleep") {
          totalTimeMinutes += application.usage.inMinutes;
        }
      }

      print("Total: $totalTimeMinutes");
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: getUsageStats, child: Icon(Icons.file_download)),
          Expanded(
            child: ListView.builder(
              itemCount: _infos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_infos[index].appName),
                  trailing: Text(
                    _infos[index].usage.toString(),
                  ),
                );
              },
            ),
          ),
          Text(
            "Total: ${totalTimeMinutes.toString()}",
            textScaleFactor: 2.5,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: openSettingsView, child: Icon(Icons.settings)),
    );
  }
}
