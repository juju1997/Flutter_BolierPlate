import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SignInView TEST",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SignInView"),
        )
      ),
    );
  }
  
}
