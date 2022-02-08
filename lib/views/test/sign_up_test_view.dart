import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myref/models/user_model.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/views/components/round_btn.dart';
import 'package:myref/routes.dart';
import 'package:provider/provider.dart';


class SignUpTestView extends StatefulWidget {
  const SignUpTestView({Key? key}) : super(key: key);

  @override
  _SignUpTestViewState createState() => _SignUpTestViewState();
}

class _SignUpTestViewState extends State<SignUpTestView> {

  late TextEditingController _emailController;
  late TextEditingController _pwdController;
  late TextEditingController _pwdChkController;

  final _formKey = GlobalKey<FormState>();

  late FocusNode _emailFocusNode;
  late FocusNode _pwdFocusNode;

  late bool _isEmailError;  late String _errorEmailMsg;
  late bool _isPwdError;    late String _errorPwdMsg;
  late bool _isPwdChkError; late String _errorPwdChkMsg;  late bool _isPwdChkVisible;
  late bool _isSignUpError;
  late bool _isAbleSignUp;

  late bool _showSpinner;

  @override
  void initState() {
    _emailController = TextEditingController(text: '');
    _pwdController = TextEditingController(text: '');
    _pwdChkController = TextEditingController(text: '');

    _emailFocusNode = FocusNode();
    _pwdFocusNode = FocusNode();

    _isEmailError = false;  _errorEmailMsg = '';
    _isPwdError = false;    _errorPwdMsg = '';
    _isPwdChkError = false; _errorPwdChkMsg = ''; _isPwdChkVisible = false;
    _isSignUpError = false;
    _isAbleSignUp = false;

    _emailFocusNode.addListener(() {
      setState(() {
        if( !_emailFocusNode.hasFocus ) {
          if( _emailController.text.isEmpty ) {
            _isEmailError = true;
            _errorEmailMsg = AppLocalizations.of(context).translate("signUpTextEmail");
          }
          else if( RegExpUtil.isNotEmail(_emailController.text) ) {
            _isEmailError = true;
            _errorEmailMsg = AppLocalizations.of(context).translate("signUpTextRegExpErrorEmail");
          }
        }else{
          _isSignUpError = false;
          _isEmailError = false;
          _errorEmailMsg = "";
        }
        funcIsAbleSignUp();
      });
    });

    _pwdFocusNode.addListener(() {
      setState(() {
        if( !_pwdFocusNode.hasFocus ) {
          if( _pwdController.text.isEmpty ) {
            _isPwdError = true;
            _errorPwdMsg = AppLocalizations.of(context).translate("signUpTextPassword");
          }
        }else{
          _isPwdError = false;
          _errorPwdMsg = "";
        }
        funcIsAbleSignUp();
      });
    });

    _showSpinner = false;

    super.initState();
  }

  // 회원가입 가능여부 확인
  void funcIsAbleSignUp() {
    setState(() {
      if( _emailController.text.isNotEmpty
          && _pwdController.text.isNotEmpty
          && _pwdChkController.text.isNotEmpty ){
        if( _isEmailError || _isPwdError || _isPwdChkError ) {
          _isAbleSignUp = false;
        }else{
          _isAbleSignUp = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: ModalProgressHUD(
        progressIndicator: SpinKitThreeInOut(
          size: 35.0,
          color: Color(0xFFF9BE7C),
        ),
        inAsyncCall: _showSpinner,
        child: Scaffold(

          resizeToAvoidBottomInset: true,

          appBar: AppBar(
            elevation: 0,
            leading: _goBackButton(context),
            backgroundColor: Color(0xFFFFF9EC),
          ),
          backgroundColor: Color(0xFFFFF9EC),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text('Create Account',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Please fill the input below.',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14
                    ),),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        style: (TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400
                        )),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        obscureText: false,
                        decoration: InputDecoration(
                          errorText: _isEmailError
                              ? _errorEmailMsg
                              : _isSignUpError
                              ? _errorEmailMsg
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
                        onChanged: (_) {
                          setState(() {
                            if( _pwdController.text.isNotEmpty ) {
                              _isPwdChkVisible = true;
                              if( _pwdController.text.length < 6 ) {
                                _isPwdError = true;
                                _errorPwdMsg = AppLocalizations.of(context).translate("signUpPasswordCond");
                              }
                              else{
                                _isPwdError = false;
                                _errorPwdMsg = "";
                              }
                            }else{
                              _isPwdError = false;
                              _errorPwdMsg = "";
                              _isPwdChkVisible = false;
                              Timer(const Duration(milliseconds: 200), ()=> _pwdChkController.text = '');
                            }

                            if( _pwdChkController.text.isNotEmpty ) {
                              if( _pwdController.text != _pwdChkController.text ){
                                _isPwdChkError = true;
                                _errorPwdChkMsg = AppLocalizations.of(context).translate("signUpPasswordNotSame");
                              }else{
                                _isPwdChkError = false;
                                _errorPwdChkMsg = "";
                              }
                            }else{
                              _isPwdChkError = false;
                              _errorPwdChkMsg = "";
                            }
                            funcIsAbleSignUp();
                          });
                        },
                        obscureText: true,
                        cursorColor: Colors.black,
                        style: (TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400
                        )),
                        decoration: InputDecoration(
                          errorText: _isPwdError ? _errorPwdMsg : null,
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




                      SizedBox(
                        height: 10,
                      ),
                      AnimatedOpacity(
                        opacity: _isPwdChkVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          child: TextFormField(

                            controller: _pwdChkController,
                            onChanged: (_) {
                              setState(() {
                                if( _pwdChkController.text.isNotEmpty ) {
                                  if( _pwdChkController.text != _pwdController.text ) {
                                    _isPwdChkError = true;
                                    _errorPwdChkMsg = AppLocalizations.of(context).translate("signUpPasswordNotSame");
                                  }else {
                                    _isPwdChkError = false;
                                    _errorPwdChkMsg = "";
                                  }
                                }else{
                                  _isPwdChkError = false;
                                  _errorPwdChkMsg = "";
                                }
                                funcIsAbleSignUp();
                              });

                            },
                            obscureText: true,
                            cursorColor: Colors.black,
                            style: (TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            )),
                            decoration: InputDecoration(
                              errorText: _isPwdChkError ? _errorPwdChkMsg : null,
                              hintText: AppLocalizations.of(context).translate("signUpTextPasswordCheck"),
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
                        ),
                      )




                    ],
                  ),
                ),







                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(



                    child:
                      _isAbleSignUp
                    ?
                      RoundButton(
                        btnText: 'SIGN UP',
                        color: Color(0xFFF9BE7C),
                        onPressed: () async {
                          setState(() {
                            _showSpinner = true;
                            _isSignUpError = false;
                          });
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            // 회원가입 결과
                            try{
                              UserModel userModel =
                              await authProvider.registerWithEmailAndPassword(
                                  _emailController.text,
                                  _pwdController.text);
                              startTimer();
                            }catch (e){
                              _errorEmailMsg = e.toString();

                              if( _errorEmailMsg.contains("email-already-in-use") ){
                                _errorEmailMsg = AppLocalizations.of(context).translate("email-already-in-use");
                              }
                              else if( _errorEmailMsg.contains("invalid-email") ){
                                _errorEmailMsg = AppLocalizations.of(context).translate("invalid-email");
                              }
                              else if( _errorEmailMsg.contains("operation-not-allowed") ){
                                _errorEmailMsg = AppLocalizations.of(context).translate("operation-not-allowed");
                              }
                              else if( _errorEmailMsg.contains("weak-password") ){
                                _errorEmailMsg = AppLocalizations.of(context).translate("weak-password");
                              }
                              else {
                                _errorEmailMsg = AppLocalizations.of(context).translate("unknownError");
                              }
                              setState(() {
                                _isSignUpError = true;
                                _showSpinner = false;
                              });
                            }
                          }
                        },
                      )
                    :
                      RoundButton(
                          color: Color(0xFFFFE4C7).withOpacity(0.9),
                          btnText: 'SIGN UP',
                          onPressed: (){}
                      )
                    ,




                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400
                      ),),
                    TextButton(
                      onPressed: () {
                        authProvider.onAuthStateChanged(null);
                        Navigator.of(context).pop();
                      },
                      child: Text('Sign in',
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
    );
  }

  Widget _goBackButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop(true);
        });
  }

  // 회원가입 시작
  startTimer() {
    var duration = const Duration(seconds: 1);
    return Timer(duration, redirect);
  }
  // 로그인 화면으로 전환
  redirect() async {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.myRef, (r) => false);
  }
}
