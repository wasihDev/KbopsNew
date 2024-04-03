import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AccountWithdrawal extends StatefulWidget {
  AccountWithdrawal({Key? key, required this.ppopwithdrawal}) : super(key: key);
  String ppopwithdrawal;
  @override
  AccountWithdrawalState createState() =>
      AccountWithdrawalState(ppopwithdrawal);
}

class AccountWithdrawalState extends State<AccountWithdrawal> {
  AccountWithdrawalState(this.ppopwithdrawal);
  String ppopwithdrawal;
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    //if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 196, 38, 64),
          centerTitle: true,
          title: Text("Account Withdrawal"),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                child: Center(
                    child: WebView(
                  initialUrl: '${ppopwithdrawal}',
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
