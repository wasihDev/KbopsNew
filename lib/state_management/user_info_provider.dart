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
    String userid = _auth.currentUser!.uid;
    final collectionRef = _firestore.collection('users');

    log('call USER INFOO  $collectionRef');
    log('call USER userid $userid');
    final docs = await collectionRef.doc(userid).get();
    log('call USER INFOO docs  $docs');
    _userInfo = Userinfo.fromMap(docs);
    log('call USER INFOO docs  ${userInfo!.TotalKPoints}');
    _pointsLoading = false;
    notifyListeners();
  }
}
