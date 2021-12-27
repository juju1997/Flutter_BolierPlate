import 'package:flutter/material.dart';
import 'package:myref/sharedPref/shared_preference_helper.dart';

class LanguageProvider extends ChangeNotifier {
  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;

  Locale _appLocale = const Locale('ko');

  LanguageProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
  }

  Locale get appLocale {
    _sharedPrefsHelper.appLocale?.then((localeValue) {
      _appLocale = Locale(localeValue);
    });

    return _appLocale;
  }

  void updateLanguage(String languageCode) {
    if (languageCode == "ko") {
      _appLocale = const Locale("ko");
    } else {
      _appLocale = const Locale("en");
    }

    _sharedPrefsHelper.changeLanguage(languageCode);
    notifyListeners();
  }
}

