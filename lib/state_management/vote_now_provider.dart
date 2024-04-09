import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kbops/models/anony.dart';
import 'package:kbops/state_management/user_info_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/userdata.dart';

class VoteNowProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EventsInfo? _eventsInfo;
  EventsInfo? get eventsInfo => _eventsInfo;
  Userinfo? _userInfo;
  bool _pointsLoading = true;
  Userinfo? get userInfo => _userInfo;
  bool get pointsLoading => _pointsLoading;
  List<EventsParticipant> _participantsList = [];
  List<EventsParticipant> get participantsList => _participantsList;
  List<Comments> _commentList = [];
  List<Comments> get commentList => _commentList;
  List<Userinfo> _userinfoList = [];
  List<Userinfo> get nameInfoList => _userinfoList;

//  dynamic points='';

  bool isLoading = true;
  late InterstitialAd _interstitialAd;
  List<BannerModel> _imgList = [];
  List<BannerModel> get imgList => _imgList;
  Map<dynamic, dynamic>? _date;

  Map<dynamic, dynamic>? get date => _date;

  Future<void> fetchDate() async {
    try {
      final res = await http.get(Uri.parse("https://kbops.online/date.php"));
      final date = jsonDecode(res.body);
      _date = date;
      notifyListeners();
    } catch (error) {
      print("Error fetching date: $error");
    }
  }

  // VoteNowProvider.instance() {
  //   getData();
  // }
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  bool isImageLoading = false;
  List<BannerModels> _banners = [];
  List<BannerModels> get banners => _banners;

  Future<void> getAllBanners() async {
    log('awaais');
    var db = FirebaseFirestore.instance;

    try {
      final snapShot = await db.collection('sliderImages').get();
      _banners =
          snapShot.docs.map((e) => BannerModels.fromSnapshot(e)).toList();
      log('bannerData ============>>>.>>>>=$_banners');
      notifyListeners();
      // return bannerData;
      // log('FLECTH SLIDER IMAGES');
      // isImageLoading = true;
      // notifyListeners();
      // var firebase = FirebaseFirestore.instance;
      // final CollectionReference collectionRef =
      //     firebase.collection('sliderImages');
      // QuerySnapshot querySnapshot = await collectionRef.get();
      // log('============ Query $querySnapshot');
      // final sliderData = querySnapshot.docs.map((doc) {
      //   return BannerModel(
      //     imagePath: doc['imageSlider'],
      //     id: _imgList.length.toString(),
      //   );
      // }).toList();
      // log('============ _imgList $_imgList');
      // // _imgList.clear();
      // _imgList.addAll(sliderData);
      // isImageLoading = false;
      // notifyListeners();
    } catch (e) {
      // Handle error

      log("Error fetching data: $e");
      // return [];
    }
  }

  VoteNowProvider() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    createInterstitialAd();
    // fetchData();
  }
  bool _state = false;

  // Getter to access the boolean value
  bool get state => _state;

  // Method to toggle the boolean value
  void toggleValue() {
    _state = !_state;
    notifyListeners(); // Notify listeners about the change
  }
  // Future<void> fetchData() async {
  //   await getComments();
  //   await getUserInfo();
  //   // await getParticipants();
  //   await getUserData();
  //   isLoading = false;
  //   notifyListeners();
  // }

  var pointsController = TextEditingController();

  // bool _state = false;
  bool castVote = false;
  // String pointsController = '';
  String points = '';
  String participantId = '';
  // String participantName = '';
  String participantImage = '';
  int participantsTolatVotes = 0;
//  String participantId, String participantName
  Future<void> getUserData() async {
    log('==============Provider Call');
    final collectionRef = _firestore.collection('users');
    final docs = await collectionRef.get();
    _userinfoList.clear();
    log('docs==============docs $docs');
    for (var i in docs.docs) {
      _userinfoList.add(Userinfo.fromMap(i));
    }
    log('_userinfoList==============docs $_userinfoList');
    _pointsLoading = false;
    notifyListeners();
  }

  Future<void> getUserInfo() async {
    String userid = _auth.currentUser!.uid;
    final collectionRef = _firestore.collection('users');
    final docs = await collectionRef.doc(userid).get();
    _userInfo = Userinfo.fromMap(docs);
    _pointsLoading = false;

    notifyListeners();
  }

  Future<void> getEventInfo(String eventInfos) async {
    log('Here tp getEventInfo');
    final collectionRef = _firestore.collection('events');
    log('Here tp getEventInfo $collectionRef ${eventInfos}');
    final docs = await collectionRef.doc(eventInfos).get();
    log('docs ${eventInfos}');
    _eventsInfo = EventsInfo.fromMap(docs);
    _pointsLoading = false;
    notifyListeners();
  }

  Future<void> getParticipants(String eventInfos) async {
    log('Here tp participants');
    final collectionRef = _firestore
        .collection('participants')
        .where("eventId", isEqualTo: eventInfos);
    log('Here tp getEventInfo $collectionRef ${eventInfos}');

    var participants = await collectionRef.get();
    _participantsList.clear();
    for (var doc in participants.docs) {
      _participantsList.add(EventsParticipant(
        EventId: doc.get("eventId"),
        ParticipantID: doc.get("participantId"),
        ParticipantName: doc.get("participantName"),
        ParticipantImage: doc.get("participantImage"),
        ParticipantTotalVotes: doc.get("participantTotalVotes"),
        ParticipantPercentage: doc.get("participantPercentage"),
      ));
    }

    participantsList.sort((b, a) => a.ParticipantTotalVotes!
        .toInt()
        .compareTo(b.ParticipantTotalVotes!.toInt()));
    isLoading = false;
    notifyListeners();
  }

  Future<void> getComments(String eventInfos) async {
    final collectionRef = _firestore
        .collection('comments')
        .orderBy('commentDate', descending: true)
        .where("eventId", isEqualTo: eventInfos);
    var comments = await collectionRef.get();
    _commentList = comments.docs.cast<Comments>();
    notifyListeners();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-4031621145325255/2612743946",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null!));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        createInterstitialAd();
      });
      _interstitialAd.show();
      _interstitialAd = null!;
    }
  }

  bool _isVoting = false;

  bool get isVoting => _isVoting;
  // UserProvider? userprovider;
  Future<void> addVote(
      {required String points,
      required String eventId,
      required String participantId,
      required String participantName,
      required String userId,
      required BuildContext context}) async {
    _isVoting = true;
    notifyListeners();
    log('dskaldklsandlsndnsalnd');
    try {
      var firebase = FirebaseFirestore.instance;

      final CollectionReference collectionRef = firebase.collection('votes');
      var id = DateTime.now().millisecondsSinceEpoch.toString();
      await collectionRef.doc(id).set({
        'KPointsVoted': int.parse(points),
        'eventId': eventId,
        'eventVotesID': id,
        'participantID': participantId,
        'userID': userId,
      });

      final CollectionReference collectionRefEvents =
          firebase.collection('events');
      await collectionRefEvents.doc(eventId).update({
        'eventTotalVotes': FieldValue.increment(int.parse(points)),
      });
      log('participantName: $participantName  ${eventsInfo!.EventName}');

      final CollectionReference collectionRefUser =
          firebase.collection('users');
      await collectionRefUser.doc(userId).update({
        'totalkpoints': FieldValue.increment(-int.parse(points)),
      });
      notifyListeners();
      final CollectionReference collectionRefParticipant =
          firebase.collection('participants');
      await collectionRefParticipant.doc(participantId).update({
        'participantTotalVotes': FieldValue.increment(int.parse(points)),
      });

      final CollectionReference collectionRefUsedHistory =
          firebase.collection('kPointsUsed');

      DateTime currentPhoneDate = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);

      await collectionRefUsedHistory.doc(id).set({
        'kPointsDate': FieldValue.serverTimestamp(),
        'kPointsId': id,
        'kPointsMethod': 'voting',
        'kPointsOption':
            'Voted » $points KPoints | $participantName | ${eventsInfo!.EventName}\n',
        'kPointsValue': int.parse(points),
        'userId': userId,
      });
      // userprovider!.getUserInfo();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 8),
        content:
            Text('Thank you for voting $points KPoints to $participantName!'),
      ));
    } catch (error) {
      print("Error adding vote: $error");
    }

    _isVoting = false;
    notifyListeners();
  }

  Future<void> addVote2(BuildContext context, String participantName) async {
    var firebase = FirebaseFirestore.instance;

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final CollectionReference votesRef = firebase.collection('votes');

      await votesRef.doc(id).set({
        'KPointsVoted': int.parse(points),
        'eventId': eventsInfo!.EventID,
        'eventVotesID': id,
        'participantID': participantId,
        'userID': userInfo?.UserID,
      });

      final CollectionReference eventsRef = firebase.collection('events');
      await eventsRef.doc(eventsInfo!.EventID).update({
        'eventTotalVotes': FieldValue.increment(int.parse(points)),
      });

      final CollectionReference usersRef = firebase.collection('users');
      await usersRef.doc(userInfo!.UserID).update({
        'totalKPoints': FieldValue.increment(-int.parse(points)),
      });

      final CollectionReference participantsRef =
          firebase.collection('participants');
      await participantsRef.doc(participantId).update({
        'participantTotalVotes': FieldValue.increment(int.parse(points)),
      });

      final CollectionReference historyRef = firebase.collection('kPointsUsed');
      await historyRef.doc(id).set({
        'kPointsDate': FieldValue.serverTimestamp(),
        'kPointsId': id,
        'kPointsMethod': 'voting',
        'kPointsOption':
            'Voted » $points | $participantName | ${eventsInfo!.EventName}\n',
        'kPointsValue': int.parse(points),
        'userId': userInfo?.UserID,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 8),
        content:
            Text('Thank you for voting $points KPoints to $participantName!'),
      ));

      pointsController.clear();
      participantName = '';
      participantId = '';

      // setState(() {
      _state = false;
      castVote = false;
      // });
      notifyListeners();
      // await getEventInfo();
      // await getParticipants();
    } catch (error) {
      print('Error adding vote: $error');
      // Handle error
    }
  }
}
