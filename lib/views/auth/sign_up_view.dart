import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myref/models/user_model.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/routes.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:provider/provider.dart';
import 'package:progress_state_button/progress_button.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {



  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordCheckController;

  final _formKey = GlobalKey<FormState>();

  late FocusNode _emailFocusNode;
  late FocusNode _pwdFocusNode;

  late bool _isEmailError;    late String _errorEmailMsg;
  late bool _isPwdError;      late String _errorPwdMsg;
  late bool _isPwdChkError;   late String _errorPwdChkMsg;
  late bool _isSignUpError;
  late bool _isAbleSignUp;

  late ButtonState _btnState;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _passwordCheckController = TextEditingController(text: "");

    _emailFocusNode = FocusNode();
    _pwdFocusNode = FocusNode();

    _isEmailError = false;    _errorEmailMsg = "";
    _isPwdError = false;      _errorPwdMsg = "";
    _isPwdChkError = false;   _errorPwdChkMsg = "";
    _isSignUpError = false;
    _isAbleSignUp = false;

    _btnState = ButtonState.fail;

    // 이메일 포커스노드
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

    // 비밀번호 포커스노드
    _pwdFocusNode.addListener(() {
      setState(() {
        if( !_pwdFocusNode.hasFocus ) {
          if( _passwordController.text.isEmpty ) {
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
  }

  // 회원가입 가능여부 확인
  void funcIsAbleSignUp() {
    setState(() {
      if( _emailController.text.isNotEmpty
          && _passwordController.text.isNotEmpty
          && _passwordCheckController.text.isNotEmpty ){
        if( _isEmailError || _isPwdError || _isPwdChkError ) {
          _isAbleSignUp = false;
        }else{
          _isAbleSignUp = true;
        }
      }

      if( _isAbleSignUp ) {
        _btnState = ButtonState.idle;
      }else{
        _btnState = ButtonState.fail;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset : false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context).translate("signUpAppBarTitle"),
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.black,
                    size: 35.0
                )
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: _buildForm(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    _emailFocusNode.dispose();
    _pwdFocusNode.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children:<Widget>[
                  Text(
                    AppLocalizations.of(context).translate("signUpEmailLabel"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  errorText: _isEmailError
                      ? _errorEmailMsg
                      : _isSignUpError
                      ? _errorEmailMsg
                      : null,
                  hintText: AppLocalizations.of(context).translate("signUpTextEmail"),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text(
                      AppLocalizations.of(context).translate("signUpPasswordLabel")
                  )
                ],
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                focusNode: _pwdFocusNode,
                obscureText: true,
                onChanged: (_) {
                  setState(() {
                    if( _passwordController.text.isNotEmpty ) {
                      if( _passwordController.text.length < 6 ) {
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
                    }

                    if( _passwordCheckController.text.isNotEmpty ) {
                      if( _passwordController.text != _passwordCheckController.text ){
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
                controller: _passwordController,
                decoration: InputDecoration(
                    errorText: _isPwdError ? _errorPwdMsg : null,
                    hintText: AppLocalizations.of(context).translate("signUpPasswordCond"),
                    border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 10.0,),
              TextFormField(
                onChanged: (_) {
                  setState(() {
                    if( _passwordCheckController.text.isNotEmpty ) {
                      if( _passwordCheckController.text != _passwordController.text ) {
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
                controller: _passwordCheckController,
                decoration: InputDecoration(
                    errorText: _isPwdChkError ? _errorPwdChkMsg : null,
                    hintText: AppLocalizations.of(context).translate("signUpTextPasswordCheck"),
                    border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0),
              authProvider.status == Status.registering
                ? ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: (){},
                    state: ButtonState.loading,
                    )
                :
                  ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: () async {
                      setState(() {
                        _isSignUpError = false;
                      });
                      if( _btnState == ButtonState.idle ) {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          // 회원가입 결과
                          try{
                            UserModel userModel =
                            await authProvider.registerWithEmailAndPassword(
                                _emailController.text,
                                _passwordCheckController.text);

                            setState(() {
                              _btnState = ButtonState.success;
                            });
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
                            });
                          }
                        }
                      }
                    },
                    state: _btnState
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // 회원가입 시작
  startTimer() {
    var duration = const Duration(seconds: 1);
    return Timer(duration, redirect);
  }
  // 로그인 화면으로 전환
  redirect() async {
    Navigator.of(context).pushReplacementNamed(Routes.signIn);
  }

}

Map<ButtonState, Widget> btnState(BuildContext context) {
  return {
    ButtonState.fail: Text(
        AppLocalizations.of(context).translate("signUpReady"),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ), // 비활성버튼
    ButtonState.idle: Text(
      AppLocalizations.of(context).translate("signUpReady"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.loading: Text(
      AppLocalizations.of(context).translate("signUpLoading"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.success: Text(
      AppLocalizations.of(context).translate("signUpComplete"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    )
  };
}
Map<ButtonState, Color> btnColor(BuildContext context) {
  return {
    ButtonState.fail: Colors.grey.shade300,  // 버튼 비활성 상태
    ButtonState.idle: Colors.blue.shade300,
    ButtonState.loading: Colors.blue.shade300,
    ButtonState.success: Colors.green.shade400,
  };
}

