// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:kbops/dashboard_screens/all_comments.dart';
// import 'package:kbops/dashboard_screens/report_comment.dart';
// import 'package:kbops/models/userdata.dart';
// import 'package:kbops/utils/ad_mod_service.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import '../utils/functions.dart';

// class VoteNow extends StatefulWidget {
//   VoteNow({Key? key, required this.eventsInfo, required this.isVote})
//       : super(key: key);
//   final EventsInfo eventsInfo;
//   bool isVote;
//   @override
//   State<VoteNow> createState() => _VoteNowState(isVote, eventsInfo);
// }

// class _VoteNowState extends State<VoteNow> {
//   var webviewLoad = true;
//   bool isVote;
//   _VoteNowState(this.isVote, this.eventsInfo);
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
//     // await getComments();
//     await getUserData();
//     setState(() {});
//     // if failed,use refreshFailed()
//     _refreshController.refreshCompleted();
//   }

//   @override
//   void dispose() {
//     _refreshController.dispose();
//     super.dispose();
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

// Future<void> getComments() async {
//   final collectionRef = FirebaseFirestore.instance
//       .collection('comments')
//       .orderBy('commentDate', descending: true)
//       .where("eventId", isEqualTo: eventsInfo.EventID);
//   var comments = await collectionRef.get();
//   print("comments");
//   print(comments.docs);
//   commentList.clear();
//   for (var doc in comments.docs) {
//     commentList.add(Comments(
//         CommentID: doc.get('commentId'),
//         UsernameID: doc.get('userId'),
//         CommentDescription: doc.get('commentDescription'),
//         CommentDate: doc.get('commentDate'),
//         EventId: 'eventId'));
//   }
//   setState(() {});
// }

//   var participantName = '';
//   var participantImage = '';
//   var participantId = '';
//   var isLoading = true;
//   int participantsTolatVotes = 0;
//   late InterstitialAd _interstitialAd;
//   @override
//   void initState() {
//     super.initState();
//     _createInterstitialAd();
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await getComments();
//     });
//   }

//   // final String? get bannerAdUnitID
//   void _createInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: "ca-app-pub-4031621145325255/2612743946",
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//             onAdLoaded: (ad) => _interstitialAd = ad,
//             onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null!));
//   }

//   void _showInterstitialAd() {
//     if (_interstitialAd != null) {
//       _interstitialAd.fullScreenContentCallback =
//           FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
//         ad.dispose();
//         _createInterstitialAd();
//       }, onAdFailedToShowFullScreenContent: (ad, error) {
//         ad.dispose();
//         _createInterstitialAd();
//       });
//       _interstitialAd.show();
//       _interstitialAd = null!;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(eventsInfo.EventTotalVotes);
// return Scaffold(
//   backgroundColor: Colors.white,
//   body: SafeArea(
//     child: Stack(
//       children: [
//         SmartRefresher(
//           controller: _refreshController,
//           enablePullDown: true,
//           onRefresh: _onRefresh,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.30,
//                   width: MediaQuery.of(context).size.width * 1,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: NetworkImage("${eventsInfo.EventImage}"),
//                           fit: BoxFit.fill)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 _showInterstitialAd();
//                               },
//                               child: const Icon(
//                                 Icons.arrow_back_ios,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 150,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 ExpansionTile(
//                   title: const Text('Event Description ▷'),
//                   children: [
//                     Stack(
//                       children: [
//                         SizedBox(
//                           height: 355,
//                           width: MediaQuery.of(context).size.width * 1,
//                           child: Center(
//                               child: WebView(
//                             gestureRecognizers: Set()
//                               ..add(Factory<OneSequenceGestureRecognizer>(
//                                   () => EagerGestureRecognizer())),
//                             javascriptMode: JavascriptMode.unrestricted,
//                             initialUrl: '${eventsInfo.EventDescription}',
//                             onPageStarted: (value) {
//                               setState(() {
//                                 webviewLoad = true;
//                               });
//                             },
//                             onPageFinished: (value) {
//                               setState(() {
//                                 webviewLoad = false;
//                               });
//                             },
//                           )),
//                         ),
//                         webviewLoad
//                             ? Container(
//                                 margin: const EdgeInsets.only(top: 40),
//                                 color: Colors.white,
//                                 child: const Center(
//                                   child: CircularProgressIndicator(
//                                     color: Color.fromRGBO(196, 38, 64, 1),
//                                   ),
//                                 ),
//                               )
//                             : Container()
//                       ],
//                     ),
//                   ],
//                 ),
//                 ListView.builder(
//                     shrinkWrap: true,
//                     physics: const ClampingScrollPhysics(),
//                     itemCount: participantsList.length,
//                     itemBuilder: (BuildContext context, int i) {
//                       EventsParticipant participant = participantsList[i];
//                       var position = 'th';
//                       if (i + 1 == 1) {
//                         position = 'st';
//                       } else if (i + 1 == 2) {
//                         position = 'nd';
//                       } else if (i + 1 == 3) {
//                         position = 'rd';
//                       }
//                       var percent = (participant.ParticipantTotalVotes! /
//                               eventsInfo.EventTotalVotes!.toInt()) *
//                           100;
//                       var pro = percent / 100;
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Column(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: i == 0
//                                           ? const Color.fromARGB(
//                                               255, 238, 233, 233)
//                                           : const Color.fromARGB(
//                                               255, 246, 246, 250),
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(12))),
//                                   width:
//                                       MediaQuery.of(context).size.width * 1,
//                                   height:
//                                       MediaQuery.of(context).size.height *
//                                           0.11,
//                                   //0.16 original size

//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           const SizedBox(width: 6),
//                                           SizedBox(
//                                               width: 25,
//                                               child: RichText(
//                                                   text: TextSpan(
//                                                       style: DefaultTextStyle
//                                                               .of(context)
//                                                           .style,
//                                                       children: <TextSpan>[
//                                                     TextSpan(
//                                                         text: '${i + 1}',
//                                                         style: TextStyle(
//                                                           color: i == 0
//                                                               ? Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       198,
//                                                                       38,
//                                                                       65)
//                                                               : const Color
//                                                                       .fromARGB(
//                                                                   255,
//                                                                   198,
//                                                                   38,
//                                                                   65),
//                                                           fontWeight:
//                                                               FontWeight
//                                                                   .bold,
//                                                           fontSize: 15,
//                                                         )),
//                                                   ]))),
//                                           const SizedBox(width: 3),
//                                           Column(
//                                             children: [
//                                               const SizedBox(height: 13),
//                                               Container(
//                                                 height: 55,
//                                                 width: 55,
//                                                 decoration: BoxDecoration(
//                                                   image: DecorationImage(
//                                                       image: NetworkImage(
//                                                           "${participant.ParticipantImage}"),
//                                                       fit: BoxFit.fill),
//                                                   color: Colors.white,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 height: 5,
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(width: 8),
//                                           Container(
//                                               // color: Colors.red,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.52,
//                                               // height: 50,
//                                               //0.39 original
//                                               child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                   children: [
//                                                     const SizedBox(
//                                                         height: 10),
//                                                     Text(
//                                                         "  [${participant.ParticipantName.toString()}]",
//                                                         //  participant.ParticipantName.toString(),
//                                                         maxLines: 2,
//                                                         overflow:
//                                                             TextOverflow
//                                                                 .ellipsis,
//                                                         style: TextStyle(
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w400,
//                                                             color: i == 0
//                                                                 ? Colors
//                                                                     .black
//                                                                 : Colors
//                                                                     .black)),
//                                                     const SizedBox(
//                                                         height: 10),
//                                                     Container(
//                                                         width: 185,
//                                                         // double.infinity,
//                                                         // color:
//                                                         //     Colors.yellow,
//                                                         child: Row(
//                                                             // crossAxisAlignment:
//                                                             //     CrossAxisAlignment
//                                                             //         .start,
//                                                             // mainAxisAlignment:
//                                                             //     MainAxisAlignment
//                                                             //         .start,
//                                                             children: [
//                                                               LinearPercentIndicator(
//                                                                 width: 185,
//                                                                 animation:
//                                                                     true,
//                                                                 lineHeight:
//                                                                     16.0,
//                                                                 animationDuration:
//                                                                     100,
//                                                                 percent:
//                                                                     pro,
//                                                                 barRadius:
//                                                                     const Radius.circular(
//                                                                         10),
//                                                                 center: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .center,
//                                                                   children: [
//                                                                     const Icon(
//                                                                       Icons
//                                                                           .how_to_vote_rounded,
//                                                                       color:
//                                                                           Colors.white,
//                                                                       size:
//                                                                           10,
//                                                                     ),
//                                                                     Text(
//                                                                       "${participant.ParticipantTotalVotes}",
//                                                                       style: const TextStyle(
//                                                                           fontSize: 12,
//                                                                           fontWeight: FontWeight.w400,
//                                                                           color: Colors.white),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 linearStrokeCap:
//                                                                     // ignore: deprecated_member_use
//                                                                     LinearStrokeCap
//                                                                         .roundAll,
//                                                                 progressColor:
//                                                                     const Color.fromARGB(
//                                                                         255,
//                                                                         108,
//                                                                         4,
//                                                                         22),
//                                                               ),
//                                                             ]))
//                                                   ])),

//                                           isVote
//                                               ? InkWell(
//                                                   onTap: () async {
//                                                     await getUserInfo();
//                                                     setState(() {
//                                                       state = true;
//                                                       participantImage =
//                                                           participant
//                                                               .ParticipantImage!;
//                                                       participantName =
//                                                           participant
//                                                               .ParticipantName!;
//                                                       participantId =
//                                                           participant
//                                                               .ParticipantID!;
//                                                       participantsTolatVotes =
//                                                           participant
//                                                               .ParticipantTotalVotes!;
//                                                     });
//                                                   },
//                                                   child: Image.asset(
//                                                     'images/Heart Voting.png',
//                                                     // width: 38,
//                                                     scale: 12,
//                                                   ))
//                                               : Container(),
//                                           // const SizedBox(
//                                           //   width: 4,
//                                           // ),
//                                         ],
//                                       ),
//                                       //],
//                                       //),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     }),

//                 //  THIS IS COMMENTS WIDGETS
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     children: [
//                       const Text(
//                         '\n☑︎ Comments \n',
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal, fontSize: 15),
//                       ),
//                       Text('(${commentList.length.toString()})'),
//                       const Spacer(),
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => AllComments(
//                                         userinfoList: userinfoList,
//                                         eventsInfo: widget.eventsInfo,
//                                         userinfo: userInfo!,
//                                       )));
//                         },
//                         child: const Text(
//                           '\nSee all → \n',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.normal),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 // commentList.isEmpty
//                 //     ? Container()
//                 //     : Container(
//                 //         height: 300,
//                 //         decoration: BoxDecoration(color: Colors.white),
//                 //         child: ListView.builder(
//                 //             itemCount: commentList.length,
//                 //             itemBuilder: (BuildContext context, int i) {
//                 //               Userinfo? user;
//                 //               Comments com = commentList[i];
//                 //               for (var i in userinfoList) {
//                 //                 if (com.UsernameID == i.UserID) {
//                 //                   user = i;
//                 //                   break;
//                 //                 }
//                 //               }
//                 //               Timestamp? t = com.CommentDate;
//                 //               DateTime d = t!.toDate();
//                 //               return Column(
//                 //                 children: [
//                 //                   const Divider(
//                 //                     thickness: 1,
//                 //                   ),
//                 //                   Column(
//                 //                     children: [
//                 //                       Row(
//                 //                         children: [
//                 //                           const SizedBox(width: 12),
//                 //                           Container(
//                 //                             height: 45,
//                 //                             width: 45,
//                 //                             decoration: BoxDecoration(
//                 //                               image: DecorationImage(
//                 //                                   image: NetworkImage(user
//                 //                                           ?.UserImage ??
//                 //                                       "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png  "),
//                 //                                   fit: BoxFit.fill),
//                 //                               color: Colors.white,
//                 //                               shape: BoxShape.circle,
//                 //                             ),
//                 //                           ),
//                 //                           const SizedBox(width: 10),
//                 //                           RichText(
//                 //                             text: TextSpan(
//                 //                               style: DefaultTextStyle.of(
//                 //                                       context)
//                 //                                   .style,
//                 //                               children: <TextSpan>[
//                 //                                 TextSpan(
//                 //                                     text: user?.Username ??
//                 //                                         "",
//                 //                                     style: const TextStyle(
//                 //                                         color:
//                 //                                             Color.fromARGB(
//                 //                                                 255,
//                 //                                                 198,
//                 //                                                 38,
//                 //                                                 65),
//                 //                                         fontWeight:
//                 //                                             FontWeight.w400,
//                 //                                         fontSize: 13)),
//                 //                               ],
//                 //                             ),
//                 //                           ),
//                 //                         ],
//                 //                       ),
//                 //                       const SizedBox(height: 10),
//                 //                       Row(
//                 //                         children: [
//                 //                           Expanded(
//                 //                             child: Container(
//                 //                               margin: const EdgeInsets.only(
//                 //                                   left: 20),
//                 //                               width: double.infinity,
//                 //                               child: Text(
//                 //                                   '${com.CommentDescription}',
//                 //                                   textAlign:
//                 //                                       TextAlign.start,
//                 //                                   style: const TextStyle(
//                 //                                       fontWeight:
//                 //                                           FontWeight.normal,
//                 //                                       fontSize: 13)),
//                 //                             ),
//                 //                           ),
//                 //                         ],
//                 //                       ),
//                 //                       const SizedBox(
//                 //                         height: 10,
//                 //                       ),
//                 //                       Padding(
//                 //                         padding:
//                 //                             const EdgeInsets.only(left: 10),
//                 //                         child: Container(
//                 //                           margin:
//                 //                               const EdgeInsets.symmetric(
//                 //                                   horizontal: 40),
//                 //                           child: Row(
//                 //                             mainAxisAlignment:
//                 //                                 MainAxisAlignment.end,
//                 //                             children: [
//                 //                               Text(
//                 //                                   '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute} | ',
//                 //                                   style: const TextStyle(
//                 //                                     fontWeight:
//                 //                                         FontWeight.w300,
//                 //                                     fontSize: 12,
//                 //                                   )),
//                 //                               const SizedBox(
//                 //                                 width: 5,
//                 //                               ),
//                 //                               GestureDetector(
//                 //                                 onTap: () {
//                 //                                   Navigator.push(
//                 //                                       context,
//                 //                                       MaterialPageRoute(
//                 //                                           builder: (_) =>
//                 //                                               ReportComment(
//                 //                                                 userinfo:
//                 //                                                     userInfo,
//                 //                                                 com: com,
//                 //                                                 user: user!,
//                 //                                               )));
//                 //                                 },
//                 //                                 child: const Text(
//                 //                                   'Report ▷',
//                 //                                   style: TextStyle(
//                 //                                       fontSize: 13,
//                 //                                       fontWeight:
//                 //                                           FontWeight.w600),
//                 //                                 ),
//                 //                               ),
//                 //                               const SizedBox(
//                 //                                 width: 10,
//                 //                               ),
//                 //                             ],
//                 //                           ),
//                 //                         ),
//                 //                       )
//                 //                     ],
//                 //                   ),
//                 //                 ],
//                 //               );
//                 //             }),
//                 //       ),

//                 //Text('data'),
//                 // FORM STARTS FROM HERE
//                 // Form(
//                 //     key: _commentkey,
//                 //     child: Container(
//                 //       color: Colors.white,
//                 //       child: Row(
//                 //         children: [
//                 //           const SizedBox(width: 5),
//                 //           Padding(
//                 //             padding: const EdgeInsets.all(8.0),
//                 //             child: Container(
//                 //                 decoration: BoxDecoration(
//                 //                     borderRadius: const BorderRadius.all(
//                 //                         Radius.circular(10)),
//                 //                     border: Border.all(color: Colors.grey),
//                 //                     color: Colors.white),
//                 //                 height: 55,
//                 //                 width: MediaQuery.of(context).size.width *
//                 //                     0.80,
//                 //                 child: TextFormField(
//                 //                   validator: (value) {
//                 //                     if (value!.isEmpty) {
//                 //                       return "";
//                 //                     }
//                 //                     return null;
//                 //                   },
//                 //                   controller: commentController,
//                 //                   // ignore: prefer_const_constructors
//                 //                   decoration: InputDecoration(
//                 //                       contentPadding:
//                 //                           const EdgeInsets.symmetric(
//                 //                               horizontal: 10, vertical: 10),
//                 //                       hintText: '✍️ Post a comment!',
//                 //                       hintStyle:
//                 //                           const TextStyle(fontSize: 15),
//                 //                       focusedBorder: InputBorder.none,
//                 //                       enabledBorder: InputBorder.none,
//                 //                       errorBorder: InputBorder.none,
//                 //                       border: InputBorder.none,
//                 //                       focusedErrorBorder: InputBorder.none),
//                 //                 )),
//                 //           ),
//                 //           GestureDetector(
//                 //             onTap: () {
//                 //               hideKeyboard(context);
//                 //               if (_commentkey.currentState!.validate()) {
//                 //                 postComment();
//                 //               }
//                 //             },
//                 //             child: Image.asset(
//                 //               'images/comment.png',
//                 //               height: 55,
//                 //               width: 48,
//                 //             ),
//                 //           ),
//                 //           const SizedBox(
//                 //             width: 10,
//                 //           )
//                 //         ],
//                 //       ),
//                 //     )
//                 //     //: Container(),
//                 //     ),
//               ],
//             ),
//           ),
//         ),
//         state
//             ? Container(
//                 height: MediaQuery.of(context).size.height * 1,
//                 width: MediaQuery.of(context).size.width * 1,
//                 color: Colors.black54,
//                 child: Center(
//                   child: Container(
//                     height: 350,
//                     width: MediaQuery.of(context).size.width * .9,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                       color: Color.fromARGB(255, 198, 38, 65),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               const SizedBox(
//                                 width: 30,
//                               ),
//                               const Spacer(),
//                               const Text(
//                                 "▽ You are voting for ▽",
//                                 style: TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                               const Spacer(),
//                               CircleAvatar(
//                                 backgroundColor: Colors.black,
//                                 radius: 15,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       state = false;
//                                     });
//                                   },
//                                   icon: const Icon(
//                                     Icons.close,
//                                     color: Colors.white,
//                                     size: 15,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               )
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Container(
//                             height: 60,
//                             width: 60,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image:
//                                       NetworkImage("${participantImage}"),
//                                   fit: BoxFit.fill),
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             participantName,
//                             style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Container(
//                             margin:
//                                 const EdgeInsets.symmetric(horizontal: 10),
//                             child: Row(
//                               children: [
//                                 const Text(
//                                   '[Current KPoints] ',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w300,
//                                       color: Colors.white,
//                                       fontSize: 15),
//                                 ),
//                                 const SizedBox(
//                                   width: 25,
//                                 ),
//                                 Text(
//                                   '${userInfo?.TotalKPoints ?? ''}',
//                                   style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                                 Image.asset(
//                                   'images/Heart Voting.png',
//                                   height: 23,
//                                 )
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Form(
//                               key: _formkey,
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     controller: pointsController,
//                                     keyboardType: TextInputType.number,
//                                     validator: (val) {
//                                       if (val!.isEmpty) {
//                                         return "▷ Please enter KPoints.";
//                                       } else if (int.parse(val) >
//                                           (userInfo?.TotalKPoints ?? 0)) {
//                                         return "▷ You don't have enough KPoints to vote.";
//                                       } else if (int.parse(val) < 1) {
//                                         return "▷ KPoints must be greater than 0.";
//                                       }
//                                       return null;
//                                     },
//                                     style: const TextStyle(
//                                         color: Colors.black87),
//                                     decoration: const InputDecoration(
//                                         fillColor: Colors.white,
//                                         errorStyle:
//                                             TextStyle(color: Colors.white),
//                                         filled: true,
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(12))),
//                                         contentPadding:
//                                             EdgeInsets.symmetric(
//                                                 horizontal: 20),
//                                         hintText: 'Enter KPoints',
//                                         hintStyle: TextStyle(
//                                             fontWeight: FontWeight.normal,
//                                             fontSize: 15)),
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   !castVote
//                                       ? SizedBox(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               1,
//                                           child: ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                                 minimumSize:
//                                                     const Size(350, 45),
//                                                 maximumSize:
//                                                     const Size(350, 45),
//                                                 primary:
//                                                     const Color.fromARGB(
//                                                         255, 0, 0, 0),
//                                                 //background color of button//border width and color
//                                                 elevation: 0,
//                                                 //elevation of button
//                                                 shape:
//                                                     RoundedRectangleBorder(
//                                                         //to set border radius to button
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     12)),
//                                                 side: const BorderSide(
//                                                     color: Colors.white,
//                                                     //fromARGB(255, 198, 38, 65),
//                                                     width: 1)),
//                                             onPressed: () {
//                                               hideKeyboard(context);
//                                               if (_formkey.currentState!
//                                                       .validate() &&
//                                                   userInfo != null) {
//                                                 setState(() {
//                                                   castVote = true;
//                                                 });
//                                                 addVote();
//                                                 _showInterstitialAd();
//                                               }
//                                             },
//                                             child: const Text(
//                                               " → → → VOTE ← ← ←",
//                                               style: TextStyle(
//                                                   fontWeight:
//                                                       FontWeight.bold,
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         )
//                                       : SizedBox(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               1,
//                                           child: ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                               minimumSize:
//                                                   const Size(350, 45),
//                                               maximumSize:
//                                                   const Size(350, 45),
//                                               primary: const Color.fromARGB(
//                                                   255, 230, 230, 230),
//                                               //background color of button//border width and color
//                                               elevation: 0,
//                                               //elevation of button
//                                               shape: RoundedRectangleBorder(
//                                                   //to set border radius to button
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10)),
//                                             ),
//                                             onPressed: () {},
//                                             child:
//                                                 const CircularProgressIndicator(
//                                               color: Color.fromRGBO(
//                                                   196, 38, 64, 1),
//                                             ),
//                                           ),
//                                         )
//                                 ],
//                               ))
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : Container(),
//       ],
//     ),
//   ),
// );
//   }

//   addVote() async {
//     var firbase = FirebaseFirestore.instance;
//     final CollectionReference collectionRef = firbase.collection('votes');
//     var id = DateTime.now().millisecondsSinceEpoch.toString();
//     await collectionRef
//         .doc(id)
//         .set({
//           'KPointsVoted': int.parse(pointsController.text),
//           'eventId': eventsInfo.EventID,
//           'eventVotesID': id,
//           'participantID': participantId,
//           'userID': userInfo?.UserID
//         })
//         .then((value) => print("success"))
//         .onError((error, stackTrace) => print("Error: $error"));
//     final CollectionReference collectionRefEvents =
//         firbase.collection('events');

//     await collectionRefEvents
//         .doc("${eventsInfo.EventID}")
//         .update({
//           'eventTotalVotes':
//               FieldValue.increment(int.parse(pointsController.text))
//         })
//         .then((value) => print("succes"))
//         .onError((error, stackTrace) => print(error));

//     final CollectionReference collectionRefUser = firbase.collection('users');

//     await collectionRefUser
//         .doc(userInfo!.UserID)
//         .update({
//           'totalkpoints':
//               FieldValue.increment(-int.parse(pointsController.text))
//         })
//         .then((value) => print("succes"))
//         .onError((error, stackTrace) => print(error));

//     final CollectionReference collectionRefParticipant =
//         firbase.collection('participants');

//     await collectionRefParticipant
//         .doc(participantId)
//         .update({
//           'participantTotalVotes':
//               FieldValue.increment(int.parse(pointsController.text))
//         })
//         .then((value) => print("succes"))
//         .onError((error, stackTrace) => print(error));
//     final CollectionReference collectionRefUsedHistory =
//         firbase.collection('kPointsUsed');

//     DateTime currentPhoneDate = DateTime.now();
//     Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
//     // var  = DateTime.now().millisecondsSinceEpoch.toString();
//     await collectionRefUsedHistory
//         .doc(id)
//         .set({
//           'kPointsDate': FieldValue.serverTimestamp(),
//           'kPointsId': id,
//           'kPointsMethod': 'voting',
//           'kPointsOption':
//               'Voted » ${pointsController.text} | ${participantName} | ${eventsInfo.EventName}\n',
//           'kPointsValue': int.parse(pointsController.text),
//           'userId': "${userInfo?.UserID}"
//         })
//         .then((value) => print("success"))
//         .onError((error, stackTrace) => print(error));

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           duration: const Duration(seconds: 8),
//           content: Text(
//               'Thank you for voting ${pointsController.text} KPoints to $participantName !')));
//     }
//     pointsController.clear();
//     participantName = "";
//     participantId = "";
//     participantImage = "";
//     participantsTolatVotes = 0;
//     setState(() {
//       state = false;
//       castVote = false;
//     });
//     await getEventInfo();
//     await getParticipants();
//   }

// // postReport(cid) async {
// //   var firbase = FirebaseFirestore.instance;
// //   final CollectionReference collectionRef = firbase.collection('report');
// //   DateTime currentPhoneDate = DateTime.now(); //DateTime
// //
// //   Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
// //   var id = DateTime.now().millisecondsSinceEpoch.toString();
// //   await collectionRef
// //       .doc(id)
// //       .set({
// //         'WhoReportedID': userInfo?.UserID,
// //         'ReportedDate': myTimeStamp,
// //         'commentId': cid,
// //         'ReportID': id,
// //         'ReportDescription': ,
// //     'ReportAgree':
// //       })
// //       .then((value) => print("success"))
// //       .onError((error, stackTrace) => print("Error: $error"));
// //   commentController.clear();
// //   await getUserData();
// //   await getComments();
// //   if (mounted)
// //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
// //         duration: Duration(seconds: 3),
// //         content: Text("Comment Successfully")));
// // }
// }

import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kbops/dashboard_screens/report_comment.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../models/userdata.dart';
import '../../utils/functions.dart';
import '../../dashboard_screens/all_comments.dart';

class VoteNow extends StatefulWidget {
  VoteNow({Key? key, required this.eventsInfo, required this.isVote})
      : super(key: key);
  final EventsInfo eventsInfo;
  bool isVote;
  @override
  State<VoteNow> createState() => _VoteNowState(isVote, eventsInfo);
}

class _VoteNowState extends State<VoteNow> {
  var webviewLoad = true;
  bool isVote;
  _VoteNowState(this.isVote, this.eventsInfo);
  // final RefreshController _refreshController =
  //     RefreshController(initialRefresh: true);
  var commentController = TextEditingController();
  var pointsController = TextEditingController();
  EventsInfo eventsInfo;
  var castVote = false;
  final _formkey = GlobalKey<FormState>();
  final _commentkey = GlobalKey<FormState>();

  var state = false;
  List<EventsParticipant> participantsList = [];
  List<Comments> commentList = [];
  List<Userinfo> userinfoList = [];
  Userinfo? userInfo;
  Future<void> onRefresh() async {
    // monitor network fetch
    await getUserInfo();
    await getParticipants();

    await getUserData();
    setState(() {});
  }

  Future<void> getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userid = auth.currentUser!.uid.toString();
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final docs = await collectionRef.doc(userid).get();
    userInfo = Userinfo.fromMap(docs);
    // setState(() {});
  }

  Future<void> getEventInfo() async {
    final collectionRef = FirebaseFirestore.instance.collection('events');
    final docs = await collectionRef.doc(eventsInfo.EventID).get();
    eventsInfo = EventsInfo.fromMap(docs);
  }

  Future<void> getUserData() async {
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final docs = await collectionRef.get();
    userinfoList.clear();
    for (var i in docs.docs) {
      userinfoList.add(Userinfo.fromMap(i));
    }
    // setState(() {});
  }

  Future<void> getParticipants() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('participants')
        .where("eventId", isEqualTo: eventsInfo.EventID);
    var participants = await collectionRef.get();
    participantsList.clear();
    for (var doc in participants.docs) {
      participantsList.add(EventsParticipant(
          EventId: doc.get("eventId"),
          ParticipantID: doc.get("participantId"),
          ParticipantName: doc.get("participantName"),
          ParticipantImage: doc.get("participantImage"),
          ParticipantTotalVotes: doc.get("participantTotalVotes"),
          ParticipantPercentage: doc.get("participantPercentage")));
    }

    participantsList.sort((b, a) => a.ParticipantTotalVotes!
        .toInt()
        .compareTo(b.ParticipantTotalVotes!.toInt()));
    setState(() {
      isLoading = false;
    });
  }

  var participantName = '';
  var participantImage = '';
  var participantId = '';
  var isLoading = true;
  int participantsTolatVotes = 0;
  late InterstitialAd _interstitialAd;
  // final String? get bannerAdUnitID
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-4031621145325255/2612743946',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null!));
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
    log("INIT CALL AGAUB");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onRefresh();
      // await getComments();
    });
    _createInterstitialAd();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(eventsInfo.EventTotalVotes);
    log('==========>>>> BUILD WIDGET');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage("${eventsInfo.EventImage}"),
                            fit: BoxFit.fill)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showInterstitialAd();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: const Text('Event Description ▷'),
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 355,
                            width: MediaQuery.of(context).size.width * 1,
                            child: Center(
                                child: WebView(
                              gestureRecognizers: Set()
                                ..add(Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer())),
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: '${eventsInfo.EventDescription}',
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
                          ),
                          webviewLoad
                              ? Container(
                                  margin: const EdgeInsets.only(top: 40),
                                  color: Colors.white,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(196, 38, 64, 1),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: participantsList.length,
                      itemBuilder: (BuildContext context, int i) {
                        EventsParticipant participant = participantsList[i];
                        var position = 'th';
                        if (i + 1 == 1) {
                          position = 'st';
                        } else if (i + 1 == 2) {
                          position = 'nd';
                        } else if (i + 1 == 3) {
                          position = 'rd';
                        }
                        var percent = (participant.ParticipantTotalVotes! /
                                eventsInfo.EventTotalVotes!.toInt()) *
                            100;
                        var pro = percent / 100;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: i == 0
                                            ? const Color.fromARGB(
                                                255, 238, 233, 233)
                                            : const Color.fromARGB(
                                                255, 246, 246, 250),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12))),
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: MediaQuery.of(context).size.height *
                                        0.11,
                                    //0.16 original size

                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 6),
                                            SizedBox(
                                                width: 25,
                                                child: RichText(
                                                    text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                      TextSpan(
                                                          text: '${i + 1}',
                                                          style: TextStyle(
                                                            color: i == 0
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        198,
                                                                        38,
                                                                        65)
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    198,
                                                                    38,
                                                                    65),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          )),
                                                    ]))),
                                            const SizedBox(width: 3),
                                            Column(
                                              children: [
                                                const SizedBox(height: 13),
                                                Container(
                                                  height: 55,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${participant.ParticipantImage}"),
                                                        fit: BoxFit.fill),
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                                // color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.52,
                                                // height: 50,
                                                //0.39 original
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                          "  [${participant.ParticipantName.toString()}]",
                                                          //  participant.ParticipantName.toString(),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: i == 0
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .black)),
                                                      const SizedBox(
                                                          height: 10),
                                                      Container(
                                                          width: 185,
                                                          // double.infinity,
                                                          // color:
                                                          //     Colors.yellow,
                                                          child: Row(
                                                              // crossAxisAlignment:
                                                              //     CrossAxisAlignment
                                                              //         .start,
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment
                                                              //         .start,
                                                              children: [
                                                                LinearPercentIndicator(
                                                                  width: 185,
                                                                  animation:
                                                                      true,
                                                                  lineHeight:
                                                                      16.0,
                                                                  animationDuration:
                                                                      100,
                                                                  percent: pro,
                                                                  barRadius:
                                                                      const Radius
                                                                          .circular(
                                                                          10),
                                                                  center: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .how_to_vote_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        "${participant.ParticipantTotalVotes}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  linearStrokeCap:
                                                                      // ignore: deprecated_member_use
                                                                      LinearStrokeCap
                                                                          .roundAll,
                                                                  progressColor:
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          108,
                                                                          4,
                                                                          22),
                                                                ),
                                                              ]))
                                                    ])),

                                            isVote
                                                ? InkWell(
                                                    onTap: () async {
                                                      log('message');
                                                      await getUserInfo();
                                                      setState(() {
                                                        state = true;
                                                        participantImage =
                                                            participant
                                                                .ParticipantImage!;
                                                        participantName =
                                                            participant
                                                                .ParticipantName!;
                                                        participantId =
                                                            participant
                                                                .ParticipantID!;
                                                        participantsTolatVotes =
                                                            participant
                                                                .ParticipantTotalVotes!;
                                                      });
                                                    },
                                                    child: Image.asset(
                                                      'images/Heart Voting.png',
                                                      // width: 38,
                                                      scale: 10,
                                                    ))
                                                : Container(),
                                            // const SizedBox(
                                            //   width: 4,
                                            // ),
                                          ],
                                        ),
                                        //],
                                        //),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),

                  //  THIS IS COMMENTS WIDGETS
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text(
                          '\n☑︎ Comments \n',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                        // Text('(${commentList.length.toString()})'),
                        const Spacer(),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AllComments(
                                          userinfoList: userinfoList,
                                          eventsInfo: widget.eventsInfo,
                                          userinfo: userInfo!,
                                        )));
                          },
                          child: const Text(
                            '\nSee all → \n',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  ),
                  // commentList.isEmpty
                  //     ? Container()
                  //     : Container(
                  //         height: 300,
                  //         decoration: BoxDecoration(color: Colors.white),
                  //         child: ListView.builder(
                  //             itemCount: commentList.length,
                  //             itemBuilder: (BuildContext context, int i) {
                  //               Userinfo? user;
                  //               Comments com = commentList[i];
                  //               for (var i in userinfoList) {
                  //                 if (com.UsernameID == i.UserID) {
                  //                   user = i;
                  //                   break;
                  //                 }
                  //               }
                  //               Timestamp? t = com.CommentDate;
                  //               DateTime d = t!.toDate();
                  //               return Column(
                  //                 children: [
                  //                   const Divider(
                  //                     thickness: 1,
                  //                   ),
                  //                   Column(
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           const SizedBox(width: 12),
                  //                           Container(
                  //                             height: 45,
                  //                             width: 45,
                  //                             decoration: BoxDecoration(
                  //                               image: DecorationImage(
                  //                                   image: NetworkImage(user
                  //                                           ?.UserImage ??
                  //                                       "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png  "),
                  //                                   fit: BoxFit.fill),
                  //                               color: Colors.white,
                  //                               shape: BoxShape.circle,
                  //                             ),
                  //                           ),
                  //                           const SizedBox(width: 10),
                  //                           RichText(
                  //                             text: TextSpan(
                  //                               style: DefaultTextStyle.of(
                  //                                       context)
                  //                                   .style,
                  //                               children: <TextSpan>[
                  //                                 TextSpan(
                  //                                     text: user?.Username ??
                  //                                         "",
                  //                                     style: const TextStyle(
                  //                                         color:
                  //                                             Color.fromARGB(
                  //                                                 255,
                  //                                                 198,
                  //                                                 38,
                  //                                                 65),
                  //                                         fontWeight:
                  //                                             FontWeight.w400,
                  //                                         fontSize: 13)),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       const SizedBox(height: 10),
                  //                       Row(
                  //                         children: [
                  //                           Expanded(
                  //                             child: Container(
                  //                               margin: const EdgeInsets.only(
                  //                                   left: 20),
                  //                               width: double.infinity,
                  //                               child: Text(
                  //                                   '${com.CommentDescription}',
                  //                                   textAlign:
                  //                                       TextAlign.start,
                  //                                   style: const TextStyle(
                  //                                       fontWeight:
                  //                                           FontWeight.normal,
                  //                                       fontSize: 13)),
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       const SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       Padding(
                  //                         padding:
                  //                             const EdgeInsets.only(left: 10),
                  //                         child: Container(
                  //                           margin:
                  //                               const EdgeInsets.symmetric(
                  //                                   horizontal: 40),
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.end,
                  //                             children: [
                  //                               Text(
                  //                                   '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute} | ',
                  //                                   style: const TextStyle(
                  //                                     fontWeight:
                  //                                         FontWeight.w300,
                  //                                     fontSize: 12,
                  //                                   )),
                  //                               const SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               GestureDetector(
                  //                                 onTap: () {
                  //                                   Navigator.push(
                  //                                       context,
                  //                                       MaterialPageRoute(
                  //                                           builder: (_) =>
                  //                                               ReportComment(
                  //                                                 userinfo:
                  //                                                     userInfo,
                  //                                                 com: com,
                  //                                                 user: user!,
                  //                                               )));
                  //                                 },
                  //                                 child: const Text(
                  //                                   'Report ▷',
                  //                                   style: TextStyle(
                  //                                       fontSize: 13,
                  //                                       fontWeight:
                  //                                           FontWeight.w600),
                  //                                 ),
                  //                               ),
                  //                               const SizedBox(
                  //                                 width: 10,
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ],
                  //               );
                  //             }),
                  //       ),

                  //Text('data'),
                  // FORM STARTS FROM HERE
                  // Form(
                  //     key: _commentkey,
                  //     child: Container(
                  //       color: Colors.white,
                  //       child: Row(
                  //         children: [
                  //           const SizedBox(width: 5),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Container(
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: const BorderRadius.all(
                  //                         Radius.circular(10)),
                  //                     border: Border.all(color: Colors.grey),
                  //                     color: Colors.white),
                  //                 height: 55,
                  //                 width: MediaQuery.of(context).size.width *
                  //                     0.80,
                  //                 child: TextFormField(
                  //                   validator: (value) {
                  //                     if (value!.isEmpty) {
                  //                       return "";
                  //                     }
                  //                     return null;
                  //                   },
                  //                   controller: commentController,
                  //                   // ignore: prefer_const_constructors
                  //                   decoration: InputDecoration(
                  //                       contentPadding:
                  //                           const EdgeInsets.symmetric(
                  //                               horizontal: 10, vertical: 10),
                  //                       hintText: '✍️ Post a comment!',
                  //                       hintStyle:
                  //                           const TextStyle(fontSize: 15),
                  //                       focusedBorder: InputBorder.none,
                  //                       enabledBorder: InputBorder.none,
                  //                       errorBorder: InputBorder.none,
                  //                       border: InputBorder.none,
                  //                       focusedErrorBorder: InputBorder.none),
                  //                 )),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               hideKeyboard(context);
                  //               if (_commentkey.currentState!.validate()) {
                  //                 postComment();
                  //               }
                  //             },
                  //             child: Image.asset(
                  //               'images/comment.png',
                  //               height: 55,
                  //               width: 48,
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             width: 10,
                  //           )
                  //         ],
                  //       ),
                  //     )
                  //     //: Container(),
                  //     ),
                ],
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
                          color: Color.fromARGB(255, 198, 38, 65),
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
                                    "▽ You are voting for ▽",
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
                                      image:
                                          NetworkImage("${participantImage}"),
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    const Text(
                                      '[Current KPoints] ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      '${userInfo?.TotalKPoints ?? ''}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
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
                                      TextFormField(
                                        controller: pointsController,
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "▷ Please enter KPoints.";
                                          } else if (int.parse(val) >
                                              (userInfo?.TotalKPoints ?? 0)) {
                                            return "▷ You don't have enough KPoints to vote.";
                                          } else if (int.parse(val) < 1) {
                                            return "▷ KPoints must be greater than 0.";
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
                                                    Radius.circular(12))),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20),
                                            hintText: 'Enter KPoints',
                                            hintStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      !castVote
                                          ? SizedBox(
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
                                                    primary:
                                                        const Color.fromARGB(
                                                            255, 0, 0, 0),
                                                    //background color of button//border width and color
                                                    elevation: 0,
                                                    //elevation of button
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            //to set border radius to button
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    side: const BorderSide(
                                                        color: Colors.white,
                                                        //fromARGB(255, 198, 38, 65),
                                                        width: 1)),
                                                onPressed: () {
                                                  hideKeyboard(context);
                                                  if (_formkey.currentState!
                                                          .validate() &&
                                                      userInfo != null) {
                                                    setState(() {
                                                      castVote = true;
                                                    });
                                                    addVote();
                                                    _showInterstitialAd();
                                                  }
                                                },
                                                child: const Text(
                                                  " → → → VOTE ← ← ←",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : SizedBox(
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
                                                      255, 230, 230, 230),
                                                  //background color of button//border width and color
                                                  elevation: 0,
                                                  //elevation of button
                                                  shape: RoundedRectangleBorder(
                                                      //to set border radius to button
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
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
          ],
        ),
      ),
    );
  }

  addVote() async {
    var firbase = FirebaseFirestore.instance;
    final CollectionReference collectionRef = firbase.collection('votes');
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRef
        .doc(id)
        .set({
          'KPointsVoted': int.parse(pointsController.text),
          'eventId': eventsInfo.EventID,
          'eventVotesID': id,
          'participantID': participantId,
          'userID': userInfo?.UserID
        })
        .then((value) => debugPrint("success"))
        .onError((error, stackTrace) => debugPrint("Error: $error"));
    final CollectionReference collectionRefEvents =
        firbase.collection('events');

    await collectionRefEvents
        .doc("${eventsInfo.EventID}")
        .update({
          'eventTotalVotes':
              FieldValue.increment(int.parse(pointsController.text))
        })
        .then((value) => debugPrint("succes"))
        .onError((error, stackTrace) => debugPrint(error.toString()));

    final CollectionReference collectionRefUser = firbase.collection('users');

    await collectionRefUser
        .doc(userInfo!.UserID)
        .update({
          'totalkpoints':
              FieldValue.increment(-int.parse(pointsController.text))
        })
        .then((value) => debugPrint("succes"))
        .onError((error, stackTrace) => debugPrint(error.toString()));

    final CollectionReference collectionRefParticipant =
        firbase.collection('participants');

    await collectionRefParticipant
        .doc(participantId)
        .update({
          'participantTotalVotes':
              FieldValue.increment(int.parse(pointsController.text))
        })
        .then((value) => debugPrint("succes"))
        .onError((error, stackTrace) => debugPrint(error.toString()));
    final CollectionReference collectionRefUsedHistory =
        firbase.collection('kPointsUsed');

    DateTime currentPhoneDate = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    // var  = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRefUsedHistory
        .doc(id)
        .set({
          'kPointsDate': FieldValue.serverTimestamp(),
          'kPointsId': id,
          'kPointsMethod': 'voting',
          'kPointsOption':
              'Voted » ${pointsController.text} | ${participantName} | ${eventsInfo.EventName}\n',
          'kPointsValue': int.parse(pointsController.text),
          'userId': "${userInfo?.UserID}"
        })
        .then((value) => debugPrint("success"))
        .onError((error, stackTrace) => debugPrint(error.toString()));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 8),
          content: Text(
              'Thank you for voting ${pointsController.text} KPoints to $participantName !')));
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
    await getEventInfo();
    await getParticipants();
  }

  postComment() async {
    var firbase = FirebaseFirestore.instance;
    final CollectionReference collectionRef = firbase.collection('comments');
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRef
        .doc(id)
        .set({
          'commentDate': FieldValue.serverTimestamp(),
          'commentDescription': commentController.text,
          'commentId': id,
          'eventId': eventsInfo.EventID,
          'userId': userInfo?.UserID,
          'userName': userInfo?.Username
        })
        .then((value) => debugPrint("success"))
        .onError((error, stackTrace) => debugPrint("Error: $error"));
    commentController.clear();
    await getUserData();
    // await getComments();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Text("[✓]The comment has been posted.")));
    }
  }
}
