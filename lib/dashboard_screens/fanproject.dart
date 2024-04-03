import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FanProject extends StatefulWidget {
  const FanProject({super.key});

  @override
  State<FanProject> createState() => _WebsiteState();
}

class _WebsiteState extends State<FanProject> {
  late WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    print('CHECKKKKK00--------------');
    // ViewLink();
  }

  String? viewLink;
  Future<String>? viewLinkFuture;
  bool isLoading = false;
  Future<String> getViewLink() async {
    var firebase = FirebaseFirestore.instance;
    final CollectionReference website = firebase.collection('fanproject');
    final DocumentSnapshot userSnapshot =
        await website.doc('fanprojectLink').get();
    return userSnapshot.get('links');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewLinkFuture = getViewLink();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 198, 37, 65),
              centerTitle: true,
              title: Text(
                'Fan Project Form',
                style: TextStyle(fontWeight: FontWeight.w700),
              )),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: FutureBuilder<String>(
                      future: viewLinkFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Display a loading indicator while fetching the link
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          // Handle error
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final viewLinks = snapshot.data;

                          return Center(
                              child: WebView(
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controllerCompleter.future
                                  .then((value) => _controller = value);
                              _controllerCompleter.complete(webViewController);
                            },
                            initialUrl: viewLinks,
                            gestureRecognizers: Set()
                              ..add(Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer())),
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
                          ));
                        }
                      }),
                ),
                isLoading
                    ? Container(
                        color: Colors.white10,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          )),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    }
    return Future.value(true);
  }
}
