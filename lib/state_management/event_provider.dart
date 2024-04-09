import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kbops/models/userdata.dart';

class EventsProvider extends ChangeNotifier {
  List<EventsInfo> _events1 = [];
  List<EventsInfo> get events1 => _events1;
  List<EventsInfo> _events2 = [];
  List<EventsInfo> get events2 => _events2;
  List<EventsInfo> _events3 = [];
  List<EventsInfo> get events3 => _events3;
  Set<String> _eventIds = HashSet<String>();

  Future<void> getEventsKPOP() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventCategory', isEqualTo: 'KPOP Vote')
        .get();

    _events1 =
        querySnapshot.docs.map((doc) => EventsInfo.fromMap(doc)).toList();
    // _events.clear();
    // log('Events $_events ');
    notifyListeners();
  }

  Future<void> getEventsGLOBAL() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventCategory', isEqualTo: 'Global Vote')
        .get();

    _events2 =
        querySnapshot.docs.map((doc) => EventsInfo.fromMap(doc)).toList();
    // _events.clear();
    // log('Events $_events ');
    notifyListeners();
  }

  Future<void> getEventsFan() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventCategory', isEqualTo: 'Fan Project')
        .get();

    _events3 =
        querySnapshot.docs.map((doc) => EventsInfo.fromMap(doc)).toList();
    // _events.clear();
    // log('Events $_events $event');
    notifyListeners();
  }
}
