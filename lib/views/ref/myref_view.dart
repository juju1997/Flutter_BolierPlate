import 'package:flutter/material.dart';

class MyRefView extends StatefulWidget {
  const MyRefView({Key? key}) : super(key: key);

  @override
  _MyRefViewState createState() => _MyRefViewState();
}

class _MyRefViewState extends State<MyRefView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyRefView"),
      ),
    );
  }
  
}
