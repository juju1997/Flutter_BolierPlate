import 'package:flutter/material.dart';

class SendLinkTestView extends StatefulWidget {
  const SendLinkTestView({Key? key}) : super(key: key);

  @override
  _SendLinkTestViewState createState() => _SendLinkTestViewState();
}

class _SendLinkTestViewState extends State<SendLinkTestView> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFFFF9EC),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
