import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper extends ChangeNotifier {
  Future<SharedPreferences>? _sharedPreference;

  static const String language_code = "language_code";
  static const String is_dark_mode = "is_dark_mode";

  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  //Theme (white, dark)
  Future<bool> get isDarkMode {
    return _sharedPreference!.then((prefs) {
      return prefs.getBool(is_dark_mode) ?? false;
    });
  }

  Future<void> changeTheme(bool value) {
    return _sharedPreference!.then((prefs) {
      return prefs.setBool(is_dark_mode, value);
    });
  }

  //Locale (ko, en)
  Future<String>? get appLocale {
    return _sharedPreference?.then((prefs) {
      return prefs.getString(language_code) ?? 'ko';
    });
  }
  Future<void> changeLanguage(String value) {
    return _sharedPreference!.then((prefs) {
      return prefs.setString(language_code, value);
    });
  }

}

