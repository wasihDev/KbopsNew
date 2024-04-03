import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kbops/models/userdata.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Website extends StatefulWidget {
  const Website({super.key});

  @override
  State<Website> createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {
  late WebViewController _controller;
  Userinfo? userInfo;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    //ViewLink();
  }

  // late Future<String> viewLinkFuture;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print('s');
  //   ViewLink();
  // }

  String viewLink = '';
  // Future<String> ViewLink() async {
  //   var firebase = FirebaseFirestore.instance;
  //   final CollectionReference website = firebase.collection('website');
  //   final DocumentSnapshot userSnapshot =
  //       await website.doc('wesiteslink').get();
  //   String viewLinknew = userSnapshot.get('link');
  //   viewLink = viewLinknew;
  //   print('[------------------ $viewLink $viewLinknew');
  //   if (mounted) setState(() {});
  //   return viewLinknew;
  // }
  Future<String>? viewLinkFuture;

  Future<String> getViewLink() async {
    var firebase = FirebaseFirestore.instance;
    final CollectionReference website = firebase.collection('website');
    final DocumentSnapshot userSnapshot =
        await website.doc('wesiteslink').get();
    return userSnapshot.get('link');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewLinkFuture = getViewLink();
  }

  @override
  Widget build(BuildContext context) {
    print('----===---- $viewLink');
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 198, 37, 65),
              centerTitle: true,
              title: const Text(
                'Blogs & News',
                style: TextStyle(fontWeight: FontWeight.w700),
              )),
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: FutureBuilder<String>(
                      future: viewLinkFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Display a loading indicator while fetching the link
                          return const Center(
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
