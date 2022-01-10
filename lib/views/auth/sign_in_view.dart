import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/routes.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

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
            _buildBackground(),
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

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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

           ElevatedButton(
                onPressed: (){
                  print(_emailController.text);
                  print(_passwordController.text);

                  List<int> bytes = utf8.encode(_passwordController.text);
                  var digest = sha256.convert(bytes);
                  print('sha256 is : $digest');
                  // 여기서 ID 와 PW를 체크하고 toast or pushReplacementNamed
                  // 유효성 검사 시, 하나만 출력되게
                  if(_formKey.currentState!.validate()){
                    FocusScope.of(context).unfocus();
                    
                    bool status = false;
                    
                    if(!status){
                      ScaffoldMessenger.of(context).showSnackBar(
                        // TODO 스낵바 꾸미기
                        SnackBar(content: const Text('로그인실패'))
                      );
                    }else{

                    }
                    
                  }
                },
                child: Text(AppLocalizations.of(context).translate("signIn"))
            ),
            const SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context)
                      .pushNamed(Routes.signUp);
                },
                child: Text(AppLocalizations.of(context).translate("easySignUp"))
            )


          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return ClipPath(
      clipper: SignInCustomClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

}

class SignInCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    var firstEndPoint = Offset(size.width / 2, size.height - 95);
    var firstControlPoint = Offset(size.width / 6, size.height * 0.45);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height / 2 - 50);
    var secondControlPoint = Offset(size.width, size.height + 15);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}