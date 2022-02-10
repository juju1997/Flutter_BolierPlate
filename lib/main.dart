import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:myref/providers/lang_provider.dart';
import 'package:myref/providers/auth_provider.dart';
import 'package:myref/services/firestore_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:myref/my_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // 화면 회전 방지
  SystemChrome.setPreferredOrientations( [DeviceOrientation.portraitUp] )
    .then((_) async {

    // runApp(const MyApp());
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<LanguageProvider>(
              create: (context) => LanguageProvider()
          ),
          ChangeNotifierProvider<AuthProvider>(
              create: (context) => AuthProvider()
          )
        ],
        child: MyApp(
          databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
          key: const Key('myRef'),
        ),
      )
    );

  });

}

