import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FAQ extends StatefulWidget {
  FAQ({Key? key, required this.kbopsFaq}) : super(key: key);
  String kbopsFaq;
  @override
  FAQState createState() => FAQState(kbopsFaq);
}

class FAQState extends State<FAQ> {
  FAQState(this.kbopsFaq);
  String kbopsFaq;
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
          title: Text("FAQ"),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                child: Center(
                    child: WebView(
                  initialUrl: '${kbopsFaq}',
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
                        child: const CircularProgressIndicator(
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
