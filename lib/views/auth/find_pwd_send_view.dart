import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/routes.dart';

class FindPwdSendView extends StatefulWidget {
  const FindPwdSendView({Key? key}) : super(key: key);

  @override
  _FindPwdSendViewState createState() => _FindPwdSendViewState();
}

class _FindPwdSendViewState extends State<FindPwdSendView> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate("findPwdTitle"),
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(Routes.signIn);
                },
                icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 35.0,
                )
            )
          ],
        )
      ),
    );
  }
}
