import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myref/constants/app_colors.dart';
import 'package:myref/models/screen_arguments.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/views/components/round_btn.dart';
import 'package:myref/routes.dart';
import 'package:provider/provider.dart';

class FindPwdView extends StatefulWidget {
  const FindPwdView({Key? key}) : super(key: key);

  @override
  _FindPwdViewState createState() => _FindPwdViewState();
}

class _FindPwdViewState extends State<FindPwdView> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late bool _isEmailError; late String _errorEmailMsg;
  late bool _isAbleSend;
  late bool _showSpinner;

  @override
  void initState() {
    _emailController = TextEditingController(text: "");
    _isEmailError = false; _errorEmailMsg = "";
    _isAbleSend = false;
    _showSpinner = false;

    super.initState();
  }

  void _ableSend(bool isAble){
    setState(() {
      _isAbleSend = isAble;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(AppLocalizations.of(context).translate("findPwdTitle"),
                    style: const TextStyle(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(AppLocalizations.of(context).translate("findPwdSendLink"),
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
                        AppLocalizations.of(context).translate("findPwdEmailLabel"),
                        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.textBlack),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w400
                        ),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.textBlack,
                        obscureText: false,
                        onChanged: (_) {
                          if( _emailController.text.isEmpty ){
                            _ableSend(false);
                          }else{
                            _ableSend(true);
                          }
                        },
                        decoration: InputDecoration(
                          errorText: _isEmailError
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child:
                    _isAbleSend
                        ?
                    RoundButton(
                      btnText: AppLocalizations.of(context).translate("sendPwdEmailBtn"),
                      color: AppColors.authBtnActive,
                      onPressed: () async {
                        setState(() {
                          _showSpinner = true;
                          _isEmailError = false;
                        });

                        if (_formKey.currentState!.validate()) {

                          try{
                            if( _emailController.text.isEmpty ) {
                              setState((){
                                _showSpinner = false;
                                _isEmailError = true;
                              });
                              _errorEmailMsg = AppLocalizations.of(context).translate("findPwdTextErrorEmail");
                            }
                            else if( RegExpUtil.isNotEmail(_emailController.text) ){
                              setState((){
                                _showSpinner = false;
                                _isEmailError = true;
                              });
                              _errorEmailMsg = AppLocalizations.of(context).translate("findPwdTextRegExpErrorEmail");
                            }else{

                              FocusScope.of(context).unfocus();
                              await authProvider.sendPasswordResetEmail(_emailController.text);
                              startTimer();
                            }
                          }catch (e){
                            _errorEmailMsg = e.toString();
                            if( _errorEmailMsg.contains("user-not-found") ) {
                              _errorEmailMsg = AppLocalizations.of(context).translate("user-not-found");
                            }else {
                              _errorEmailMsg = AppLocalizations.of(context).translate("unknownError");
                            }
                            setState(() {
                              _isEmailError = true;
                              _showSpinner = false;
                            });
                          }
                        }
                      },
                    )
                        :
                    RoundButton(
                        color: AppColors.authBtnInActive.withOpacity(0.9),
                        btnText: AppLocalizations.of(context).translate("sendPwdEmailBtn"),
                        onPressed: (){}
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).translate("findPwdRememberPwd"),
                      style: const TextStyle(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w400
                      ),),
                    TextButton(
                      onPressed: () {
                        authProvider.onAuthStateChanged(null);
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).translate("signIn"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack)
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

  // 비밀번호 찾기 시작
  startTimer() {
    var duration = const Duration(seconds: 1);
    return Timer(duration, redirect);
  }
  // 메일전송 성공화면 전환
  redirect() async {
    ScreenArguments args = ScreenArguments('email', _emailController.text);
    setState((){
      _showSpinner = false;
      _isEmailError = false;
    });
    Navigator.of(context).pushNamed(Routes.findPwdSend, arguments: args);
  }
}
