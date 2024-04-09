import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kbops/models/userdata.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Userinfo? _userInfo;
  bool _pointsLoading = true;

  Userinfo? get userInfo => _userInfo;
  bool get pointsLoading => _pointsLoading;

  Future<void> getUserInfo() async {
    // log('GetUSERINFO  ${userInfo!.Username}');
    String userid = _auth.currentUser!.uid;
    final collectionRef = _firestore.collection('users');

    // log('call USER INFOO  $collectionRef');
    // log('call USER userid $userid');
    final docs = await collectionRef.doc(userid).get();
    // log('call USER INFOO docs  $docs');
    _userInfo = Userinfo.fromMap(docs);
    log('TOTALKPOINTS  ${userInfo!.TotalKPoints}');
    // _pointsLoading = false;
    notifyListeners();
  }

  Userinfo? _user;
  Userinfo? get user => _user;
  List<Comments>? _comments;
  List<Comments>? get comments => _comments;

  // Future<void> getUserData(String eventsID) async {
  //   try {
  //     final collectionRef = FirebaseFirestore.instance.collection('users');
  //     final querySnapshot = await collectionRef.get();

  //     _userinfoList = querySnapshot.docs
  //         .map((doc) => Userinfo.fromMap(doc.data()))
  //         .toList();

  //     final documentSnapshot = await FirebaseFirestore.instance
  //         .collection('comments')
  //         .orderBy('commentDate', descending: true)
  //         .where("eventId", isEqualTo: eventsID)
  //         .get();

  //     if (documentSnapshot.docs.isNotEmpty) {
  //       _comments =
  //           documentSnapshot.docs.map((e) => Comments.fromMap(e)).toList();
  //       // Comments com = Comments.fromMap(data);

  //       // Find user by matching UsernameID with UserID
  //       _user = _userinfoList.firstWhere(
  //         (userinfo) => _comments!.map((e) => e.UsernameID) == userinfo.UserID,
  //         // orElse: () => null,
  //       );
  //     } else {
  //       // If no comments are found, set user to null
  //       _user = null;
  //     }

  //     // Notify listeners after updating data
  //     notifyListeners();
  //   } catch (error) {
  //     print('Error fetching user data: $error');
  //     // Handle error as needed
  //   }
  // }

  // }
  // Future<void> getUserData2() async {
  //   try {
  //     final collectionRef = _firestore.collection('users');
  //     final querySnapshot = await collectionRef.get();
  //     log('querySnapshot $querySnapshot');
  //     _userinfoList = querySnapshot.docs
  //         .map((doc) => Userinfo.fromMap(doc.data()))
  //         .toList();
  //     // log('userifo data $_userinfoList');
  //     // notifyListeners();
  //   } catch (error) {
  //     print('Error fetching user data: $error');
  //     // Handle error as needed
  //   } finally {
  //     log('finalllyyyy');
  //     // _pointsLoading = false;
  //     notifyListeners();
  //   }
  // }
}
