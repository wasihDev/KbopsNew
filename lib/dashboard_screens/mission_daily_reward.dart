import 'dart:developer';
import 'package:kbops/vote_screens/widgets/my_drawer.dart';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/userdata.dart';
import '../state_management/user_info_provider.dart';
import '../state_management/vote_now_provider.dart';
import '../state_management/weekly_participant.dart';
import '../utils/functions.dart';

class MissionDailyReward extends StatefulWidget {
  const MissionDailyReward({Key? key}) : super(key: key);

  @override
  State<MissionDailyReward> createState() => _MissionDailyRewardState();
}

class _MissionDailyRewardState extends State<MissionDailyReward> {
  bool _isButtonDisabled = false;

  bool state = false;
  Duration defaultDuration = const Duration(days: 0, hours: 10, minutes: 10);
  bool pointsLoading = true;
  bool webviewLoad = false;
  // Userinfo? userInfo;

  List<BannerModel> imgList = [];
  bool isLoading = true;
  // Future<void> getUserInfo() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   String userid = auth.currentUser!.uid.toString();
  //   final collectionRef = FirebaseFirestore.instance.collection('users');
  //   final docs = await collectionRef.doc(userid).get();
  //   userInfo = Userinfo.fromMap(docs);
  //   pointsLoading = false;
  //   setState(() {});
  // }

  // var missionImageUrl = "";
  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   var firbase = FirebaseFirestore.instance;
  //   final CollectionReference collectionRef =
  //       firbase.collection('sliderImages');
  //   final CollectionReference collectionRefImage =
  //       firbase.collection('missionImage');
  //   QuerySnapshot querySnapshot = await collectionRef.get();
  //   var querySnapshotMissionImage = await collectionRefImage.doc("image").get();
  //   missionImageUrl = querySnapshotMissionImage.get("url");
  //   // Get data from docs and convert map to List
  //   final sliderData = querySnapshot.docs
  //       .map((doc) =>
  //           {'image': doc['imageSlider'], 'url': doc['imageSliderLink']})
  //       .toList();
  //   for (int i = 0; i < sliderData.length; i++) {
  //     imgList.add(BannerModel(
  //         imagePath: sliderData[i]['image'], id: (i + 1).toString()));
  //   }
  //   isLoading = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  WeeklyCharts? weeklyCharts;
  bool rewardLoading = false;
  //late RewardedInterstitialAd _interstitialAd;
  late RewardedAd rewardedAd;
  bool isAdLoaded = false;
  LoadInter() async {
    log('current USERTIME ${userProvider.userInfo?.RewardDate}');
    // final formatted = await fetchDate();

    if ((userProvider.userInfo!.RewardDate) == fetchDates?.date!['date']) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              '✓Daily rewards already granted. \n\n Please comeback tomorrow.'),
          duration: Duration(
            seconds: 3,
          ),
        ));
      }
    } else {
      log('clicking');
      RewardedAd.load(
          adUnitId: 'ca-app-pub-4031621145325255/5910687369',
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('$ad loaded.');
              rewardedAd = ad;

              rewardedAd.show(
                  onUserEarnedReward:
                      (AdWithoutView ad, RewardItem rewardItem) {});
              rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (RewardedAd ad) =>
                    print('$ad onAdShowedFullScreenContent.'),
                onAdDismissedFullScreenContent: (RewardedAd ad) {
                  print('$ad onAdDismissedFullScreenContent.');
                  executeMission(fetchDates?.date);
                  ad.dispose();
                },
                onAdFailedToShowFullScreenContent:
                    (RewardedAd ad, AdError error) {
                  print('$ad onAdFailedToShowFullScreenContent: $error');
                  ad.dispose();
                },
                onAdImpression: (RewardedAd ad) =>
                    print('$ad impression occurred.'),
              );
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "❌ ADs is not available at this time. \n\n» Please try again later."),
                  duration: Duration(
                    seconds: 3,
                  ),
                ));
              }
            },
          ),
          request: const AdRequest());
    }
  }

  bool isExpanded = false;
  Future<bool> getWeeklyPoints() async {
    var firbase = FirebaseFirestore.instance;
    final CollectionReference collectionRef =
        firbase.collection('weeklyCharts');
    var weekly = await collectionRef.doc("week").get();
    weeklyCharts = WeeklyCharts.fromMap(weekly);
    DateTime? t = weeklyCharts?.endDate?.toDate();
    defaultDuration = Duration(
        days: t!.day, hours: t.hour, minutes: t.minute, seconds: t.second);
    setState(() {});
    return true;
  }

  bool castVote = false;
  late InterstitialAd _interstitialAd;
  late UserProvider userProvider;
  VoteNowProvider? fetchDates;
  @override
  void initState() {
    _createInterstitialAd();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      Provider.of<WeeklyParticipantsProvider>(context, listen: false)
          .getMissionImage();
      fetchDates = Provider.of<VoteNowProvider>(context, listen: false);
      fetchDates?.fetchDate();
      // missionImage.getMissionImage();
      await getWeeklyPoints();
      // await getUserInfo();
      // await getData();
      // _createInterstitialAd();

      // dateTimeObj = await fetchDate();
      setState(() {});
    });
    super.initState();
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

  // var dateTimeObj = {};
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  // void onRefresh() async {
  //   await getWeeklyPoints();
  //   // await getUserInfo();
  //   await getData();
  //   dateTimeObj = await fetchDate();
  //   setState(() {});
  //   _refreshController.refreshCompleted();
  // }

  final _formkey = GlobalKey<FormState>();
  TextEditingController pointsController = TextEditingController();

  String participantId = "";
  String participantName = "";
  String participantImage = "";
  int participantsTolatVotes = 0;
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-4031621145325255/2612743946',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null!));
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd.show();
      _interstitialAd = null!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // provier(context);
    // log('current USERTIME ${userProvider?.userInfo?.AdsDate} ${dateTimeObj['date']}');
    // log('Time ${fetchDates.date}');
    // log('Time2 ${fetchDates.date!['date']}');
    // final userProvider = Provider.of<UserProvider>(context);
    // final missionImage = Provider.of<WeeklyParticipantsProvider>(context);
    // missionImage.getMissionImage();
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 198, 38, 65),
        title: const Text(
          "Chart",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                return Text(
                  "${userProvider.userInfo?.TotalKPoints ?? 0}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white),
                );
              }),
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
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // missionImageUrl.isEmpty
                // ? Container(
                //     height: MediaQuery.of(context).size.height * 0.20,
                //     width: MediaQuery.of(context).size.width * 1,
                //     color: Colors.grey,
                //   )
                //     :
                // Consumer<WeeklyParticipantsProvider>(
                //     builder: (context, provider, _) {
                //   if (provider.missionImageUrl.isEmpty) {
                //     return Container(
                //       height: MediaQuery.of(context).size.height * 0.20,
                //       width: MediaQuery.of(context).size.width * 1,
                //       color: Colors.grey,
                //     );
                //   } else {
                //     return
                //   }
                // }),
                Consumer<WeeklyParticipantsProvider>(
                    builder: (context, missionImage, child) {
                  return missionImage.missionImageUrl.isEmpty ||
                          missionImage.missionImageUrl == null
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 1,
                          // color: Colors.grey,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      missionImage.missionImageUrl),
                                  fit: BoxFit.fitWidth),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: null,
                        );
                }),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 196, 38, 64),
                      //background color of button
                      shape: RoundedRectangleBorder(
                          //to set border radius to button
                          borderRadius: BorderRadius.circular(10)),
                    ),

                    // Daily problem fix?
                    onPressed: _isButtonDisabled == false
                        ? () async {
                            setState(() {
                              _isButtonDisabled = true;
                              rewardLoading = true;
                            });
                            await LoadInter();

                            setState(() {
                              rewardLoading = false;
                              //_isButtonDisabled = false;
                            });
                            // ScaffoldMessenger.of(context)
                            //     .showSnackBar(const SnackBar(
                            //   content: Text(
                            //       '✓Daily rewards already granted. \n\n Please comeback tomorrow.'),
                            //   duration: Duration(
                            //     seconds: 3,
                            //   ),
                            // ));
                          }
                        : null,

                    child: rewardLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Get Daily Rewards",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 1,
                  child: ExpansionTile(
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    textColor: Colors.black,
                    collapsedTextColor: Colors.black,
                    backgroundColor: Colors.white,
                    title: const Center(
                        child: Text(
                      "✦ Monthly | IDOL RANK ✦",
                      style: TextStyle(color: Colors.black),
                    )),
                    children: [
                      Stack(
                        children: [
                          weeklyCharts?.urlWebView?.isNotEmpty ?? false
                              ? Container(
                                  height: 255,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Center(
                                      child: WebView(
                                    gestureRecognizers: Set()
                                      ..add(
                                          Factory<OneSequenceGestureRecognizer>(
                                              () => EagerGestureRecognizer())),
                                    javascriptMode: JavascriptMode.unrestricted,
                                    initialUrl: weeklyCharts?.urlWebView ?? "",
                                    onPageStarted: (value) {
                                      setState(() {
                                        webviewLoad = true;
                                      });
                                    },
                                    onPageFinished: (value) {
                                      setState(() {
                                        webviewLoad = false;
                                      });
                                    },
                                  )),
                                )
                              : Container(),
                          webviewLoad
                              ? Container(
                                  margin: const EdgeInsets.only(top: 40),
                                  color: Colors.white10,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(196, 38, 64, 1),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // fetchDates?.date?['date'] == ''
                //     ?
                PaginateFirestore(
                  listeners: [
                    refreshChangeListener,
                  ],
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, snapshot, index) {
                    if (snapshot.isNotEmpty) {
                      final data = snapshot[index].data() as Map?;
                      WeeklyParticipants weekP =
                          WeeklyParticipants.fromMap(data);
                      var percentage = (weekP.totalVotes! /
                              (weeklyCharts?.totalVotes ?? 100)) *
                          100;
                      var prog = percentage / 100;

                      Timestamp? t = weeklyCharts?.startDate;
                      DateTime d = t!.toDate();
                      Timestamp? t2 = weeklyCharts?.endDate;
                      DateTime d2 = t2!.toDate();
                      DateTime d3 = DateTime.parse(fetchDates?.date?['time']);
                      var status = false;
                      if (d3.compareTo(d) >= 0 && d3.compareTo(d2) <= 0) {
                        status = true;
                      } else if (d3.compareTo(d2) >= 0) {
                        status = false;
                      }

                      // print(prog);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: const BoxDecoration(
                            // color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          children: [
                            ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 30,
                                backgroundImage: NetworkImage("${weekP.image}"),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(196, 38, 64, 1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${weekP.name}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              trailing: status
                                  ? GestureDetector(
                                      onTap: () {
                                        // _showInterstitialAd();
                                        setState(() {
                                          state = true;
                                          participantId =
                                              weekP.participantId ?? "";
                                          participantName = weekP.name ?? "";
                                          participantImage = weekP.image ?? "";
                                          participantsTolatVotes =
                                              weekP.totalVotes ?? 0;
                                        });
                                      },
                                      child: Image.asset(
                                        'images/Heart Voting.png',
                                        width: 45,
                                      ))
                                  : const Icon(
                                      Icons.access_alarm_rounded,
                                      color: Colors.white,
                                    ),
                              subtitle: Row(
                                children: [
                                  LinearPercentIndicator(
                                    width: 190,
                                    animation: true,
                                    lineHeight: 16.0,
                                    animationDuration: 100,
                                    percent: prog,
                                    barRadius: const Radius.circular(10),
                                    center: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.how_to_vote,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        Text(
                                          "${weekP.totalVotes}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    linearStrokeCap:
                                        // ignore: deprecated_member_use
                                        LinearStrokeCap.roundAll,
                                    progressColor:
                                        const Color.fromARGB(255, 108, 4, 22),
                                  ),
                                  //Decided to not display percentage

                                  //Crown
                                  /*index == 0
                                                ? Center(
                                                    child: Image.asset(
                                                      'images/crown.png',
                                                      height: 40,
                                                      width: 40,
                                                      // .. color: Colors.black,
                                                    ),
                                                  )
                                                : SizedBox(),
                                        
                                             */
                                ],
                              ),
                              children: [
                                Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${weekP.imageBanner}'),
                                          fit: BoxFit.fill)),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  query: FirebaseFirestore.instance
                      .collection("weeklyParticipants")
                      .orderBy("totalVotes", descending: true),
                  itemBuilderType: PaginateBuilderType.listView,
                  // to fetch real-time data
                  isLive: true,
                )
                // : Container(),
              ],
            ),
          ),
        ),
        state
            ? Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.black54,
                child: Center(
                  child: Container(
                    height: 350,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 196, 38, 64),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 30,
                              ),
                              const Spacer(),
                              const Text(
                                " ▽ You are voting for ▽ ",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 15,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      state = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(participantImage),
                                  fit: BoxFit.fill),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            participantName,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                const Text(
                                  '[Current KPoints]',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Consumer<UserProvider>(
                                    builder: (context, userProvider, child) {
                                  return Text(
                                    '${userProvider.userInfo?.TotalKPoints ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  );
                                }),
                                Image.asset(
                                  'images/Heart Voting.png',
                                  height: 23,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Consumer<UserProvider>(
                                      builder: (context, userProvider, child) {
                                    return TextFormField(
                                      controller: pointsController,
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "» Please enter KPoints.";
                                        } else if (int.parse(val) >
                                            (userProvider
                                                    .userInfo?.TotalKPoints ??
                                                0)) {
                                          return "» You don't have enough KPoints to vote.";
                                        } else if (int.parse(val) < 1) {
                                          return "» KPoints must be greater than 0.";
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          color: Colors.black87),
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          errorStyle:
                                              TextStyle(color: Colors.white),
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25))),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          hintText: 'Enter KPoints',
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15)),
                                    );
                                  }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  !castVote
                                      ? Consumer<UserProvider>(builder:
                                          (context, userProvider, child) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      const Size(350, 45),
                                                  maximumSize:
                                                      const Size(350, 45),
                                                  primary: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  //background color of button//border width and color
                                                  elevation: 0,
                                                  //elevation of button
                                                  shape: RoundedRectangleBorder(
                                                      //to set border radius to button
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                  side: const BorderSide(
                                                      color: Colors.white,
                                                      //fromARGB(255, 198, 38, 65),
                                                      width: 1)),
                                              onPressed: () {
                                                hideKeyboard(context);
                                                if (_formkey.currentState!
                                                        .validate() &&
                                                    userProvider.userInfo !=
                                                        null) {
                                                  setState(() {
                                                    castVote = true;
                                                  });
                                                  addVote(context);
                                                  _showInterstitialAd();
                                                }
                                              },
                                              child: const Text(
                                                "→ → → VOTE ← ← ←",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        })
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(350, 45),
                                              maximumSize: const Size(350, 45),
                                              primary: const Color.fromARGB(
                                                  255, 230, 230, 230),
                                              //background color of button//border width and color
                                              elevation: 0,
                                              //elevation of button
                                              shape: RoundedRectangleBorder(
                                                  //to set border radius to button
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                            ),
                                            onPressed: () {},
                                            child:
                                                const CircularProgressIndicator(
                                              color: Color.fromRGBO(
                                                  196, 38, 64, 1),
                                            ),
                                          ),
                                        )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }

  // late UserProvider userinfo;
  // void provier(BuildContext context) {
  //   userinfo = Provider.of<UserProvider>(context);
  // }

  executeMission(formatted) async {
    await addReward(formatted);
    // await getUserInfo();
    // Provider.of<UserProvider>(context).getUserInfo();
    userProvider.getUserInfo();
    if (mounted) {
      var firebase = FirebaseFirestore.instance;
      final CollectionReference dailyrewards =
          firebase.collection('dailyrewards');
      final DocumentSnapshot userSnapshot =
          await dailyrewards.doc('kpoints').get();
      final int kpoints = userSnapshot.get('kPointsValue');
      final String kPointsOption = userSnapshot.get('kPointsOption');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(kPointsOption),
        duration: Duration(
          seconds: 4,
        ),
      ));
    }
  }

  addReward(date) async {
    var firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefUser = firebase.collection('users');
    final CollectionReference dailyrewards =
        firebase.collection('dailyrewards');
    final DocumentSnapshot userSnapshot =
        await dailyrewards.doc('kpoints').get();
    final int kpoint = userSnapshot.get('kPointsValue');
    final String kPointsOption = userSnapshot.get('kPointsOption');

    await collectionRefUser
        .doc(userProvider.userInfo?.UserID)
        .update({
          'totalkpoints': FieldValue.increment(kpoint),
          'rewardDate': date['date']
        })
        .then((value) => print("succes"))
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
          'kPointsMethod': 'dailyrewards',
          'kPointsOption': kPointsOption,
          //'15 KPoints | Daily Attendance Reward  ',
          'kPointsValue': kpoint,
          'userId': "${userProvider.userInfo?.UserID}"
        })
        .then((value) => log("success"))
        .onError((error, stackTrace) => log(error.toString()));
  }

  addVote(BuildContext cxt) async {
    try {
      var firbase = FirebaseFirestore.instance;
      final CollectionReference collectionRefEvents =
          firbase.collection('weeklyCharts');

      await collectionRefEvents
          .doc("week")
          .update({
            'totalVotes': ((weeklyCharts?.totalVotes)!.toInt() +
                int.parse(pointsController.text))
          })
          .then((value) => print("succes"))
          .onError((error, stackTrace) => print(error));

      final CollectionReference collectionRefUser = firbase.collection('users');

      await collectionRefUser
          .doc(userProvider.userInfo?.UserID)
          .update({
            'totalkpoints':
                FieldValue.increment(-int.parse(pointsController.text))
          })
          .then((value) => print("succes"))
          .onError((error, stackTrace) => print(error));

      final CollectionReference collectionRefParticipant =
          firbase.collection('weeklyParticipants');

      await collectionRefParticipant
          .doc(participantId)
          .update({
            'totalVotes': FieldValue.increment(int.parse(pointsController.text))
          })
          .then((value) => print("succes"))
          .onError((error, stackTrace) => print(error));
      final CollectionReference collectionRefUsedHistory =
          firbase.collection('kPointsUsed');

      DateTime currentPhoneDate = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
      var id = DateTime.now().millisecondsSinceEpoch.toString();
      await collectionRefUsedHistory
          .doc(id)
          .set({
            'kPointsDate': FieldValue.serverTimestamp(),
            'kPointsId': id,
            'kPointsMethod': 'chart',
            'kPointsOption':
                'Voted » ${pointsController.text} KPoints | ${participantName} | Chart \n ',
            'kPointsValue': int.parse(pointsController.text),
            'userId': "${userProvider.userInfo?.UserID}"
          })
          .then((value) => print("success"))
          .onError((error, stackTrace) => print(error));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 8),
            content: Text(
                '» Thank you for voting ${pointsController.text} KPoints to $participantName !')));
      }

      pointsController.clear();
      participantName = "";
      participantId = "";
      participantImage = "";
      participantsTolatVotes = 0;
      setState(() {
        state = false;
        castVote = false;
      });
      // _refreshController.requestRefresh();
      userProvider.getUserInfo();
    } catch (e) {
      log('errorrrr $e');
    }
  }
}
