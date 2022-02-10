import 'package:flutter/material.dart';
import 'package:myref/models/screen_arguments.dart';
import 'package:myref/views/components/round_btn.dart';
import 'package:myref/routes.dart';

class FindPwdSendView extends StatefulWidget {
  const FindPwdSendView({Key? key}) : super(key: key);

  @override
  _FindPwdSendViewState createState() => _FindPwdSendViewState();
}

class _FindPwdSendViewState extends State<FindPwdSendView> {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Form(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFFFF9EC),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.width * 0.40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(

                    child: SizedBox(
                      child: Image.asset('assets/images/link_email.png'),
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                args.message,
                                style: TextStyle(
                                    color: Color(0xFFE39666),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                ' 로',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20
                                ),
                              ),
                            ]
                        )
                    )
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '비밀번호 재설정 링크를 보내드렸어요.',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                      ),
                    )
                ),
                SizedBox(height: 20,),
                Center(
                    child: RoundButton(
                        color: Color(0xFFF9BE7C),
                        btnText: '로그인하기',
                        onPressed: (){
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.signIn,
                                  (r) => false);
                        }
                    )
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '이메일이 오지 않았나요?',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text('다시보내기',
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
}
