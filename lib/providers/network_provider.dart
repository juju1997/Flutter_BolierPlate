import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkProvider extends ChangeNotifier {

  NetworkProvider() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      resultHandler(result);
    });
  }

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  String _svgUrl = 'network none img';
  String _pageText ='network none msg';

  ConnectivityResult get connectivity => _connectivityResult;
  String get svgUrl => _svgUrl;
  String get pageText => _pageText;

  void resultHandler(ConnectivityResult result) {
    _connectivityResult = result;

    print( 'Network Status -->  ' + _connectivityResult.toString());

    if (result == ConnectivityResult.none) {
      _svgUrl = 'network none img';
      _pageText = 'network none msg';
    } else if (result == ConnectivityResult.mobile) {
      _svgUrl = 'network mobile img';
      _pageText = 'network mobile msg';
    } else if (result == ConnectivityResult.wifi) {
      _svgUrl = 'network wifi img';
      _pageText = 'network wifi msg';
    }
    notifyListeners();
  }

  void initialLoad() async {
    ConnectivityResult connectivityResult = (await (Connectivity().checkConnectivity()));
    resultHandler(connectivityResult);
  }
}
