import 'package:flutter/material.dart';
import 'package:myref/views/auth/find_pwd_send_view.dart';
import 'package:myref/views/auth/find_pwd_view.dart';
import 'package:myref/views/splash/splash_view.dart';
import 'package:myref/views/auth/sign_up_view.dart';
import 'package:myref/views/auth/sign_in_view.dart';
import 'package:myref/views/ref/myref_view.dart';
import 'package:myref/views/setting/setting_view.dart';
import 'package:myref/views/test/sign_in_test_view.dart';

class Routes {
  Routes._(); // 객체생성 방지

  static const splash = '/splash';
  static const signUp = '/signUp';
  static const signIn = '/signIn';
  static const findPwd = '/findPwd';
  static const findPwdSend = '/findPwdSend';
  static const myRef = '/myRef';
  static const setting = '/setting';

  static const signInTest = '/signInTest';



  static final routes = <String, WidgetBuilder> {
    splash: (BuildContext context) => const SplashView(),
    signUp: (BuildContext context) => const SignUpView(),
    signIn: (BuildContext context) => const SignInView(),
    findPwd: (BuildContext context) => const FindPwdView(),
    findPwdSend: (BuildContext context) => const FindPwdSendView(),
    myRef: (BuildContext context) => const MyRefView(),
    setting: (BuildContext context) => const SettingView(),

    signInTest: (BuildContext context) => const SignInTestView()
  };
}
