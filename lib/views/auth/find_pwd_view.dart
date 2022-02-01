import 'package:flutter/material.dart';
import 'package:myref/app_localizations.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/utils/reg_exp_util.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

class FindPwdView extends StatefulWidget {
  const FindPwdView({Key? key}) : super(key: key);

  @override
  _FindPwdViewState createState() => _FindPwdViewState();
}

class _FindPwdViewState extends State<FindPwdView> {

  late TextEditingController _emailController;
  late String _errorEmailMsg;

  // 메일전송 버튼 활성화 여부
  late bool _isAbleSend;
  // 이메일 에러텍스트 노출 여부
  late bool _isEmailError;

  late ButtonState _btnState;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _errorEmailMsg = "";
    _isAbleSend = false;
    _isEmailError = false;
    _btnState = ButtonState.fail;
    _isAbleSend = false;
  }

  void _ableSend(bool isAble){
    setState(() {
      isAble
          ?
          _btnState = ButtonState.idle
          :
          _btnState = ButtonState.fail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            // TODO 휴대폰번호로 이메일 찾기
            title: Text(
              AppLocalizations.of(context).translate("findPwdTitle"),
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.chevron_left_outlined,
                color: Colors.black,
                size: 35.0
              ),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: _buildForm(context)
              )
            ],
          )
        )
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate("findPwdEmailLabel"),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                onChanged: (_) {
                  if( _emailController.text.isEmpty ){
                    _ableSend(false);
                  }else{
                    _ableSend(true);
                  }
                },
                validator: (value) {
                  if( value!.isEmpty ) {
                    return AppLocalizations.of(context).translate("findPwdTextErrorEmail");
                  }
                  else if( !RegExpUtil.isEmail(value) ){
                    return AppLocalizations.of(context).translate("findPwdTextRegExpErrorEmail");
                  }
                  else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate("findPwdTextEmail"),
                    errorText: _isEmailError
                        ? _errorEmailMsg
                        : null,
                    border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20.0),
              // 이메일 전송 중
              authProvider.status == Status.registering
                ? ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: () {},
                    state: ButtonState.loading,
                  )
                :
              // 이메일 전송 완료
              authProvider.status == Status.registered
                ? ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: () {},
                    state: ButtonState.success,
                  )
                : ProgressButton(
                    stateWidgets: btnState(context),
                    stateColors: btnColor(context),
                    onPressed: () async {
                      setState(() {
                        _isEmailError = false;
                      });
                      if( _btnState == ButtonState.idle ) {
                        if( _formKey.currentState!.validate() ) {
                          try{
                            await authProvider.sendPasswordResetEmail(_emailController.text);
                          }catch( e ) {
                            _errorEmailMsg = e.toString();
                            if( _errorEmailMsg.contains("user-not-found") ) {
                              _errorEmailMsg = AppLocalizations.of(context).translate("user-not-found");
                            }else {
                              _errorEmailMsg = AppLocalizations.of(context).translate("unknownError");
                            }
                            setState(() {
                              _isEmailError = true;
                            });
                          }
                        }
                      }
                    },
                    state: _btnState,
                  )
            ],
          ),
        )
      )
    );
  }
}

Map<ButtonState, Widget> btnState(BuildContext context) {
  return {
    ButtonState.fail: Text(
      AppLocalizations.of(context).translate("findPwdSendLink"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ), // 비활성버튼
    ButtonState.idle: Text(
      AppLocalizations.of(context).translate("findPwdSendLink"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.loading: Text(
      AppLocalizations.of(context).translate("findPwdLoading"),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonState.success: Text(
      AppLocalizations.of(context).translate("findPwdSuccess"),
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
