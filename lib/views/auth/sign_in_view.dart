import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/routes.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:progress_state_button/progress_button.dart';

import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // 이메일 형식 오류
  bool _hasEmailError = false;

  late FocusNode _emailFocusNode;
  late FocusNode _pwdFocusNode;

  // 이메일 공백체크
  late bool _isEmptyEmail;
  // 비밀번호 공백체크
  late bool _isEmptyPwd;
  // 로그인 버튼 활성화 여부
  late bool _isAbleLogin;

  // 로그인 실패
  late bool _isLoginFailed;

  late ButtonState _btnState;

  @override
  void initState() {
    super.initState();

    _isEmptyEmail = true;
    _isEmptyPwd = true;
    _isAbleLogin = false;
    _isLoginFailed = false;
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _btnState = ButtonState.fail;

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

  }

  // 로그인 가능여부 확인
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

      if( _isAbleLogin ) {
        _btnState = ButtonState.idle;
      }else {
        _btnState = ButtonState.fail;
      }
    });
  }
  // 로그인 실패 메시지 컨트롤
  void _isLoginFailedMsg(bool status){
    setState(() {
      _isLoginFailed = status;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: _buildForm(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context){
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
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailFocusNode,
                onChanged: (_){
                  if(_emailController.text.isEmpty){
                    _ableLogin('email', false);
                  }else{
                    _ableLogin('email', true);
                  }
                },
                controller: _emailController,
                style: Theme.of(context).textTheme.bodyText1,
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
                decoration: InputDecoration(
                  errorText: _hasEmailError
                            ? AppLocalizations.of(context).translate("signInTextRegExpErrorEmail")
                            : _isLoginFailed
                              ? AppLocalizations.of(context).translate("signInNoRegistered")
                              : null,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText: AppLocalizations.of(context)
                        .translate("signInTextEmail"),
                    border: const OutlineInputBorder()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  focusNode: _pwdFocusNode,
                  onChanged: (_){
                    if(_passwordController.text.isEmpty){
                      _ableLogin('pwd', false);
                    }else{
                      _ableLogin('pwd', true);
                    }
                  },
                  obscureText: true,
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.bodyText1,
                  validator: (value) => value!.isEmpty
                      ? AppLocalizations.of(context)
                      .translate("signInTextErrorPassword")
                      : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText: AppLocalizations.of(context)
                          .translate("signInTextPassword"),
                      border: const OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 20.0),
              // 로그인 중
              authProvider.status == Status.authenticating
                ? ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: (){},
                    state: ButtonState.loading,
                  )
                :
              // 로그인 성공
              authProvider.status == Status.authenticated
                ?
                  ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: (){},
                    state: ButtonState.success,
                  )
                :
                  ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: () async {
                      setState(() {
                        _hasEmailError = false;
                        _isLoginFailedMsg(false);
                      });
                      if( _btnState == ButtonState.idle ){
                        if (_formKey.currentState!.validate()) {
                          bool status =
                          await authProvider.signInWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text
                          );
                          if( !status ){
                            _isLoginFailedMsg(true);
                          }else {
                            FocusScope.of(context).unfocus(); // 키보드 내리기

                            startTimer(status);
                          }
                        }
                      }
                    },
                    state: _btnState,
                  ),
              const SizedBox(
                height: 80.0,
              ),
              TextButton(
                child: Text(AppLocalizations.of(context).translate("signUp")),
                onPressed: () {
                  authProvider.onAuthStateChanged(null);
                  Navigator.of(context).pushNamed(Routes.signUp);
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextButton(
                child: Text(AppLocalizations.of(context).translate("findPwd")),
                onPressed: () {
                  authProvider.onAuthStateChanged(null);
                  Navigator.of(context).pushNamed(Routes.findPwd);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  // 로그인 시작
  startTimer(bool res) {
    var duration = const Duration(seconds: 1);
    return Timer(duration, res ? redirect : stayView);
  }
  // 로그인 화면으로 전환
  redirect() async {
    Navigator.of(context).pushReplacementNamed(Routes.myRef);
  }
  // 로그인 취소
  stayView() {}
}


Map<ButtonState, Widget> btnState(BuildContext context) {
  return {
    ButtonState.fail: Text(
      AppLocalizations.of(context).translate("signIn"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ), // 비활성버튼
    ButtonState.idle: Text(
      AppLocalizations.of(context).translate("signIn"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.loading: Text(
      AppLocalizations.of(context).translate("signInLoading"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.success: Text(
      AppLocalizations.of(context).translate("sigInInComplete"),
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




