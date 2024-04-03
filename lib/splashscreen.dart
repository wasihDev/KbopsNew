import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kbops/dashboard_screens/bottom_nav.dart';
import 'package:kbops/loginscreen.dart';
import 'package:kbops/sharedpref.dart';

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
    splashNavigator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashNavigator();
    });
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
