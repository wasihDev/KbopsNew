import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kbops/dashboard_screens/website.dart';
import 'package:kbops/image_docs.dart';
import 'package:kbops/models/userdata.dart';
import 'package:kbops/state_management/user_info_provider.dart';
import 'package:kbops/state_management/vote_now_provider.dart';
import 'package:kbops/vote_screens/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:twitter_login/entity/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  Future<void> likeOrUnlikeImage({
    required String docId,
    required List<String> users,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('userImages')
          .doc(docId)
          .update({'likedBy': users}).then((value) {
        if (mounted) {
          setState(() {
            users.insert(0, docId);
          });
        }
      });
    } catch (e) {
      //TODO: Error handling
      print(e.toString());
    }
  }

  Future<void> commentsLikes(
      {required String dcId, required List<String> userIdLikeOne}) async {
    try {
      await FirebaseFirestore.instance
          .collection('communityComment')
          .doc(dcId)
          .update({'likedBy': userIdLikeOne});
    } catch (e) {
      print(e);
    }
  }

  // Future<void> getUserInfo() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   String userid = auth.currentUser!.uid.toString();
  //   final collectionRef = FirebaseFirestore.instance.collection('users');
  //   final docs = await collectionRef.doc(userid).get();
  //   userInfo = Userinfo.fromMap(docs);
  //   //  pointsLoading = false;
  //   if (mounted) setState(() {});
  // }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  void _onRefresh() async {
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  bool isLiked = false;
  Future<void> getImages2() async {
    log('Get Images');
    if (mounted)
      setState(() {
        isImagesLoading = true;
      });

    final snapshots = await FirebaseFirestore.instance
        .collection('userImages')
        .orderBy('uploadTime', descending: true)
        .get();
    images = snapshots.docs
        .map((e) => FirebaseImageModel.fromJson(e.data()))
        .toList();
    //log('IMAGES:: ${images.length.toString()}');
    if (mounted)
      setState(() {
        isImagesLoading = false;
      });
  }

  bool gettingMoreProducts = false;
  bool moreProductsAvailable = true;

  bool isImagesLoading = false;
  bool isLoading = true;
  List<FirebaseImageModel> images = List.empty(growable: true);
// This function adds a new comment to Firestore
  Future<void> addComment(String text) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the current time
      DateTime now = DateTime.now();
      // Convert the time to a string
      String time = now.toString();
      // Add the comment to Firestore
      int data = 0;
      await FirebaseFirestore.instance.collection('communityComment').add({
        'text': text,
        'userId': user.uid,
        'userName': user.displayName,
        'profileImage': user.photoURL ?? "",
        'time': time,
        'likes': 0,
      });
      log("TIme :: ${time.toString()}");
    }
  }

  // Future<void>? userProviders;
  UserProvider? userProvider;
  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  EventsInfo? eventsInfo;
  Userinfo? userinfo;

  Storage storage = Storage();
  int itemCount = 0;
  List<dynamic> likedBy = List.empty(growable: true);
  bool iscomment = false;
  // Userinfo? userInfo;
  // @override
  // void dispose() {
  //   // userProvider!.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    // Userinfo? userInfo;
    // getitemCount();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userProvider?.getUserInfo();
      await getImages2();

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // userProvider.getUserInfo();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<UserProvider>(context, listen: false).getUserInfo();
    // });
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 198, 37, 65),
            centerTitle: true,
            title: Image.asset(
              'images/kBOPS Top Logo.png',
              height: 95,
              width: 100,
              fit: BoxFit.fill,
              scale: 30 / 8,
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Center(
                      child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controllerCompleter.future
                          .then((value) => _controller = value);
                      _controllerCompleter.complete(webViewController);
                    },
                    initialUrl: 'https://main.kbops.online',
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
                  )),
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
