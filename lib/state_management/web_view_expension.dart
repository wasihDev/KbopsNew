import 'package:flutter/material.dart';

class WebViewLoadingProvider extends ChangeNotifier {
  bool _webviewLoad = false;

  bool get webviewLoad => _webviewLoad;

  void setWebviewLoad(bool value) {
    _webviewLoad = value;
    notifyListeners();
  }
}
