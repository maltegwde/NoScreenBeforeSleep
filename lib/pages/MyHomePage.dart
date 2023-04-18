import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/utils/notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const String title = "📵before😴";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);

      int totalTimeMinutes = 0;

      for (var application in infoList) {
        print(application.appName);
        print(application.usage.inMinutes);

        if (application.appName != "no_screen_before_sleep") {
          totalTimeMinutes += application.usage.inMinutes;
        }
      }

      print(totalTimeMinutes);
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyHomePage.title),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _infos.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(_infos[index].appName),
                trailing: Text(_infos[index].usage.toString()));
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: getUsageStats, child: Icon(Icons.file_download)),
    );
  }
}
