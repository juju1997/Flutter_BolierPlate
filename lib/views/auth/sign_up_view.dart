import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myref/constants/app_colors.dart';
import 'package:myref/models/user_model.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/views/components/round_btn.dart';
import 'package:myref/routes.dart';
import 'package:provider/provider.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

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
        opacity: 0.4,
        progressIndicator: const SpinKitThreeInOut(
          size: 35.0,
          color: AppColors.spinKit,
        ),
        inAsyncCall: _showSpinner,
        child: Scaffold(

          resizeToAvoidBottomInset: true,

          appBar: AppBar(
            elevation: 0,
            leading: _goBackButton(context),
            backgroundColor: AppColors.backGround,
          ),
          backgroundColor: AppColors.backGround,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(AppLocalizations.of(context).translate("signUpAppBarTitle"),
                    style: const TextStyle(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(AppLocalizations.of(context).translate("signUpInputRequired"),
                    style: const TextStyle(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                    ),),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.065),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate("signUpEmailLabel"),
                        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.textBlack),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        focusNode: _emailFocusNode,
                        controller: _emailController,
                        style: const TextStyle(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w400
                        ),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.textBlack,
                        obscureText: false,
                        decoration: InputDecoration(
                          errorText: _isEmailError
                              ? _errorEmailMsg
                              : _isSignUpError
                              ? _errorEmailMsg
                              : null,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.authBtnActive, width: 5.0),
                              borderRadius:BorderRadius.circular(10.0)
                          ),
                          border: UnderlineInputBorder(
                              borderRadius:BorderRadius.circular(10.0)
                          ),
                          fillColor: AppColors.backGround,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: AppColors.authIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate("signUpPasswordLabel"),
                        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.textBlack),
                      ),
                      const SizedBox(
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
                        cursorColor: AppColors.textBlack,
                        style: (const TextStyle(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w400,
                            fontFamily: '_'
                        )),
                        decoration: InputDecoration(
                          errorText: _isPwdError ? _errorPwdMsg : null,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.authBtnActive, width: 5.0),
                              borderRadius:BorderRadius.circular(10.0)
                          ),
                          border: UnderlineInputBorder(
                              borderRadius:BorderRadius.circular(10.0)
                          ),
                          fillColor: AppColors.backGround,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: AppColors.authIcon,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AnimatedOpacity(
                        opacity: _isPwdChkVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
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
                          cursorColor: AppColors.textBlack,
                          style: const TextStyle(
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w400,
                              fontFamily: '_'
                          ),
                          decoration: InputDecoration(
                            errorText: _isPwdChkError ? _errorPwdChkMsg : null,
                            hintText: AppLocalizations.of(context).translate("signUpTextPasswordCheck"),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.authBtnActive, width: 5.0),
                                borderRadius:BorderRadius.circular(10.0)
                            ),
                            border: UnderlineInputBorder(
                                borderRadius:BorderRadius.circular(10.0)
                            ),
                            fillColor: AppColors.backGround,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: AppColors.authIcon,
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
                      btnText: AppLocalizations.of(context).translate("signUpReady"),
                      color: AppColors.authBtnActive,
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
                        color: AppColors.authBtnInActive.withOpacity(0.9),
                        btnText: AppLocalizations.of(context).translate("signUpReady"),
                        onPressed: (){}
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).translate("signUpAlreadySignUp"),
                      style: const TextStyle(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w400
                      ),),
                    TextButton(
                      onPressed: () {
                        authProvider.onAuthStateChanged(null);
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).translate("signUpToSignIn"),
                          style: const TextStyle(
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.bold
                          )
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
        icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
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

