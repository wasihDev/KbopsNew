import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kbops/state_management/event_provider.dart';
import 'package:kbops/state_management/user_info_provider.dart';
import 'package:kbops/splashscreen.dart';
import 'package:kbops/state_management/vote_screen_provider.dart';
import 'package:provider/provider.dart';

import 'state_management/vote_now_provider.dart';

List<String> testDeviceIds = ['289C....E6'];

Future<void> backgroundHandler(RemoteMessage message) async {}

// Platform messages are asynchronous, so we initialize in an async method.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // FirebaseAdMob.instance.initialize(appId: 'your_admob_app_id');

  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  await Firebase.initializeApp();

  // UnityMediation.initialize(
  //   gameId: Platform.isIOS ? '4789842' : '4789843',
  //   onComplete: () => print('Initialization Complete'),
  //   onFailed: (error, message) =>
  //       print('Initialization Failed: $error $message'),
  // );

  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VoteNowProvider()),
        ChangeNotifierProvider(create: (context) => VoteScreenProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => EventsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'kBOPS',
        theme: ThemeData(
            primaryColor: const Color.fromRGBO(196, 38, 64, 1),
            primaryColorLight: const Color.fromRGBO(196, 38, 64, 1),
            primaryColorDark: const Color.fromRGBO(196, 38, 64, 1),
            fontFamily: 'BeVietnamPro'),
        home: const SplashScreen(),
      ),
    );
  }
}
