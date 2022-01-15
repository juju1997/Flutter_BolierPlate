import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/routes.dart';
import 'package:crypto/crypto.dart';
import 'package:myref/providers/auth_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
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
                controller: _emailController,
                style: Theme.of(context).textTheme.bodyText1,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)
                        .translate("loginTextErrorEmail") : null,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText: AppLocalizations.of(context)
                        .translate("loginTextEmail"),
                    border: const OutlineInputBorder()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  obscureText: true,
                  maxLength: 12,
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.bodyText1,
                  validator: (value) => value!.length < 6
                      ? AppLocalizations.of(context)
                      .translate("loginTextErrorPassword")
                      : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText: AppLocalizations.of(context)
                          .translate("loginTextPassword"),
                      border: const OutlineInputBorder()),
                ),
              ),
              authProvider.status == Status.registering
                  ? const Center(
                  child: CircularProgressIndicator()
              )
                  : ElevatedButton(
                  onPressed: () async {
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

                  },
                  child: const Text("로그인")
              ),
              const SizedBox(
                height: 5.0,
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context)
                        .pushNamed(Routes.signUp);
                  },
                  child: Text(AppLocalizations.of(context).translate("signUp"))
              )
            ],
          ),
        ),
      ),
    );
  }
}