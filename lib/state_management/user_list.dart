import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/userdata.dart';

class UserListProvider extends ChangeNotifier {
  List<Userinfo> _userinfoList = [];
  List<Userinfo> get nameInfoList => _userinfoList;
  Future<void> getUserData2() async {
    log('call get UserList fun');
    try {
      final collectionRef = FirebaseFirestore.instance.collection('users');
      final docs = await collectionRef.get();
      _userinfoList.clear();
      for (var i in docs.docs) {
        _userinfoList.add(Userinfo.fromMap(i));
      }
      notifyListeners();
    } catch (e) {
      log('error userLsist $e');
    }
  }
}
