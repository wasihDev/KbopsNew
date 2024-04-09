import 'dart:developer';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeeklyParticipantsProvider extends ChangeNotifier {
  final CollectionReference _weeklyParticipantsRef =
      FirebaseFirestore.instance.collection('weeklyParticipants');

  List<DocumentSnapshot> _participantsSnapshots = [];
  bool _isLoading = false;

  List<DocumentSnapshot> get participantsSnapshots => _participantsSnapshots;
  bool get isLoading => _isLoading;

  Future<void> loadParticipants() async {
    try {
      _isLoading = true;
      final querySnapshot = await _weeklyParticipantsRef
          .orderBy("totalVotes", descending: true)
          .get();
      _participantsSnapshots = querySnapshot.docs;
    } catch (error) {
      // Handle error
      print('Error loading participants: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  late List<BannerModel> _imgList = [];
  late String _missionImageUrl = "";

  List<BannerModel> get imgList => _imgList;
  String get missionImageUrl => _missionImageUrl;
  Future<void> getMissionImage() async {
    final firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefImage =
        firebase.collection('missionImage');
    final querySnapshotMissionImage =
        await collectionRefImage.doc("image").get();
    // log('querySnapshotMissionImage ${querySnapshotMissionImage.get('url')}');
    _missionImageUrl = querySnapshotMissionImage.get("url");
    notifyListeners();
  }

  Future<void> getData() async {
    try {
      final firebase = FirebaseFirestore.instance;
      // final CollectionReference collectionRefImage =
      //     firebase.collection('missionImage');
      // final querySnapshotMissionImage =
      //     await collectionRefImage.doc("image").get();
      // _missionImageUrl = querySnapshotMissionImage.get("url");
      // notifyListeners();
      final CollectionReference collectionRef =
          firebase.collection('sliderImages');
      final querySnapshot = await collectionRef.get();
      final sliderData = querySnapshot.docs
          .map(
              (doc) => BannerModel(imagePath: doc['imageSlider'], id: (doc.id)))
          .toList();
      _imgList = sliderData;
      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
