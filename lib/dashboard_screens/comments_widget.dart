// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:kbops/dashboard_screens/all_comments.dart';
// import 'package:kbops/dashboard_screens/comments_widget.dart';
// import 'package:kbops/dashboard_screens/report_comment.dart';
// import 'package:kbops/models/userdata.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class VoteNow2 extends StatefulWidget {
//   VoteNow2({Key? key, required this.eventsInfo, required this.isVote})
//       : super(key: key);
//   final EventsInfo eventsInfo;
//   bool isVote;
//   @override
//   State<VoteNow2> createState() => _commentsWidget(isVote, eventsInfo);
// }

// class _commentsWidget extends State<VoteNow2> {
//   var webviewLoad = true;
//   bool isVote;
//   _commentsWidget(this.isVote, this.eventsInfo);

//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: true);
//   var commentController = TextEditingController();
//   var pointsController = TextEditingController();
//   EventsInfo eventsInfo;
//   var castVote = false;
//   final _formkey = GlobalKey<FormState>();
//   final _commentkey = GlobalKey<FormState>();

//   var state = false;
//   List<EventsParticipant> participantsList = [];
//   List<Comments> commentList = [];
//   List<Userinfo> userinfoList = [];
//   Userinfo? userInfo;
//   void _onRefresh() async {
//     // monitor network fetch
//     await getUserInfo();
//     await getParticipants();
//     await getComments();
//     await getUserData();
//     setState(() {});
//     // if failed,use refreshFailed()
//     _refreshController.refreshCompleted();
//   }

//   Future<void> getUserInfo() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     String userid = auth.currentUser!.uid.toString();
//     final collectionRef = FirebaseFirestore.instance.collection('users');
//     final docs = await collectionRef.doc(userid).get();
//     userInfo = Userinfo.fromMap(docs);
//     setState(() {});
//   }

//   Future<void> getEventInfo() async {
//     final collectionRef = FirebaseFirestore.instance.collection('events');
//     final docs = await collectionRef.doc(eventsInfo.EventID).get();
//     eventsInfo = EventsInfo.fromMap(docs);
//     print(eventsInfo.EventTotalVotes);
//     setState(() {});
//   }

//   Future<void> getUserData() async {
//     final collectionRef = FirebaseFirestore.instance.collection('users');
//     final docs = await collectionRef.get();
//     userinfoList.clear();
//     for (var i in docs.docs) {
//       userinfoList.add(Userinfo.fromMap(i));
//     }
//     setState(() {});
//   }

//   Future<void> getParticipants() async {
//     final collectionRef = FirebaseFirestore.instance
//         .collection('participants')
//         .where("eventId", isEqualTo: eventsInfo.EventID);
//     var participants = await collectionRef.get();
//     participantsList.clear();
//     for (var doc in participants.docs) {
//       participantsList.add(EventsParticipant(
//           EventId: doc.get("eventId"),
//           ParticipantID: doc.get("participantId"),
//           ParticipantName: doc.get("participantName"),
//           ParticipantImage: doc.get("participantImage"),
//           ParticipantTotalVotes: doc.get("participantTotalVotes"),
//           ParticipantPercentage: doc.get("participantPercentage")));
//     }

//     participantsList.sort((b, a) => a.ParticipantTotalVotes!
//         .toInt()
//         .compareTo(b.ParticipantTotalVotes!.toInt()));
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> getComments() async {
//     final collectionRef = FirebaseFirestore.instance
//         .collection('comments')
//         .orderBy('commentDate', descending: true)
//         .where("eventId", isEqualTo: eventsInfo.EventID);
//     var comments = await collectionRef.limit(6).get();
//     print("comments");
//     print(comments.docs);
//     commentList.clear();
//     for (var doc in comments.docs) {
//       commentList.add(Comments(
//           CommentID: doc.get('commentId'),
//           UsernameID: doc.get('userId'),
//           CommentDescription: doc.get('commentDescription'),
//           CommentDate: doc.get('commentDate'),
//           EventId: 'eventId'));
//     }
//     setState(() {});
//   }

//   var participantName = '';
//   var participantImage = '';
//   var participantId = '';
//   var isLoading = true;
//   int participantsTolatVotes = 0;

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();

//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             children: [
//               const Text(
//                 '\n☑︎ Comments \n',
//                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
//               ),
//               const Spacer(),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => AllComments(
//                                 userinfoList: userinfoList,
//                                 eventsInfo: eventsInfo,
//                                 userinfo: userInfo!,
//                               )));
//                 },
//                 child: const Text(
//                   '\nSee all » \n',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
//                 ),
//               )
//             ],
//           ),
//         ),
//         commentList.isEmpty
//             ? Container()
//             : Container(
//                 height: 300,
//                 decoration: new BoxDecoration(color: Colors.white),
//                 child: ListView.builder(
//                     itemCount: commentList.length,
//                     itemBuilder: (BuildContext context, int i) {
//                       Userinfo? user;
//                       Comments com = commentList[i];
//                       for (var i in userinfoList) {
//                         if (com.UsernameID == i.UserID) {
//                           user = i;
//                           break;
//                         }
//                       }
//                       Timestamp? t = com.CommentDate;
//                       DateTime d = t!.toDate();

//                       return Column(
//                         children: [
//                           Divider(
//                             thickness: 1,
//                           ),
//                           Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 12,
//                                   ),
//                                   Container(
//                                     height: 45,
//                                     width: 45,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: NetworkImage(user?.UserImage ??
//                                               "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png  "),
//                                           fit: BoxFit.fill),
//                                       color: Colors.white,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   RichText(
//                                     text: TextSpan(
//                                       style: DefaultTextStyle.of(context).style,
//                                       children: <TextSpan>[
//                                         TextSpan(
//                                             text: user?.Username ?? "",
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: 14)),
//                                         // TextSpan(
//                                         //     text:
//                                         //     '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute}',
//                                         //     style: TextStyle(
//                                         //       fontWeight: FontWeight.w300,
//                                         //       fontSize: 12,
//                                         //     )),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Container(
//                                   child: Row(
//                                 children: [
//                                   Container(
//                                     margin:
//                                         EdgeInsets.symmetric(horizontal: 20),
//                                     width: 350,
//                                     child: Text('${com.CommentDescription}',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.normal,
//                                             fontSize: 13)),
//                                   ),
//                                 ],
//                               )),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Container(
//                                   margin: EdgeInsets.symmetric(horizontal: 40),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                           '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute} | ',
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w300,
//                                             fontSize: 12,
//                                           )),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (_) => ReportComment(
//                                                         userinfo: userInfo,
//                                                         com: com,
//                                                         user: user!,
//                                                       )));
//                                         },
//                                         child: Text(
//                                           'Report',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       );
//                     }),
//               ),
//       ],
//     );
//   }
// }
