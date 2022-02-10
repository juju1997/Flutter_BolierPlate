import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
                  child: Text('Find Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('We will send you a password reset link to the email you registered with.',
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
                        controller: _emailController,
                        style: (TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400
                        )),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
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















                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(



                    child:
                    _isAbleSend
                        ?
                    RoundButton(
                      btnText: 'Send Link',
                      color: Color(0xFFF9BE7C),
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
                        color: Color(0xFFFFE4C7).withOpacity(0.9),
                        btnText: 'Send Link',
                        onPressed: (){}
                    )
                    ,




                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Did you remember the password?',
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
