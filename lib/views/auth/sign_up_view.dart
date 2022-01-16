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
      title: "SignUpView TEST",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SignUpView"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.purple,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: _buildForm(context),
            )
          ],
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
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate("signUpTextEmail"),
                  border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate("signUpTextPassword"),
                    border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                controller: _passwordCheckController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate("signUpTextPasswordCheck"),
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

                      UserModel userModel =
                            await authProvider.registerWithEmailAndPassword(
                          _emailController.text,
                          _passwordCheckController.text);
                      if(userModel == null) {
                        print('회원가입 실패');
                      }
                      print(userModel.toJson());
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

