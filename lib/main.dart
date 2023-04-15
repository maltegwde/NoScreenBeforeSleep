import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';
import 'package:no_screen_before_sleep/pages/SleepTimeSelectScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyHomePage.title,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SleepTimeSelectScreen(),
    );
  }
}
