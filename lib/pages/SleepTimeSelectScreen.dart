import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:no_screen_before_sleep/data/picker_data.dart';
import 'package:flutter_picker/flutter_picker.dart';

class SleepTimeSelectScreen extends StatelessWidget {
  const SleepTimeSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test title"),
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          return Center(
              child: ElevatedButton(
            onPressed: () {
              showPicker(context);
            },
            child: const Text('Testtext123'),
          ));
        }));
  }

  showPicker(BuildContext context) async {
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(
            pickerData: JsonDecoder().convert(pickerData1)),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: TextStyle(color: Colors.blue),
        selectedTextStyle: TextStyle(color: Colors.red),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        });
    picker.showBottomSheet(context);
  }
}
