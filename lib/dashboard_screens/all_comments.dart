// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:kbops/dashboard_screens/report_comment.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';
// import 'package:provider/provider.dart';
// import '../models/userdata.dart';
// import '../state_management/comment_state_provider.dart';
// import '../state_management/user_info_provider.dart';
// import '../state_management/user_list.dart';
// import '../utils/functions.dart';

// class AllComments extends StatefulWidget {
//   AllComments({
//     Key? key,
//     required this.userinfo,
//     required this.eventsInfo,
//   }) : super(key: key);
//   EventsInfo eventsInfo;
//   // List<Userinfo> userinfoList;
//   Userinfo userinfo;
//   @override
//   State<AllComments> createState() => _AllCommentsState(eventsInfo, userinfo);
// }

// class _AllCommentsState extends State<AllComments> {
//   _AllCommentsState(this.eventsInfo, this.userinfo);
//   EventsInfo eventsInfo;
//   Userinfo userinfo;
//   final _commentkey = GlobalKey<FormState>();
//   var commentController = TextEditingController();

//   // List<Comments> commentList = [];
//   // List<Userinfo> userinfoList;
//   // Future<void> getComments() async {
//   //   final collectionRef = FirebaseFirestore.instance
//   //       .collection('comments')
//   //       .orderBy('commentDate', descending: true)
//   //       .where("eventId", isEqualTo: eventsInfo.EventID);
//   //   var comments = await collectionRef.get();
//   //   print("comments");
//   //   print(comments.docs);
//   //   commentList.clear();
//   //   for (var doc in comments.docs) {
//   //     commentList.add(Comments(
//   //         CommentID: doc.get('commentId'),
//   //         UsernameID: doc.get('userId'),
//   //         CommentDescription: doc.get('commentDescription'),
//   //         CommentDate: doc.get('commentDate'),
//   //         EventId: 'eventId'));
//   //   }
//   //   isLoading = false;
//   //   setState(() {});
//   // }
//   late UserListProvider provider;
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       provider = Provider.of<UserListProvider>(context, listen: false);
//       provider.getUserData2();
//       // getComments();
//       // await Provider.of<UserProvider>(context).getUserData();
//       // await getUserData();
//     });
//   }

//   // Future<void> getUserData() async {
//   //   final collectionRef = FirebaseFirestore.instance.collection('users');
//   //   final docs = await collectionRef.get();
//   //   userinfoList.clear();
//   //   for (var i in docs.docs) {
//   //     userinfoList.add(Userinfo.fromMap(i));
//   //   }
//   //   setState(() {});
//   // }

//   postComment() async {
//     try {
//       var firbase = FirebaseFirestore.instance;
//       final CollectionReference collectionRef = firbase.collection('comments');
//       DateTime currentPhoneDate = DateTime.now(); //DateTime
//       Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
//       var id = DateTime.now().millisecondsSinceEpoch.toString();
//       await collectionRef
//           .doc(id)
//           .set({
//             'commentDate': FieldValue.serverTimestamp(),
//             'commentDescription': commentController.text,
//             'commentId': id,
//             'eventId': eventsInfo.EventID,
//             'userId': widget.userinfo.UserID
//           })
//           .then((value) => print("success"))
//           .onError((error, stackTrace) => print("Error: $error"));
//       commentController.clear();
//       setState(() {});
//       // await getUserData();
//       // Provider.of<UserProvider>(context, listen: false).getUserData();
//       await Provider.of<CommentProvider>(context, listen: false)
//           .getComments(widget.eventsInfo.EventID!);
//       // await getComments();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             duration: Duration(seconds: 3),
//             content: Text("[✓] Comment has been posted.")));
//       }
//     } catch (e) {
//       print('errorr $e');
//     }
//   }

//   @override
//   void dispose() {
//     log('DISPOSE');
//     provider.dispose();
//     provider.nameInfoList.clear();
//     // Provider.of<UserProvider>(context, listen: false).getUserInfo();

//     super.dispose();
//   }

//   var isLoading = true;
//   @override
//   Widget build(BuildContext context) {
//     print('build call');
//     // Provider.of<UserProvider>(context).getUserData2();
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 198, 37, 65),
//         centerTitle: true,
//         title: const Text(
//           "All Comments",
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Form(
//           //     key: _commentkey,
//           //     child: Container(
//           //       color: Colors.white,
//           //       child: Row(
//           //         children: [
//           //           const SizedBox(width: 5),
//           //           Padding(
//           //             padding: const EdgeInsets.all(8.0),
//           //             child: Container(
//           //                 decoration: BoxDecoration(
//           //                     borderRadius:
//           //                         const BorderRadius.all(Radius.circular(10)),
//           //                     border: Border.all(color: Colors.grey),
//           //                     color: Colors.white),
//           //                 height: 55,
//           //                 width: MediaQuery.of(context).size.width * 0.80,
//           //                 child: TextFormField(
//           //                   validator: (value) {
//           //                     if (value!.isEmpty) {
//           //                       return "";
//           //                     }
//           //                     return null;
//           //                   },
//           //                   controller: commentController,
//           //                   decoration: const InputDecoration(
//           //                       contentPadding: EdgeInsets.symmetric(
//           //                           horizontal: 10, vertical: 10),
//           //                       hintText: '✍️ Post a comment!',
//           //                       hintStyle: TextStyle(fontSize: 15),
//           //                       focusedBorder: InputBorder.none,
//           //                       enabledBorder: InputBorder.none,
//           //                       errorBorder: InputBorder.none,
//           //                       border: InputBorder.none,
//           //                       focusedErrorBorder: InputBorder.none),
//           //                 )),
//           //           ),
//           //           GestureDetector(
//           //             onTap: () {
//           //               // hideKeyboard(context);
//           //               if (_commentkey.currentState!.validate()) {
//           //                 postComment();
//           //               }
//           //             },
//           //             child: Image.asset(
//           //               'images/comment.png',
//           //               height: 55,
//           //               width: 48,
//           //             ),
//           //           ),
//           //           // const SizedBox(width: 5)
//           //         ],
//           //       ),
//           //     )
//           //     //: Container(),
//           //     ),
//           Consumer<CommentProvider>(builder: (context, commentProvider, _) {
//             return Form(
//               child: Container(
//                 color: Colors.white,
//                 child: Row(
//                   children: [
//                     SizedBox(width: 5),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           border: Border.all(color: Colors.grey),
//                           color: Colors.white,
//                         ),
//                         height: 55,
//                         width: MediaQuery.of(context).size.width * 0.80,
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return "";
//                             }
//                             return null;
//                           },
//                           controller: commentController,
//                           decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             hintText: '✍️ Post a comment!',
//                             hintStyle: TextStyle(fontSize: 15),
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             border: InputBorder.none,
//                             focusedErrorBorder: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // print('1 ${widget.eventsInfo.EventID}');
//                         // print(' ${widget.eventsInfo.EventID}');
//                         // if (_commentkey.currentState!.validate()) {
//                         commentProvider.postComment(
//                             commentController.text,
//                             widget.eventsInfo.EventID!,
//                             widget.userinfo.UserID!);
//                         commentController.clear();
//                         // }
//                         setState(() {});
//                       },
//                       child: Image.asset(
//                         'images/comment.png',
//                         height: 55,
//                         width: 48,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//           StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('comments')
//                   .orderBy('commentDate', descending: true)
//                   .where("eventId", isEqualTo: eventsInfo.EventID)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator(color: Colors.red[900]);
//                 }
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 }
//                 final pagination = Consumer<UserListProvider>(
//                     builder: (context, proivderUserList, child) {
//                   return Expanded(
//                     child: PaginateFirestore(
//                       //item builder type is compulsory.
//                       itemBuilder: (context, documentSnapshots, index) {
//                         final data = documentSnapshots[index].data() as Map?;
//                         Userinfo? user;
//                         Comments com = Comments.fromMap(data);
//                         // log("user ${user}");
//                         for (var i in proivderUserList.nameInfoList) {
//                           if (com.UsernameID == i.UserID) {
//                             user = i;
//                             // log("user ${user}");
//                             // print("user ${user}");
//                             break;
//                           }
//                         }
//                         Timestamp? t = com.CommentDate;
//                         DateTime? d = t?.toDate();

//                         return Column(
//                           children: [
//                             const Divider(
//                               thickness: 1,
//                             ),
//                             Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     Container(
//                                       height: 45,
//                                       width: 45,
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                             image: NetworkImage(user
//                                                     ?.UserImage ??
//                                                 "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
//                                             fit: BoxFit.fill),
//                                         color: Colors.white,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     RichText(
//                                       text: TextSpan(
//                                         style:
//                                             DefaultTextStyle.of(context).style,
//                                         children: <TextSpan>[
//                                           TextSpan(
//                                               text: user?.Username ?? "",
//                                               style: const TextStyle(
//                                                   color: Color.fromARGB(
//                                                       255, 198, 38, 65),
//                                                   fontWeight: FontWeight.w400,
//                                                   fontSize: 13)),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(left: 20.0),
//                                         child: SizedBox(
//                                           width: 350,
//                                           child: Text(
//                                               '${com.CommentDescription}',
//                                               textAlign: TextAlign.start,
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 13)),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 40),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         Text(
//                                             '${d?.year}-${d?.month}-${d?.day}  ${d?.hour}:${d?.minute} |',
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.w300,
//                                               fontSize: 12,
//                                             )),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (_) =>
//                                                         ReportComment(
//                                                           userinfo: userinfo,
//                                                           com: com,
//                                                           user: user!,
//                                                         )));
//                                           },
//                                           child: const Text(
//                                             'Report ▷',
//                                             style: TextStyle(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         );
//                       },
//                       // orderBy is compulsory to enable pagination
//                       initialLoader: const CircularProgressIndicator(
//                           color: Color.fromRGBO(196, 38, 64, 1)),

//                       query: FirebaseFirestore.instance
//                           .collection('comments')
//                           .orderBy('commentDate', descending: true)
//                           .where("eventId", isEqualTo: eventsInfo.EventID),
//                       //Change types accordingly
//                       itemBuilderType: PaginateBuilderType.listView,
//                       // to fetch real-time data
//                       isLive: false,
//                     ),
//                   );
//                 });
//                 return pagination;
// // return Expanded(
//                 //   child: ListView.builder(
//                 //       itemCount: commentDocs.length,
//                 //       itemBuilder: (context, index) {
//                 //         final data =
//                 //             commentDocs[index].data() as Map<String, dynamic>?;
//                 //         final com = Comments.fromMap(data);
//                 //         print(com.CommentDescription);
//                 //         for (var i in userinfoList) {
//                 //           if (com.UsernameID == i.UserID) {
//                 //             user = i;
//                 //             break;
//                 //           }
//                 //         }
//                 //         Timestamp? t = com.CommentDate;
//                 //         DateTime? d = t?.toDate();
//                 //         return  }),
//                 // );
//               }),
//           // const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:kbops/dashboard_screens/report_comment.dart';
// // import 'package:paginate_firestore/paginate_firestore.dart';
// // import '../models/userdata.dart';

// // class AllComments extends StatefulWidget {
// //   AllComments(
// //       {Key? key,
// //       required this.userinfo,
// //       required this.eventsInfo,
// //       required this.userinfoList})
// //       : super(key: key);
// //   EventsInfo eventsInfo;
// //   List<Userinfo> userinfoList;
// //   Userinfo userinfo;
// //   @override
// //   State<AllComments> createState() =>
// //       _AllCommentsState(eventsInfo, userinfoList, userinfo);
// // }

// // class _AllCommentsState extends State<AllComments> {
// //   _AllCommentsState(this.eventsInfo, this.userinfoList, this.userinfo);
// //   EventsInfo eventsInfo;
// //   Userinfo userinfo;

// //   List<Comments> commentList = [];
// //   List<Userinfo> userinfoList;
// //   Future<void> getComments() async {
// //     // final collectionRef = FirebaseFirestore.instance
// //     //     .collection('comments')
// //     //     .orderBy('commentDate', descending: true)
// //     //     .where("eventId", isEqualTo: eventsInfo.EventID);
// //     // var comments = await collectionRef.get();
// //     print("comments");
// //     // print(comments.docs);
// //     // commentList.clear();
// //     // for (var doc in comments.docs) {
// //     //   commentList.add(Comments(
// //     //       CommentID: doc.get('commentId'),
// //     //       UsernameID: doc.get('userId'),
// //     //       CommentDescription: doc.get('commentDescription'),
// //     //       CommentDate: doc.get('commentDate'), EventId: 'eventId'));
// //     // }
// //     isLoading = false;
// //     setState(() {});
// //   }

// //   @override
// //   void initState() {
// //     super.initState();

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       // getComments();
// //     });
// //   }

// //   var isLoading = true;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: const Color.fromARGB(255, 198, 37, 65),
// //         centerTitle: true,
// //         title: const Text(
// //           "All Comments",
// //           style: TextStyle(
// //             fontSize: 18,
// //             color: Colors.white,
// //           ),
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: PaginateFirestore(
// //               //item builder type is compulsory.
// //               itemBuilder: (context, documentSnapshots, index) {
// //                 final data = documentSnapshots[index].data() as Map?;
// //                 Userinfo? user;
// //                 Comments com = Comments.fromMap(data);
// //                 print(com.CommentDescription);
// //                 for (var i in userinfoList) {
// //                   if (com.UsernameID == i.UserID) {
// //                     user = i;
// //                     break;
// //                   }
// //                 }
// //                 Timestamp? t = com.CommentDate;
// //                 DateTime? d = t?.toDate();

// //                 return Column(
// //                   children: [
// //                     const Divider(
// //                       thickness: 1,
// //                     ),
// //                     Column(
// //                       children: [
// //                         Row(
// //                           children: [
// //                             const SizedBox(
// //                               width: 10,
// //                             ),
// //                             Container(
// //                               height: 45,
// //                               width: 45,
// //                               decoration: BoxDecoration(
// //                                 image: DecorationImage(
// //                                     image: NetworkImage(
// //                                         "${user?.UserImage ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"}"),
// //                                     fit: BoxFit.fill),
// //                                 color: Colors.white,
// //                                 shape: BoxShape.circle,
// //                               ),
// //                             ),
// //                             const SizedBox(
// //                               width: 10,
// //                             ),
// //                             RichText(
// //                               text: TextSpan(
// //                                 style: DefaultTextStyle.of(context).style,
// //                                 children: <TextSpan>[
// //                                   TextSpan(
// //                                       text: user?.Username ?? "null",
// //                                       style: const TextStyle(
// //                                           color:
// //                                               Color.fromARGB(255, 91, 78, 78),
// //                                           fontWeight: FontWeight.w400,
// //                                           fontSize: 13)),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(
// //                           height: 10,
// //                         ),
// //                         Row(
// //                           children: [
// //                             Expanded(
// //                               child: Padding(
// //                                 padding: const EdgeInsets.only(left: 20.0),
// //                                 child: SizedBox(
// //                                   width: 350,
// //                                   child: Text('${com.CommentDescription}',
// //                                       textAlign: TextAlign.start,
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.normal,
// //                                           fontSize: 13)),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(
// //                           height: 10,
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 10),
// //                           child: Container(
// //                             margin: const EdgeInsets.symmetric(horizontal: 40),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.end,
// //                               children: [
// //                                 Text(
// //                                     '${d?.year}-${d?.month}-${d?.day}  ${d?.hour}:${d?.minute} |',
// //                                     style: const TextStyle(
// //                                       fontWeight: FontWeight.w300,
// //                                       fontSize: 12,
// //                                     )),
// //                                 const SizedBox(
// //                                   width: 5,
// //                                 ),
// //                                 GestureDetector(
// //                                   onTap: () {
// //                                     Navigator.push(
// //                                         context,
// //                                         MaterialPageRoute(
// //                                             builder: (_) => ReportComment(
// //                                                   userinfo: userinfo,
// //                                                   com: com,
// //                                                   user: user!,
// //                                                 )));
// //                                   },
// //                                   child: Icon(Icons.report,
// //                                       color: Colors.black45, size: 16),
// //                                 ),
// //                                 /*const Text(
// //                                     '[Report]',
// //                                     style: TextStyle(
// //                                         fontSize: 12,
// //                                         fontWeight: FontWeight.w600),
// //                                   ),
// //                                 ),*/
// //                                 const SizedBox(
// //                                   width: 10,
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         )
// //                       ],
// //                     )
// //                   ],
// //                 );
// //               },
// //               // orderBy is compulsory to enable pagination
// //               initialLoader: const CircularProgressIndicator(
// //                   color: Color.fromARGB(255, 255, 193, 32)),

// //               query: FirebaseFirestore.instance
// //                   .collection('comments')
// //                   .orderBy('commentDate', descending: true)
// //                   .where("eventId", isEqualTo: eventsInfo.EventID),
// //               //Change types accordingly
// //               itemBuilderType: PaginateBuilderType.listView,
// //               // to fetch real-time data
// //               isLive: false,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
