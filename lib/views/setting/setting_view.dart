import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SettingView TEST",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SettingView"),
        ),
      ),
    );
  }
  
}
    