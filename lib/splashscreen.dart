import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kbops/dashboard_screens/bottom_nav.dart';
import 'package:kbops/loginscreen.dart';
import 'package:kbops/sharedpref.dart';
import 'package:kbops/state_management/user_info_provider.dart';
import 'package:kbops/state_management/vote_now_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // basicStatusCheck(NewVersion newVersion) {
  //   newVersion.showAlertIfNecessary(context: context);
  // }

  // advancedStatusCheck(NewVersion newVersion) async {
  //   final status = await newVersion.getVersionStatus();
  //   if (status != null) {
  //     debugPrint(status.releaseNotes);
  //     debugPrint(status.appStoreLink);
  //     debugPrint(status.localVersion);
  //     debugPrint(status.storeVersion);
  //     debugPrint(status.canUpdate.toString());
  //     newVersion.showUpdateDialog(
  //       context: context,
  //       versionStatus: status,
  //       dialogTitle: 'New Update Available',
  //       dialogText: 'Let\'s Update',
  //     );
  //   }
  // }
  @override
  void initState() {
    super.initState();

    //  final newVersion = NewVersion(androidId: "com.snapchat.android");
    //   const simpleBehavior = true;
    //   if (simpleBehavior) {
    //     basicStatusCheck(newVersion);
    //     // ignore: dead_code
    //   } else {
    //     advancedStatusCheck(newVersion);
    //   }
    // splashNavigator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashNavigator();
      // Provider.of<VoteNowProvider>(context, listen: false).getData();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<UserProvider>(context, listen: false).getUserData();
    // });

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await Provider.of<VoteNowProvider>(context, listen: false).fetchDate();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset("images/kBOPS Mobile icon.png"),
          ),
        ));
  }

  splashNavigator() async {
    final result = await checkLogin();
    if (FirebaseAuth.instance.currentUser != null && result) {
      Timer(const Duration(seconds: 2), () {
        Provider.of<UserProvider>(context, listen: false).getUserInfo();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => BottomNav()));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      });
    }
  }
}
