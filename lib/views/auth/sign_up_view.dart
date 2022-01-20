import 'package:flutter/material.dart';
import 'package:myref/models/user_model.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/routes.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:provider/provider.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  bool _hasSignUpError = false;
  String _emailErrorMsg = '';
  bool _hasPasswordError = false;
  String _passwordErrorMsg = '';
  bool _hasPasswordCheckError = false;
  String _passwordCheckErrorMsg = '';
  bool _isAbleSignUp = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _passwordCheckController = TextEditingController(text: "");

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      if( !_emailFocusNode.hasFocus ){
        setState(() {
          // 이메일 인풋이 비었을때
          if( _emailController.text.isEmpty ) {
           _emailErrorMsg = AppLocalizations.of(context).translate("signUpTextEmail");
           _hasSignUpError = true;
           // 이메일 형식이 아닐때
          }else if( RegExpUtil.isNotEmail(_emailController.text) ) {
            _emailErrorMsg = AppLocalizations.of(context).translate("signUpTextRegExpErrorEmail");
            _hasSignUpError = true;
          }else{
            _hasSignUpError = false;
          }
        });
      }else{
        _hasSignUpError = false;
      }
    });
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      if( !_passwordFocusNode.hasFocus ){
        setState(() {
          if( _passwordController.text.isEmpty ) {
            _passwordErrorMsg = AppLocalizations.of(context).translate("signUpTextPassword");
            _hasPasswordError = true;
          }else if( _passwordController.text.length < 6 ) {
            _passwordErrorMsg = AppLocalizations.of(context).translate("signUpPasswordCond");
            _hasPasswordError = true;
          }else{
            _hasPasswordError = false;
          }
        });
      }else{
        _hasPasswordError = false;
      }
    });
  }

  // 비밀번호 유효성 검사
  void _validPassword(bool validRes, String msg){
    setState(() {
      _hasPasswordError = validRes;
      if( _hasPasswordError ) {
        _passwordErrorMsg = msg;
      }
    });
  }

  // 회원가입 가능 여부
  // TODO
  void _ableSignUp(String type, bool isAble) {
    setState(() {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate("signUpEmailLabel")
              ),
              const SizedBox(height: 6.0),
              TextField(
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  errorText : _hasSignUpError
                      ? _emailErrorMsg
                      : null,
                  hintText: AppLocalizations.of(context).translate("signUpTextEmail"),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                  AppLocalizations.of(context).translate("signUpPasswordLabel")
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                focusNode: _passwordFocusNode,
                obscureText: true,
                onChanged: (_) {
                  if(_passwordController.text.length < 6){
                    _validPassword(
                      true,
                      AppLocalizations.of(context).translate("signUpPasswordCond")
                    );
                  }else {
                    _validPassword(
                      false,
                      ''
                    );
                  }
                },
                controller: _passwordController,
                decoration: InputDecoration(
                    errorText: _hasPasswordError
                                ? _passwordErrorMsg
                                : null,
                    hintText: AppLocalizations.of(context).translate("signUpPasswordCond"),
                    border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 10.0,),
              TextFormField(
                obscureText: true,
                controller: _passwordCheckController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate("signUpTextPasswordCheck"),
                    border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0,),
              authProvider.status == Status.registering
                  ? const Center(
                  child: CircularProgressIndicator()
              )
                  : ElevatedButton(
                  onPressed: _isAbleSignUp ? () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      // 회원가입 결과
                      try{
                        UserModel userModel =
                        await authProvider.registerWithEmailAndPassword(
                            _emailController.text,
                            _passwordCheckController.text);
                      }catch (e){
                        _emailErrorMsg = e.toString();

                        if( _emailErrorMsg.contains("email-already-in-use") ){
                          _emailErrorMsg = AppLocalizations.of(context).translate("email-already-in-use");
                        }
                        else if( _emailErrorMsg.contains("invalid-email") ){
                          _emailErrorMsg = AppLocalizations.of(context).translate("invalid-email");
                        }
                        else if( _emailErrorMsg.contains("operation-not-allowed") ){
                          _emailErrorMsg = AppLocalizations.of(context).translate("operation-not-allowed");
                        }
                        else if( _emailErrorMsg.contains("weak-password") ){
                          _emailErrorMsg = AppLocalizations.of(context).translate("weak-password");
                        }
                        else {
                          _emailErrorMsg = AppLocalizations.of(context).translate("unknownError");
                        }
                        setState(() {
                          _hasSignUpError = true;
                        });

                      }

                    }
                  }
                  : null,
                  child: Text(AppLocalizations.of(context).translate("signUpComplete"))
              )
            ],
          ),
        ),
      ),
    );
  }
}

