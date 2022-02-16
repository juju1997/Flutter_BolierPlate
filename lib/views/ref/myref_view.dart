import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myref/constants/app_colors.dart';
import 'package:myref/services/firestore_database.dart';
import 'package:provider/provider.dart';

class MyRefView extends StatefulWidget {
  const MyRefView({Key? key}) : super(key: key);

  @override
  _MyRefViewState createState() => _MyRefViewState();
}

class _MyRefViewState extends State<MyRefView> {

  late bool _showSpinner;

  @override
  void initState() {
    _showSpinner = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    return Form(
      child: ModalProgressHUD(
        opacity: 0.4,
        progressIndicator: const SpinKitThreeInOut(
          size: 35.0,
          color: AppColors.spinKit,
        ),
        inAsyncCall: _showSpinner,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.backGround,
          ),
          backgroundColor: AppColors.backGround,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('dd'),
                TextButton(
                    onPressed: (){
                      try{
                        firestoreDatabase.setUserDoc('test_uid');
                      }catch(e){
                        print(e);
                      }

                    },
                    child: const Text('document insert test')
                )
              ],
            ),
          ),
          ),
        ),
      );
  }
  
}
