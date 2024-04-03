import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kbops/models/userdata.dart';

class EventsProvider extends ChangeNotifier {
  Future<List<EventsInfo>> getEvents(String event) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventCategory', isEqualTo: event)
        .get();

    return querySnapshot.docs.map((doc) => EventsInfo.fromMap(doc)).toList();
  }
}
