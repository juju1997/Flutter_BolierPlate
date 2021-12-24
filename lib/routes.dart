import 'package:flutter/material.dart';
import 'package:myref/views/splash/splash_view.dart';
import 'package:myref/views/auth/sign_up_view.dart';
import 'package:myref/views/auth/sign_in_view.dart';
import 'package:myref/views/ref/myref_view.dart';
import 'package:myref/views/setting/setting_view.dart';

class Routes {
  Routes._(); // 객체생성 방지

  static const splash = '/splash';
  static const signUp = '/signUp';
  static const signIn = '/signIn';
  static const myRef = '/myRef';
  static const setting = '/setting';


  static final routes = <String, WidgetBuilder> {
    splash: (BuildContext context) => const SplashView(),
    signUp: (BuildContext context) => const SignUpView(),
    signIn: (BuildContext context) => const SignInView(),
    myRef: (BuildContext context) => const MyRefView(),
    setting : (BuildContext context) => const SettingView(),
  };
}
