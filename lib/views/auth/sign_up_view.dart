import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myref/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:myref/models/user_model.dart';
import 'dart:convert';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  late TextEditingController _emailController;
  late TextEditingController _idController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _idController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
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
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
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
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: "아이디",
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
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "이메일",
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () async {


                  print(_idController.text);
                  print(_passwordController.text);
                  print(_emailController.text);

                  List<int> bytes = utf8.encode(_passwordController.text);
                  Digest digest = sha256.convert(bytes);
                  String pwd = digest.toString();


                  // var r = await testRef.doc('testDoc').get();
                  // Test rt = r.data() as Test;
                  // print(rt.toJson());

                  /**
                   * 실험중
                   * */

                  UserModel user = UserModel(
                    id: _idController.text,
                    pwd: pwd,
                    email: _emailController.text
                  );

                  /// --회원가입
                  /*FirebaseFirestore.instance.collection('users').doc(user.id).set({
                    "id": user.id,
                    "pwd": user.pwd,
                    "email": user.email
                  });*/

                  /// --회원가입 ID 중복 검사 !!진행중!!
                  final userSnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .withConverter(
                          fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
                          toFirestore: (users, _) => (users as UserModel).toJson())
                      .doc(user.id).get();
                  print(userSnapshot);
                  bool isAuth = false;




                  /*FirebaseFirestore.instance.collection("users").doc(_idController.text).collection("myRef").doc("test").set({
                    "ref":"test"
                  });*/

                },
                child: const Text('회원가입'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

