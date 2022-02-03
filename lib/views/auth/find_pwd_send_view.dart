import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/models/screen_arguments.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/routes.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

class FindPwdSendView extends StatefulWidget {
  const FindPwdSendView({Key? key}) : super(key: key);

  @override
  _FindPwdSendViewState createState() => _FindPwdSendViewState();
}

class _FindPwdSendViewState extends State<FindPwdSendView> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate("findPwdTitle"),
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(Routes.signIn, (r) => false);
                },
                icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 35.0,
                )
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: _buildForm(context),
            )
          ],
        )
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Form(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const FlutterLogo(size: 128.0),
              Text(
                  args.message +
                "\n비밀번호 링크 발송 완료"
              ),
              const SizedBox(height: 30.0,),
              ProgressButton(
                  stateWidgets: btnState(context),
                  stateColors: btnColor(context),
                  state: ButtonState.idle,
                  onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(Routes.signIn, (r) => false);
                  },
              )
            ],
          )
        ),
      ),
    );
  }
}


Map<ButtonState, Widget> btnState(BuildContext context) {
  return {
    ButtonState.idle: Text(
      AppLocalizations.of(context).translate("findPwdGoToSignIn"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.fail: Text(
      AppLocalizations.of(context).translate(""),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.loading: Text(
      AppLocalizations.of(context).translate(""),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.success: Text(
      AppLocalizations.of(context).translate(""),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    )
  };
}
Map<ButtonState, Color> btnColor(BuildContext context) {
  return {
    ButtonState.fail: Colors.grey.shade300,  // 버튼 비활성 상태
    ButtonState.idle: Colors.blue.shade300,
    ButtonState.loading: Colors.blue.shade300,
    ButtonState.success: Colors.green.shade400,
  };
}