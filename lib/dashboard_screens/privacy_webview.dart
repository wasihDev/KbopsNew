import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key? key, required this.kbopsPrivacyPolicy}) : super(key: key);
  String kbopsPrivacyPolicy;
  @override
  PrivacyPolicyState createState() => PrivacyPolicyState(kbopsPrivacyPolicy);
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
  PrivacyPolicyState(this.kbopsPrivacyPolicy);
  String kbopsPrivacyPolicy;
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 198, 37, 65),
          centerTitle: true,
          title: Text("Privacy Policy"),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                child: Center(
                    child: WebView(
                  initialUrl: '${kbopsPrivacyPolicy}',
                  gestureRecognizers: Set()
                    ..add(Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer())),
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageStarted: (value) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onPageFinished: (value) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                )),
              ),
              isLoading
                  ? Container(
                      color: Colors.white10,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(196, 38, 64, 1),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
