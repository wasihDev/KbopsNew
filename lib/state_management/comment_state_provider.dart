import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/userdata.dart';

class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Comments> _commentList = [];
  bool _isLoading = true;

  List<Comments> get commentList => _commentList;
  bool get isLoading => _isLoading;

  Future<void> getComments(String eventId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final collectionRef = _firestore
          .collection('comments')
          .orderBy('commentDate', descending: true)
          .where("eventId", isEqualTo: eventId);
      var comments = await collectionRef.get();

      _commentList.clear();
      for (var doc in comments.docs) {
        _commentList.add(Comments(
          CommentID: doc.get('commentId'),
          UsernameID: doc.get('userId'),
          CommentDescription: doc.get('commentDescription'),
          CommentDate: doc.get('commentDate'),
          EventId: eventId, // Use the provided eventId
        ));
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error getting comments: $e');
      throw e;
    }
  }

  Future<void> postComment(
      String comment, String eventId, String userId) async {
    try {
      final CollectionReference collectionRef =
          _firestore.collection('comments');
      DateTime currentPhoneDate = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
      var id = DateTime.now().millisecondsSinceEpoch.toString();
      await collectionRef.doc(id).set({
        'commentDate': FieldValue.serverTimestamp(),
        'commentDescription': comment,
        'commentId': id,
        'eventId': eventId,
        'userId': userId
      });
      notifyListeners();
    } catch (e) {
      print('Error posting comment: $e');
      throw e;
    }
  }
}
