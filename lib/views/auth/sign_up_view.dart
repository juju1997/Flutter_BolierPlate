import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myref/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:myref/models/user_model.dart';
import 'package:myref/providers/auth_provider.dart';
import 'dart:convert';

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
                decoration: const InputDecoration(
                  labelText: "이메일",
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: "비밀번호",
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                controller: _passwordCheckController,
                decoration: const InputDecoration(
                    labelText: "비밀번호 확인",
                    border: OutlineInputBorder()
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
                  child: const Text("회원가입")
              ),



            ],
          ),
        ),
      ),
    );
  }
}

