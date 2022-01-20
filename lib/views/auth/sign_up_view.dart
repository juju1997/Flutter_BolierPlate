import 'package:flutter/material.dart';
import 'package:myref/models/user_model.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/routes.dart';
import 'package:myref/app_localizations.dart';

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

  bool _hasSignUpError = false;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _passwordCheckController = TextEditingController(text: "");

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
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  errorText : _hasSignUpError
                      ? errorMsg
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
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate("signUpTextPassword"),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      // 회원가입 결과
                      try{
                        UserModel userModel =
                        await authProvider.registerWithEmailAndPassword(
                            _emailController.text,
                            _passwordCheckController.text);
                      }catch (e){
                        errorMsg = e.toString();

                        if( errorMsg.contains("email-already-in-use") ){
                          errorMsg = AppLocalizations.of(context).translate("email-already-in-use");
                        }
                        else if( errorMsg.contains("invalid-email") ){
                          errorMsg = AppLocalizations.of(context).translate("invalid-email");
                        }
                        else if( errorMsg.contains("operation-not-allowed") ){
                          errorMsg = AppLocalizations.of(context).translate("operation-not-allowed");
                        }
                        else if( errorMsg.contains("weak-password") ){
                          errorMsg = AppLocalizations.of(context).translate("weak-password");
                        }
                        else {
                          errorMsg = AppLocalizations.of(context).translate("unknownError");
                        }
                        setState(() {
                          _hasSignUpError = true;
                        });

                      }

                    }
                  },
                  child: Text(AppLocalizations.of(context).translate("signUpComplete"))
              )
            ],
          ),
        ),
      ),
    );
  }
}

