import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/constants/app_colors.dart';
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
        backgroundColor: AppColors.backGround,
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
                                style: const TextStyle(
                                    color: AppColors.emailText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).translate("findPwdTo"),
                                style: const TextStyle(
                                    color: AppColors.textBlack,
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
                        AppLocalizations.of(context).translate("findPwdResult"),
                        style: const TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 20
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 20,),
                Center(
                    child: RoundButton(
                        color: AppColors.authBtnActive,
                        btnText: AppLocalizations.of(context).translate("findPwdToSignIn"),
                        onPressed: (){
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.signIn,
                                  (r) => false);
                        }
                    )
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate("findPwdFail"),
                      style: const TextStyle(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).translate("reSendPwd"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack)
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
