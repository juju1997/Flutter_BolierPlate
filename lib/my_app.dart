import 'package:flutter/material.dart';

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Testing View",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TESTING'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('MyApp Testing..'
                        ,style: TextStyle(
                  fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
///
/// http://sherlock-holmes.co.kr/reservation/index.php?sido=1&bno=35&s_sido=1&s_no=35 21시20분
/// http://murderparker.com/ 파커4 20시50분
///
///
}