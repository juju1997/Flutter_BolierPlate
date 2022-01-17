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

  bool _hasEmailError = false;
  late FocusNode _emailFocusNode;

  late bool _isEmptyEmail;
  late bool _isEmptyPwd;
  late bool _isAbleLogin;

  @override
  void initState() {
    super.initState();

    _isEmptyEmail = true;
    _isEmptyPwd = true;
    _isAbleLogin = false;

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
          _hasEmailError = false;
        });
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


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                child: FlutterLogo(
                  size: 128,
                ),
              ),
              TextFormField(
                onChanged: (_){
                  if(_emailController.text.isEmpty){
                    _ableLogin('email', false);
                  }else{
                    _ableLogin('email', true);
                  }
                },
                focusNode: _emailFocusNode,
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
                    errorText: _hasEmailError ? AppLocalizations.of(context)
                          .translate("signInTextRegExpErrorEmail") : null,
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
                  onChanged: (_){
                    if(_passwordController.text.isEmpty){
                      _ableLogin('pwd', false);
                    }else{
                      _ableLogin('pwd', true);
                    }
                  },
                  obscureText: true,
                  maxLength: 12,
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
              authProvider.status == Status.registering
                  ? const Center(
                  child: CircularProgressIndicator()
              )
                  : ElevatedButton(
                      onPressed: _isAbleLogin ? () async {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();

                          bool status =
                          await authProvider.signInWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text
                          );

                          if( !status ){
                            print('로그인 실패');
                          }else {
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

/** TODO
 * 이메일 텍스트폼 아웃포커스 시 이메일 유효성 OK
 * 체인지이벤트로 value null or 이메일 유효성 이면 로그인버튼 비활성화
 *
 * */