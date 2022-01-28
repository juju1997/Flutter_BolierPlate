import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myref/routes.dart';
import 'package:myref/app_localizations.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  // Secure Storage
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(milliseconds: 1500), ()=> _checkUser(context));
  }

  /*startTimer() {
    var duration = const Duration(milliseconds: 1500);
    return Timer(duration, redirect);
  }
  redirect() async {
    Navigator.of(context).pushReplacementNamed(Routes.signIn);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                AppLocalizations.of(context).translate("splashText"),
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              )
            ),
            const FlutterLogo(
              size: 128,
            )
          ],
        ),
      ),
    );
  }

  void _checkUser(context) async {
    const storage = FlutterSecureStorage();
    Map<String, String> allStorage = await storage.readAll();
    print(allStorage);
    // TODO 추후 주석 해제
    /*if( allStorage['email']!.isNotEmpty && allStorage['uid']!.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(Routes.myRef);
    }else{
      Navigator.of(context).pushReplacementNamed(Routes.signIn);
    }*/
    Navigator.of(context).pushReplacementNamed(Routes.signIn);
  }
}
