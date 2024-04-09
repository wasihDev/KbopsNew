import 'dart:io';

import 'package:kbops/drawer.dart';
import 'package:provider/provider.dart';
import 'package:unity_mediation/unity_mediation.dart';
import 'dart:async';

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kbops/dashboard_screens/purchase_screen.dart';
import '../components.dart';
import '../gallery.dart';
import '../models/userdata.dart';
import '../state_management/user_info_provider.dart';
import '../utils/functions.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import 'KPointsHistory.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  var pointsLoading = true;
  // Userinfo? userinfos.userInfo;

  var pointsController = TextEditingController();

  bool castVote = false;

  // Future<void> getUserInfo() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   String userid = auth.currentUser!.uid.toString();
  //   final collectionRef = FirebaseFirestore.instance.collection('users');
  //   final docs = await collectionRef.doc(userid).get();
  //   userinfos.userInfo = Userinfo.fromMap(docs);
  //   pointsLoading = false;
  //   setState(() {});
  // }
  late UserProvider userinfos;
  void provier(BuildContext context) {
    userinfos = Provider.of<UserProvider>(context);
  }

  var isLoading = true;
  List<ExchangeKPoints> exchangeList = [];
  List<KPointsUsedHistoryModel> kPointsUsedList = [];
  List<KPointsUsedHistoryModel> kPointsChargedList = [];
  List<DocumentSnapshot> documentList = [];
  int _purchasedCount = 0;

  Future<void> getRedeemsItems({bool isRefresh = false}) async {
    var firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefEvents =
        firebase.collection('redeemItems');
    QuerySnapshot querySnapshotEvents = await collectionRefEvents.get();
    exchangeList.clear();
    for (var e in querySnapshotEvents.docs) {
      exchangeList.add(ExchangeKPoints.fromMap(e));
    }

    isLoading = false;
    setState(() {});
  }

  late RewardedAd rewardedAd;
  bool isAdLoaded = false;
  bool isAdLoaded2 = true;
  void resetDate() async {
    final res = await fetchDate();
    if (res['date'] != userinfos.userInfo!.AdsDate) {
      var firebase = FirebaseFirestore.instance;
      final CollectionReference collectionRefUser =
          firebase.collection('users');

      await collectionRefUser
          .doc(userinfos.userInfo!.UserID)
          .update({'adsDate': res['date'], 'ads': 0, 'ads2': 0})
          .then((value) => print("success"))
          .onError((error, stackTrace) => print(error));
      userinfos.getUserInfo();
    }
  }

  Future<bool> updateUserAds() async {
    var firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefUser = firebase.collection('users');

    await collectionRefUser
        .doc(userinfos.userInfo!.UserID)
        .update({
          'ads': (userinfos.userInfo?.Ads ?? 0) + 1,
          // 'ads2': (userinfos.userInfo?.Ads2 ?? 0) + 1,
          'totalkpoints': FieldValue.increment(3)
        })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    final CollectionReference collectionRefUsedHistory =
        firebase.collection('kPointsCharged');

    DateTime currentPhoneDate = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRefUsedHistory
        .doc(id)
        .set({
          'kPointsDate': FieldValue.serverTimestamp(),
          'kPointsId': id,
          'kPointsMethod': 'VideoRewards',
          'kPointsOption': '3 KPoints | Watch Video ADs  ',
          'kPointsValue': 3,
          'userId': "${userinfos.userInfo?.UserID}"
        })
        .then((value) => log("success"))
        .onError((error, stackTrace) => log(error.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" [✓] 3 KPoints for watching ADs.")));
    }

    userinfos.getUserInfo();
    return true;
  }

  Future<bool> updateUserAds2(BuildContext cxt) async {
    var firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefUser = firebase.collection('users');

    await collectionRefUser
        .doc(userinfos.userInfo!.UserID)
        .update({
          //'ads': (userinfos.userInfo?.Ads ?? 0) + 1,
          'ads2': (userinfos.userInfo?.Ads2 ?? 0) + 1,
          'totalkpoints': FieldValue.increment(3)
        })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    final CollectionReference collectionRefUsedHistory =
        firebase.collection('kPointsCharged');

    DateTime currentPhoneDate = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRefUsedHistory
        .doc(id)
        .set({
          'kPointsDate': FieldValue.serverTimestamp(),
          'kPointsId': id,
          'kPointsMethod': 'VideoRewards',
          'kPointsOption': '3 KPoints | Watch Video ADs  ',
          'kPointsValue': 3,
          'userId': "${userinfos.userInfo?.UserID}"
        })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" [✓] 3 KPoints for watching ADs.")));
    }
    userinfos.getUserInfo();
    return true;
  }

  // Future<void> initUnityMediation() async {
  //   UnityMediation.initialize(
  //     gameId: Platform.isIOS ? '4789842' : '4789843',
  //     onComplete: () {
  //       print('Initialization Complete');
  //       loadRewardedAd();
  //     },
  //     onFailed: (error, message) =>
  //         print('Initialization Failed: $error $message'),
  //   );
  // }
  bool _rewardedAdloaded = false;

  void initRewardAds() async {
    if ((userinfos.userInfo?.Ads)! < 25) {
      RewardedAd.load(
          adUnitId: 'ca-app-pub-4031621145325255/8345279014',
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('$ad loaded.');
              // Keep a reference to the ad so you can show it later.
              rewardedAd = ad;

              rewardedAd.show(onUserEarnedReward:
                  (AdWithoutView ad, RewardItem rewardItem) {
                // Reward the user for watching an ads
                print("=-===a=wd-=a-w=-da=-wd=a-wd=-a");
                print(rewardItem.type);
                print(rewardItem.amount);
              });

              rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (RewardedAd ad) =>
                    print('$ad onAdShowedFullScreenContent.'),
                onAdDismissedFullScreenContent: (RewardedAd ad) async {
                  print('$ad onAdDismissedFullScreenContent.');
                  await updateUserAds();

                  setState(() {
                    isAdLoaded = false;
                  });
                  ad.dispose();
                },
                onAdFailedToShowFullScreenContent:
                    (RewardedAd ad, AdError error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "You already watch the 25 ADs per account, please comeback again tomorrow.")));
                  print('$ad onAdFailedToShowFullScreenContent: $error');
                  setState(() {
                    isAdLoaded = false;
                  });
                  ad.dispose();
                },
                onAdImpression: (RewardedAd ad) =>
                    print('$ad impression occurred.'),
              );
            },
            onAdFailedToLoad: (LoadAdError error) {
              setState(() {
                isAdLoaded = false;
              });
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text(
              //         "You already watch the 20 ADs per account, please comeback again tomorrow")));
              print('RewardedAd failed to load: $error');

              // setState(() {
              //   isAdLoaded = false;
              // });
              // if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "[❌] ADs is not available at this time. \n\n Please wait for 1 minute to load new ADs. ")));
              //}
            },
          ));
    } else {
      log("${userinfos.userInfo?.Ads.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "You already watch the 25 ADs per account, please comeback again tomorrow.")));
      // if (mounted)
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //       content: Text(
      //           "[❌] ADs is not available at this time. \n\n» Please try again later. ")));
      setState(() {
        isAdLoaded = false;
      });
    }
  }

  // void loadRewardedAd() async {
  //   //  if ((userinfos.userInfo?.Ads2)! < 20) {
  //   log("${userinfos.userInfo?.Ads2.toString()}");
  //   setState(() {
  //     _rewardedAdloaded = false;
  //   });
  //   UnityMediation.loadRewardedAd(
  //       adUnitId: Platform.isIOS ? 'Rewarded_iOS' : 'Rewarded_Android',
  //       onComplete: (adUnitId) {
  //         log('Rewarded Ad Load Complete $adUnitId');
  //       },
  //       onFailed: (adUnitId, error, message) {
  //         log('Rewarded Ad Load Failed $adUnitId: $error $message');
  //         setState(() {
  //           _rewardedAdloaded = true;
  //         });
  //       });
  // }

  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _conectionSubscription;
  final List<String> _productLists = [
    // 'android.test.purchased',
    '100kpoints',
    '220kpoints',
    '550kpoints',
    '1080kpoints',
    '2100kpoints',
    // 'android.test.canceled',
  ];
  final List<String> _productIdIOS = [
    '100kpoints',
    '1080kpoints',
    '2100kpoints',
    '200kpoints',
    '550kpoints',
  ];
  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  Future<bool> addPurchasePoints(int points) async {
    setState(() {
      pointsLoading = true;
    });
    var firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefUser = firebase.collection('users');

    await collectionRefUser
        .doc(userinfos.userInfo!.UserID)
        .update({'totalkpoints': FieldValue.increment(points)})
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));

    final CollectionReference collectionRefUsedHistory =
        firebase.collection('kPointsCharged');

    DateTime currentPhoneDate = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRefUsedHistory
        .doc(id)
        .set({
          'kPointsDate': FieldValue.serverTimestamp(),
          'kPointsId': id,
          'kPointsMethod': 'Purchased KPoints',
          'kPointsOption': '${points} KPoints | Purchased KPoints',
          'kPointsValue': points,
          'userId': "${userinfos.userInfo?.UserID}"
        })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    userinfos.getUserInfo();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("[✔︎] ${points} KPoints added to your account.")));
    }
    return true;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = "";
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      await _getProduct();

      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      if (productItem!.productId == "100kpoints") {
        await addPurchasePoints(100);
      } else if (productItem.productId == "200kpoints") {
        await addPurchasePoints(220);
      } else if (productItem.productId == "550kpoints") {
        await addPurchasePoints(550);
      } else if (productItem.productId == "1080kpoints") {
        await addPurchasePoints(1080);
      } else if (productItem.productId == "2100kpoints") {
        await addPurchasePoints(2100);
      }

      print("Product ---- id");
      print("${productItem.productId}");
      print('purchase-updated: $productItem');
      await FlutterInappPurchase.instance.clearTransactionIOS();
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }

  void _requestPurchase(IAPItem item) async {
    log('reaschhhh11');
    try {
      FlutterInappPurchase purchased =
          await FlutterInappPurchase.instance.requestPurchase(item.productId!);
      log("======== purchased $purchased");
      //   await FlutterInappPurchase.instance.clearTransactionIOS();
      //urchased.clearTransactionIOS();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('error_in_requestPurhcase $e'),
          duration: const Duration(seconds: 2)));
    }
  }

  Future _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.instance
        .getProducts(Platform.isIOS ? _productIdIOS : _productLists);
    log(items.toString());
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      this._purchases = [];
    });
  }

  Future _getPurchases() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items!) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  // Future<void> initUnityMediation() async {
  //   UnityMediation.initialize(
  //     gameId: Platform.isIOS ? '4789842' : '4789843',
  //     onComplete: () {
  //       print('Initialization Complete');
  //       loadRewardedAd();
  //     },
  //     onFailed: (error, message) =>
  //         print('Initialization Failed: $error $message'),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  initUnityMediation();
      // userinfos.getUserInfo();
      _getProduct();
      getRedeemsItems();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    resetDate();
  }

  @override
  void dispose() {
    if (_conectionSubscription != null) {
      _conectionSubscription!.cancel();
      _conectionSubscription = null;
    }
    super.dispose();
  }

  String itemName = '';
  String itemId = '';
  int itemPoints = 0;
  var state = false;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    provier(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 196, 38, 64),
        title: Row(
          children: [
            const Text(
              "Store",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  "${userinfos.userInfo?.TotalKPoints ?? 0}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(width: 2),
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
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'images/Heart Voting.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Free KPoints',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: isAdLoaded == false
                      ? () {
                          setState(() {
                            isAdLoaded = true;
                          });

                          initRewardAds();
                        }
                      : null,
                  onDoubleTap: () {
                    log("double Click");
                    null;
                  },
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                            color: Color.fromRGBO(196, 38, 64, 1), width: 1.5)),
                    selected: true,
                    selectedTileColor: Colors.white,
                    title: const Text(
                      'Watch a video and get KPoints',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    subtitle: Text(
                        "View Ads: ${userinfos.userInfo?.Ads ?? 0}/25",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15)),
                    trailing: isAdLoaded == true
                        ? const CircularProgressIndicator(
                            color: Colors.red,
                          )
                        // const Text(
                        //   'loading...',
                        //   style: TextStyle(color: Colors.black),
                        // )
                        : Image.asset(
                            'images/ads-icon.png',
                            height: 65,
                            width: 65,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ),
                // SizedBox(height: 10),
                // InkWell(
                //   onTap: _rewardedAdloaded == falsex
                //       ? () {
                //           setState(() {
                //             _rewardedAdloaded = true;
                //           });
                //           if ((userinfos.userInfo?.Ads2)! < 20) {
                //             UnityMediation.showRewardedAd(
                //               adUnitId: Platform.isIOS
                //                   ? 'Rewarded_iOS'
                //                   : 'Rewarded_Android',
                //               onFailed: (adUnitId, error, message) {
                //                 setState(() {
                //                   _rewardedAdloaded = false;
                //                 });
                //                 ScaffoldMessenger.of(context).showSnackBar(
                //                     const SnackBar(
                //                         content: Text(
                //                             "[❌] ADs is not available at this time. \n\n» Please try again later.")));
                //                 print(
                //                     'Rewarded Ad $adUnitId failed: $error $message');
                //               },
                //               onStart: (adUnitId) =>
                //                   log('onStart: Rewarded Ad $adUnitId started'),
                //               onClick: (adUnitId) =>
                //                   log('onClick: Rewarded Ad $adUnitId click'),
                //               onRewarded: (adUnitId, reward) {
                //                 setState(() {
                //                   _rewardedAdloaded = false;
                //                 });
                //                 log('onRewarded: Rewarded Ad $adUnitId rewarded $reward');
                //               },
                //               onClosed: (adUnitId) async {
                //                 setState(() {
                //                   _rewardedAdloaded = false;
                //                 });
                //                 log('on Closed Rewarded Ad $adUnitId closed');
                //                 await updateUserAds2();
                //                // loadRewardedAd();
                //               },
                //             );
                //           } else {
                //             log("-==-=-=-=-=--=-${userinfos.userInfo?.Ads2.toString()}");
                //             // if (mounted) {

                //             // }
                //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //                 content: Text(
                //                     "You already watch the 20 ADs per account, please comeback again tomorrow.")));
                //             setState(() {
                //               _rewardedAdloaded = false;
                //             });
                //           }
                //           // setState(() {
                //           //   _rewardedAdloaded = false;
                //           // });
                //           //log('1');
                //           //  initRewardAds();
                //         }
                //       : null,
                //   onDoubleTap: null,
                //   child: ListTile(
                //     shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //         side: BorderSide(
                //             color: Color.fromRGBO(196, 38, 64, 1), width: 1.5)),
                //     selected: true,
                //     selectedTileColor: Colors.white,
                //     title: const Text(
                //       '[2] Watch a video and get KPoints',
                //       style: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.w400,
                //           fontSize: 15),
                //     ),
                //     subtitle: Text("View Ads: ${userinfos.userInfo?.Ads2 ?? 0}/20",
                //         style: const TextStyle(
                //             color: Colors.black,
                //             fontWeight: FontWeight.w400,
                //             fontSize: 15)),
                //     trailing: _rewardedAdloaded == true
                //         ? const CircularProgressIndicator(
                //             color: Colors.red,
                //           )

                //         //  Text(
                //         //     C,
                //         //     style: TextStyle(color: Colors.black),
                //         //   )

                //         : Image.asset(
                //             'images/ads-icon.png',
                //             height: 65,
                //             width: 65,
                //             fit: BoxFit.fitWidth,
                //           ),
                //   ),
                // ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'images/Heart Voting.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Purchase KPoints',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(1))),
                  child: _items.isNotEmpty
                      ? Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/${_items[0].productId}.png',
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _items[0]
                                        .productId
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 33,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 2, color: Colors.white),
                                        //border width and color

                                        primary: const Color.fromARGB(
                                            255, 196, 38, 64),
                                        //background color of button
                                        shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        _requestPurchase(_items[0]);
                                        log(_items[0]
                                            .introductoryPrice
                                            .toString());
                                      },
                                      child: Text(
                                        Platform.isIOS
                                            ? "${_items[0].currency} ${_items[0].price}"
                                            : "${_items[0].introductoryPrice}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/${_items[3].productId}.png',
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _items[3]
                                        .productId
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 33,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 2, color: Colors.white),
                                        //border width and color

                                        primary: const Color.fromARGB(
                                            255, 196, 38, 64),
                                        //background color of button
                                        shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        _requestPurchase(_items[3]);
                                      },
                                      child: Text(
                                        Platform.isIOS
                                            ? "${_items[3].currency} ${_items[3].price}"
                                            : "${_items[3].introductoryPrice}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/${_items[4].productId}.png',
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _items[4]
                                        .productId
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 33,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 2, color: Colors.white),
                                        //border width and color

                                        primary: const Color.fromARGB(
                                            255, 196, 38, 64),
                                        //background color of button
                                        shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        _requestPurchase(_items[4]);
                                      },
                                      child: Text(
                                        Platform.isIOS
                                            ? "${_items[4].currency} ${_items[4].price}"
                                            : "${_items[4].introductoryPrice}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/${_items[1].productId}.png',
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _items[1]
                                        .productId
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 33,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 2, color: Colors.white),
                                        //border width and color

                                        primary: const Color.fromARGB(
                                            255, 196, 38, 64),
                                        //background color of button
                                        shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        _requestPurchase(_items[1]);
                                      },
                                      child: Text(
                                        Platform.isIOS
                                            ? "${_items[1].currency} ${_items[1].price}"
                                            : "${_items[1].introductoryPrice}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                children: [
                                  Image.asset(
                                    // 'images/${_items[2].productId}.png',
                                    'images/2100kpoints.png',
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _items[2]
                                        .productId
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 33,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 2, color: Colors.white),
                                        //border width and color

                                        primary: const Color.fromARGB(
                                            255, 196, 38, 64),
                                        //background color of button
                                        shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        _requestPurchase(_items[2]);
                                      },
                                      child: Text(
                                        Platform.isIOS
                                            ? "${_items[2].currency} ${_items[2].price}"
                                            : "${_items[2].introductoryPrice}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: Text(
                            '\n » Please wait while loading. « \n',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),

                  // CircularProgressIndicator(color: Color.fromARGB(255, 218, 74, 84),))
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 2,
                ),
                // ListTile(
                //   leading: Image.asset(
                //     'images/exchange.png',
                //     height: 25,
                //     width: 25,
                //     fit: BoxFit.fill,
                //   ),
                //   title: const Text(
                //     'Exchange KPoints',
                //     style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                //   ),
                //   contentPadding: EdgeInsets.zero,
                // ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'images/exchange.png',
                      height: 25,
                      width: 25,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Exchange KPoints',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                    ),
                  ],
                ),

                const Divider(
                  thickness: 2,
                ),
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1))),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromRGBO(196, 38, 64, 1),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: exchangeList.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          child: Text(
                                            exchangeList[i]
                                                .RedeemItemName
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: 33,
                                          width: 100,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: Colors.black12),
                                              //border width and color

                                              primary: const Color.fromARGB(
                                                  255, 196, 38, 64),
                                              //background color of button
                                              shape: RoundedRectangleBorder(
                                                  //to set border radius to button
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              if (exchangeList[i]
                                                      .RedeemItemKPoints! <=
                                                  (userinfos.userInfo
                                                          ?.TotalKPoints ??
                                                      0)) {
                                                setState(() {
                                                  itemName = exchangeList[i]
                                                      .RedeemItemName
                                                      .toString();
                                                  itemId = exchangeList[i]
                                                      .RedeemID
                                                      .toString();
                                                  itemPoints = exchangeList[i]
                                                      .RedeemItemKPoints!
                                                      .toInt();
                                                  state = true;
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "[❌] You don't have enough KPoints to exchange."),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ));
                                              }
                                            },
                                            child: const Text(
                                              "Redeem",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            })),
                const Divider(thickness: 2),

                // const SizedBox(
                //   height: 5,
                // ),
                Consumer<UserProvider>(builder: (context, userProvider, child) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => KPointsHistory(
                                  userinfo: userProvider.userInfo)));
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      // leading: Image.asset(
                      //   'images/exchange.png',
                      //   height: 25,
                      //   width: 25,
                      //   fit: BoxFit.fill,
                      // ),
                      leading: const Text(
                        'KPoints History →',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  );
                }),
                const Divider(thickness: 2),
              ],
            ),
          ),
        ),
        Positioned(
          child: state
              ? Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 196, 38, 64),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Item: $itemName \n",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("KPoints Amount » $itemPoints",
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            !castVote
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              state = false;
                                            });
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "CANCEL",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(120, 38),
                                            maximumSize: const Size(120, 38),

                                            primary: Colors.black45,
                                            //background color of button//border width and color
                                            elevation: 0,
                                            //elevation of button
                                            shape: RoundedRectangleBorder(
                                                //to set border radius to button
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () async {
                                            hideKeyboard(context);

                                            setState(() {
                                              castVote = true;
                                            });
                                            await makeRedeem();
                                            setState(() {
                                              pointsLoading = true;
                                            });
                                            userinfos.getUserInfo();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "[✓]Thank you for redeeming $itemName!\n\n Our team will send a form within 24 hours."),
                                                duration:
                                                    const Duration(seconds: 5),
                                              ));
                                            }
                                            setState(() {
                                              castVote = false;
                                              state = false;
                                            });
                                          },
                                          child: const Text(
                                            "Redeem »",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ]),
    );
  }

  Future<bool> makeRedeem() async {
    var firbase = FirebaseFirestore.instance;
    final CollectionReference collectionRef =
        firbase.collection('redeemHistory');
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    final CollectionReference collectionRefUser = firbase.collection('users');

    await collectionRefUser
        .doc(userinfos.userInfo!.UserID)
        .update({'totalkpoints': FieldValue.increment(-itemPoints)})
        .then((value) => print("succes"))
        .onError((error, stackTrace) => print(error));

    collectionRef
        .doc(id)
        .set({
          'redeemKHistoryId': id.toString(),
          'redeemDate': FieldValue.serverTimestamp(),
          'redeemId': itemId,
          'userId': userinfos.userInfo?.UserID,
          'redeemItemName': itemName,
          'redeemItemKPoints': itemPoints
        })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));

    final CollectionReference collectionRefUsedHistory =
        firbase.collection('kPointsUsed');

    DateTime currentPhoneDate2 = DateTime.now();
    Timestamp myTimeStamp2 = Timestamp.fromDate(currentPhoneDate2);
    // var  = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRefUsedHistory
        .doc(id)
        .set({
          'kPointsDate': FieldValue.serverTimestamp(),
          'kPointsId': id,
          'kPointsMethod': 'Redeem',
          'kPointsOption': 'Redeemed » ${itemPoints} | ${itemName}  ',
          'kPointsValue': itemPoints,
          'userId': "${userinfos.userInfo?.UserID}"
        })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    return true;
  }
}

class SafeOnTap extends StatefulWidget {
  SafeOnTap({
    Key? key,
    required this.child,
    required this.onSafeTap,
    this.intervalMs = 1,
  }) : super(key: key);
  final Widget child;
  final GestureTapCallback onSafeTap;
  final int intervalMs;

  @override
  _SafeOnTapState createState() => _SafeOnTapState();
}

class _SafeOnTapState extends State<SafeOnTap> {
  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now().second;
        if (now - lastTimeClicked < widget.intervalMs) {
          return;
        }
        lastTimeClicked = now;
        widget.onSafeTap();
      },
      child: widget.child,
    );
  }
}
