import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/routes.dart';
import 'package:crypto/crypto.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();

    _isEmptyEmail = true;
    _isEmptyPwd = true;
    _isAbleLogin = false;
    _isLoginFailed = false;
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");

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
      if(type == 'pwd'){
        isAble ? _isEmptyPwd = false : _isEmptyPwd = true;
      }
      if(_isEmptyEmail || _isEmptyPwd) {
        _isAbleLogin = false;
      }else{
        _isAbleLogin = true;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: 15.0),
              authProvider.status == Status.registering
                  ? const Center(
                  child: CircularProgressIndicator()
              )
                  : ElevatedButton(
                      onPressed: _isAbleLogin ? () async {
                        _isLoginFailedMsg(false);
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
                            print('로그인 성공');
                          }
                        }
                      } : null,
                  child: Text(AppLocalizations.of(context).translate("signIn")),
              ),
              const SizedBox(
                height: 5.0,
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed(Routes.signUp);
                  },
                  child: Text(AppLocalizations.of(context).translate("signUp"))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
