import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbops/dashboard_screens/faq.dart';
import 'package:kbops/dashboard_screens/support.dart';
import 'package:kbops/state_management/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:unity_mediation/unity_mediation.dart';
import 'KPointsHistory.dart';
import 'about_screen.dart';
import 'account_withdrawl.dart';
import 'edit_profile.dart';
import 'dart:io' show Platform;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var pointsLoading = true;
  //late NativeAd _ad;
  bool isLoaded = false;
  var kbopsFaq = "";
  var kbopsNotice = '';
  var kbopsPrivacyPolicy = '';
  var kbopsSupport = '';
  var kbopsTos = '';

  //void loadNativeAd() {
  //try {
  // _ad = NativeAd(
  //   adUnitId: 'ca-app-pub-4031621145325255/2507500493',
  //  factoryId: 'listTile',
  //  listener: NativeAdListener(onAdLoaded: (ad) {
  //    print("loaded");
  //   setState(() {
  //     isLoaded = true;
  //   });
  //  }, onAdFailedToLoad: (ad, error) {
  //  print("ad failed to load $error");
  //   try{
  //    ad.dispose();

  // }catch(error1){
  //  print(error1);
  // }
  // }),
  //request: const AdRequest(),
  // );
  //  _ad.load();
  // }catch(error){
  //  print(error);
  //}
  // }

  Future<void> getWebView() async {
    final collectionRef = FirebaseFirestore.instance.collection('webviewlinks');
    final docs = await collectionRef.doc('c26Ice5IaicD2rjJXWR6').get();
    kbopsFaq = docs.get('kbopsFaq');
    kbopsNotice = docs.get('kbopsNotice');
    kbopsPrivacyPolicy = docs.get('kbopsPrivacyPolicy');
    kbopsSupport = docs.get('kbopsSupport');
    kbopsTos = docs.get('kbopsTos');
    ppopwithdrawal = docs.get('kbopswithdrawal');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //loadNativeAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserInfo();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getUserInfo();
      getWebView();
      initUnityMediation();
    });
  }

  bool _showBanner = false;
  bool _rewardedAdloaded = false;
  bool _interstitialAdloaded = false;

  Future<void> initUnityMediation() async {
    UnityMediation.initialize(
      gameId: Platform.isIOS ? '4789842' : '4789843',
      onComplete: () {
        print('Initialization Complete');
        loadAds();
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  void loadAds() {
    loadRewardedAd();
    loadInterstitialAd();
  }

  void loadRewardedAd() {
    setState(() {
      _rewardedAdloaded = false;
    });
    UnityMediation.loadRewardedAd(
      adUnitId: Platform.isIOS ? 'Rewarded_iOS' : 'Rewarded_Android',
      onComplete: (adUnitId) {
        print('Rewarded Ad Load Complete $adUnitId');
        setState(() {
          _rewardedAdloaded = true;
        });
      },
      onFailed: (adUnitId, error, message) =>
          print('Rewarded Ad Load Failed $adUnitId: $error $message'),
    );
  }

  void loadInterstitialAd() {
    log('reach');
    setState(() {
      _interstitialAdloaded = false;
    });
    UnityMediation.loadInterstitialAd(
      adUnitId: Platform.isIOS ? 'Interstital_Ios' : 'Intersitial_android',
      onComplete: (adUnitId) {
        log('===>>>Interstitial Ad Load Complete $adUnitId');
        setState(() {
          _interstitialAdloaded = true;
        });
      },
      onFailed: (adUnitId, error, message) => log(
          '=-=---=->>Interstitial Ad Load Failed $adUnitId: $error $message'),
    );
  }

  var ppopwithdrawal = '';
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 196, 38, 64),
        title: Row(
          children: [
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  "${userProvider.userInfo?.TotalKPoints ?? 0}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'images/Heart Voting.png',
                  height: 30,
                  width: 30,
                ),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(userProvider
                            .userInfo?.UserImage ??
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.userInfo?.Username ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userProvider.userInfo?.Email ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        (userProvider.userInfo?.MyReferralCode ?? ""),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              const Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () async {
                  final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditProfile(
                                userinfo: userProvider.userInfo,
                              )));
                  Provider.of<UserProvider>(context, listen: false)
                      .getUserInfo();
                  setState(() {});
                },
                child: const ListTile(
                  leading: Text(
                    '☑︎Edit Profile →',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              KPointsHistory(userinfo: userProvider.userInfo)));
                },
                child: const ListTile(
                  leading: Text(
                    'KPoints History →',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              const Divider(
                thickness: 2,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AccountWithdrawal(
                                ppopwithdrawal: ppopwithdrawal.toString(),
                              )));
                },
                child: const ListTile(
                  leading: Text('Account Deletion Request →',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              const Divider(
                thickness: 2,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                //   child: isLoaded
                // ? AdWidget(ad: _ad)
                //: Center(
                //    child: Container(
                // color: Colors.grey[200],
                //   child: null,
                // )),
              ),
              //  const Divider(
              //  thickness: 2,
              //  ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FAQ(
                                kbopsFaq: kbopsFaq.toString(),
                              )));
                },
                child: const ListTile(
                  leading: Text(
                    'FAQ →',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              // const Divider(
              //   thickness: 2,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (_) => Notice(
              //                   kbopsNotice: kbopsNotice,
              //                 )));
              //   },
              //   child: const ListTile(
              //     leading: Text(
              //       'Calendar & Events →',
              //       style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              //     ),
              //     trailing: Icon(Icons.navigate_next),
              //   ),
              // ),
              const Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Support(
                                kbopsSupport: kbopsSupport.toString(),
                              )));
                },
                child: const ListTile(
                  leading: Text(
                    'Customer Service →',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => About(
                                SendtoPriveacyPolicy:
                                    kbopsPrivacyPolicy.toString(),
                                SendtoTOS: kbopsTos.toString(),
                              )));
                },
                child: const ListTile(
                  leading: Text(
                    'About Us →',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
