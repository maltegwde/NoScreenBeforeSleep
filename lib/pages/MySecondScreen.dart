import 'package:flutter/material.dart';
import 'package:no_screen_before_sleep/pages/MyHomePage.dart';

class MySecondScreen extends StatelessWidget {
  final String payload;
  const MySecondScreen({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyHomePage.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(payload)],
        ),
      ),
    );
  }
}
