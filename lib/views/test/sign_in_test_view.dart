import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myref/views/components/round_btn.dart';

class SignInTestView extends StatefulWidget {
  const SignInTestView({Key? key}) : super(key: key);

  @override
  _SignInTestViewState createState() => _SignInTestViewState();
}

class _SignInTestViewState extends State<SignInTestView> {

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xFFFFF9EC),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Center(
                    child: SizedBox(
                        width: 175,
                        height: 175,
                        child: /*SvgPicture.asset('images/login.svg')*/ FlutterLogo()
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                    child: Text('Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('로그인 후에 이용할 수 있어요!.',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                            style: (TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            )),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            obscureText: false,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFF9BE7C), width: 4.0),
                                  borderRadius:BorderRadius.circular(10.0)
                              ),
                              border: UnderlineInputBorder(
                                  borderRadius:BorderRadius.circular(10.0)
                              ),
                              fillColor: Color(0xFFFFF9EC),
                              filled: true,
                              //prefixIcon: Image.asset('images/icon_email.png'),
                              /*focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),*/
                            ),
                            /*onChanged: (value) {
                              email = value;
                            },*/
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: (TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          )),
                          obscureText: true,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFF9BE7C), width: 4.0),
                                borderRadius:BorderRadius.circular(10.0)
                            ),
                            border: UnderlineInputBorder(
                                borderRadius:BorderRadius.circular(10.0)
                            ),
                            fillColor: Color(0xFFFFF9EC),
                            filled: true,
                            //prefixIcon: Image.asset('images/icon_email.png'),
                            /*focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),*/
                          ),
                          /*onChanged: (value) {
                            password = value;
                          },*/
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: RoundButton(
                        btnText: 'LOGIN',
                        color: Color(0xFFF9BE7C),
                        onPressed: () async {/*
                          // Add login code
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SuccessScreen()));
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            print(e);
                          }*/
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Text('Forgot Password?',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dont have an account?',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400
                        ),),
                      FlatButton(
                        onPressed: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccount()));*/
                        },
                        child: Text('Sign up',
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
        )
    );
  }
}
