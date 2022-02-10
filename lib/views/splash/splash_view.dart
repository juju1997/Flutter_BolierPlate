import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myref/constants/app_colors.dart';
import 'package:myref/routes.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/utils/encrypt.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backGround,
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
      ),
    );
  }

  void _checkUser(context) async {
    const storage = FlutterSecureStorage();
    Map<String, String> allStorage = await storage.readAll();
    print(allStorage);
    Encrypt sec = Encrypt();
      sec.init().then((_) {
        if( allStorage.containsKey('email') && allStorage.containsKey('uid') ){
          if( allStorage['email']!.isNotEmpty && allStorage['uid']!.isNotEmpty ){
            print ( 'email : ' + sec.decryption(allStorage['email']) );
            print ( 'uid : ' + sec.decryption(allStorage['uid']) );
          }else {
            print('저장된 사용자 정보 없음 1');
          }
        }else {
          print( '저장된 사용자 정보 없음 2' );
        }
      });


    // TODO 추후 주석 해제
    /*if( allStorage['email']!.isNotEmpty && allStorage['uid']!.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(Routes.myRef);
    }else{
      Navigator.of(context).pushReplacementNamed(Routes.signIn);
    }*/
    Navigator.of(context).pushReplacementNamed(Routes.signIn);
  }
}
