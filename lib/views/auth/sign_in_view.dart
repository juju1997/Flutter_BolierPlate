import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:myref/providers/auth_provider.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:myref/views/components/round_btn.dart';
import 'package:provider/provider.dart';

import 'package:myref/app_localizations.dart';
import 'package:myref/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  late DateTime currentBackPressTime;

  late TextEditingController _emailController;
  late TextEditingController _pwdController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late FocusNode _emailFocusNode; // 이메일 포커스노드
  late FocusNode _pwdFocusNode;   // 비밀번호 포커스노드

  late bool _hasEmailError; // 이메일 에러표시
  late bool _isEmptyEmail;  // 공백 이메일
  late bool _isEmptyPwd;    // 공백 비밀번호
  late bool _isAbleLogin;   // 로그인버튼 활성화 여부
  late bool _isLoginFailed; // 로그인 실패 여부

  late bool _showSpinner;   // 화면 로딩

  late DateTime _backButtonPressedTime;

  @override
  void initState() {
    _emailController = TextEditingController(text: '');
    _pwdController = TextEditingController(text: '');

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      if( !_emailFocusNode.hasFocus ){
        setState(() {
          _hasEmailError = RegExpUtil.isNotEmail(_emailController.text) && _emailController.text.isNotEmpty;
        });
      }else{
        setState(() {
          _isLoginFailed = false;
          _hasEmailError = false;
        });
      }
    });
    _pwdFocusNode = FocusNode();
    _pwdFocusNode.addListener(() {
      if(_pwdFocusNode.hasFocus){
        _isLoginFailed = false;
      }
    });

    _hasEmailError = false;
    _isEmptyEmail = true;
    _isEmptyPwd = true;
    _isAbleLogin = false;
    _isLoginFailed = false;

    _showSpinner = false;

    _backButtonPressedTime =  DateTime(1997);

    super.initState();
  }

  void _ableLogin(String type, bool isAble){
    setState(() {
      if(type == 'email'){
        isAble ? _isEmptyEmail = false : _isEmptyEmail = true;
      }
      else if(type == 'pwd'){
        isAble ? _isEmptyPwd = false : _isEmptyPwd = true;
      }
      if(_isEmptyEmail || _isEmptyPwd) {
        _isAbleLogin = false;
      }else{
        _isAbleLogin = true;
      }
    });
  }

  // 로그인 메시징 처리
  void _isLoginFailedMsg(bool status) {
    setState(() {
      _isLoginFailed = status;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _emailFocusNode.dispose();
    _pwdFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: ModalProgressHUD(
          opacity: 0.4,
          progressIndicator: SpinKitThreeInOut(
            size: 35.0,
            color: Color(0xFFF9BE7C),
          ),
          inAsyncCall: _showSpinner,
          child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xFFFFF9EC),
            body: WillPopScope(
              onWillPop: onWillPop,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Center(
                        child: SizedBox(
                            width: 175,
                            height: 175,
                            child: SizedBox(
                                width: 175,
                                height: 175,
                                child: FlutterLogo()
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                        child: Text('Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text('로그인 후에 이용할 수 있어요!.',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 13
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'E-mail',
                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),







                              TextFormField(
                                focusNode: _emailFocusNode,
                                controller: _emailController,
                                onChanged: (_){
                                  if(_emailController.text.isEmpty){
                                    _ableLogin('email', false);
                                  }else{
                                    _ableLogin('email', true);
                                  }
                                },
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return AppLocalizations.of(context).translate("signInTextErrorEmail");
                                  }
                                  else if(! RegExpUtil.isEmail(value)){
                                    return AppLocalizations.of(context).translate("signInTextRegExpErrorEmail");
                                  }else{
                                    return null;
                                  }
                                },
                                style: (TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400
                                )),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.black,
                                obscureText: false,
                                decoration: InputDecoration(
                                  errorText: _hasEmailError
                                      ? AppLocalizations.of(context).translate("signInTextRegExpErrorEmail")
                                      : _isLoginFailed
                                      ? AppLocalizations.of(context).translate("signInNoRegistered")
                                      : null,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFF9BE7C), width: 5.0),
                                      borderRadius:BorderRadius.circular(10.0)
                                  ),
                                  border: UnderlineInputBorder(
                                      borderRadius:BorderRadius.circular(10.0)
                                  ),
                                  fillColor: Color(0xFFFFF9EC),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color(0xFFF9BE7C),
                                  ),
                                ),
                              ),





                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Password',
                              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),





                            TextFormField(
                              focusNode: _pwdFocusNode,
                              controller: _pwdController,
                              onChanged: (_){
                                if(_pwdController.text.isEmpty){
                                  _ableLogin('pwd', false);
                                }else{
                                  _ableLogin('pwd', true);
                                }
                              },
                              style: (TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400
                              )),
                              validator: (value) => value!.isEmpty
                                  ? AppLocalizations.of(context)
                                  .translate("signInTextErrorPassword")
                                  : null,
                              obscureText: true,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFF9BE7C), width: 5.0),
                                    borderRadius:BorderRadius.circular(10.0)
                                ),
                                border: UnderlineInputBorder(
                                    borderRadius:BorderRadius.circular(10.0)
                                ),
                                fillColor: Color(0xFFFFF9EC),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xFFF9BE7C),
                                ),
                              ),
                            ),




                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(




                            child:
                            _isAbleLogin
                                ?
                            RoundButton(
                              btnText: 'LOGIN',
                              color: Color(0xFFF9BE7C),
                              onPressed: () async {
                                setState(() {
                                  _showSpinner = true;
                                  _hasEmailError = false;
                                  _isLoginFailedMsg(false);
                                });

                                if (_formKey.currentState!.validate()) {
                                  bool status =
                                  await authProvider.signInWithEmailAndPassword(
                                      _emailController.text,
                                      _pwdController.text
                                  );
                                  if( !status ){
                                    _isLoginFailedMsg(true);
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  }else {
                                    FocusScope.of(context).unfocus(); // 키보드 내리기

                                    startTimer(status);
                                  }
                                }else{
                                  setState(() {
                                    _showSpinner = false;
                                  });
                                }


                              },
                            )
                                :
                            RoundButton(
                                color: Color(0xFFFFE4C7).withOpacity(0.9),
                                btnText: 'LOGIN',
                                onPressed: (){}
                            )





                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        /*child: Text('Forgot Password?',
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),*/
                        child: TextButton(
                          onPressed: (){
                            FocusScope.of(context).unfocus();
                            authProvider.onAuthStateChanged(null);
                            Navigator.of(context).pushNamed(Routes.findPwd);
                          },
                          child: Text('Forgot Password?',
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Dont have an account?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400
                              )),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              authProvider.onAuthStateChanged(null);
                              Navigator.of(context).pushNamed(Routes.signUp);
                            },
                            child: Text('Sign up',
                                style: TextStyle(
                                    color: Colors.black)
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    print('1');
    //Statement 1 Or statement2
    bool backButton = currentTime.difference(_backButtonPressedTime) > Duration(seconds: 3);
    if (backButton) {
      _backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "뒤로가기 버튼을 한번 더 누르면 종료됩니다.",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  // 로그인 시작
  startTimer(bool res) {
    var duration = const Duration(seconds: 1);
    return Timer(duration, redirect);
  }
  // 로그인 화면으로 전환
  redirect() async {
    //Navigator.of(context).pushNamedAndRemoveUntil(Routes.myRef, (r) => false);
    print('이동');
  }

}




