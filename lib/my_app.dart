import 'package:flutter/material.dart';
import 'package:myref/constants/app_font_family.dart';
import 'package:myref/services/firestore_database.dart';
import 'package:myref/routes.dart';
import 'package:myref/views/splash/splash_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myref/providers/lang_provider.dart';
import 'package:myref/providers/network_provider.dart';
import 'package:myref/app_localizations.dart';
import 'package:provider/provider.dart';

import 'auth_widget_builder.dart';
import 'models/user_model.dart';


class MyApp extends StatelessWidget {
  const MyApp({required Key key, required this.databaseBuilder})
      : super(key: key);

  final FirestoreDatabase Function(BuildContext context, String uid)
  databaseBuilder;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (_, languageProviderRef, __) {
          return AuthWidgetBuilder(
            key: const Key('authWidget'),
            databaseBuilder: databaseBuilder,
            builder: (BuildContext context,
                AsyncSnapshot<UserModel> userSnapshot) {
              return Consumer<NetworkProvider>(
                builder: (_, networkProviderRef, __) {
                  return MaterialApp(
                    locale: languageProviderRef.appLocale,
                    //List of all supported locales
                    supportedLocales: const [
                      Locale('ko', 'KO'),
                      Locale('en', 'EN'),
                    ],
                    //These delegates make sure that the localization data for the proper language is loaded
                    localizationsDelegates: const [
                      //A class which loads the translations from JSON files
                      AppLocalizations.delegate,
                      //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                      GlobalMaterialLocalizations.delegate,
                      //Built-in localization for text direction LTR/RTL
                      GlobalWidgetsLocalizations.delegate,
                      // IOS ISSUE
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    //return a locale which will be used by the app
                    localeResolutionCallback: (locale, supportedLocales) {
                      //check if the current device locale is supported or not
                      for (var supportedLocale in supportedLocales) {
                        if (supportedLocale.languageCode ==
                            locale?.languageCode ||
                            supportedLocale.countryCode ==
                                locale?.countryCode) {
                          return supportedLocale;
                        }
                      }
                      //if the locale from the mobile device is not supported yet,
                      //user the first one from the list (in our case, that will be English)
                      return supportedLocales.first;
                    },
                    title: 'MyRef APP',
                    routes: Routes.routes,
                    theme: ThemeData(
                      fontFamily: AppFontFamily.nsRegular,
                    ),
                    home: const SplashView(),
                  );
                }
              );
            },
          );
        }
    );
  }
}