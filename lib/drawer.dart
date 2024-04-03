import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kbops/image_docs.dart';
import 'package:kbops/models/userdata.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

import 'dashboard_screens/report_comment.dart';

class Lastest extends StatefulWidget {
  const Lastest({super.key});

  @override
  State<Lastest> createState() => _LastestState();
}

class _LastestState extends State<Lastest> {
  late Userinfo userInfo;
  List<EventsParticipant> participantsList = [];
  List<Comments> commentList = [];
  List<Userinfo>? userinfoList;

  @override
  void initState() {
    super.initState();

    // getitemCount();
    //_tabController2 = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserInfo();
      await getImages2();

      if (mounted) setState(() {});
    });
  }

  Future<void> likeOrUnlikeImage({
    required String docId,
    required List<String> users,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('userImages')
          .doc(docId)
          .update({'likedBy': users}).then((value) {
        if (mounted)
          setState(() {
            users.insert(0, docId);
          });
      });
    } catch (e) {
      //TODO: Error handling
    }
  }

  Future<void> commentsLikes(
      {required String dcId, required List<String> userIdLikeOne}) async {
    try {
      await FirebaseFirestore.instance
          .collection('communityComment')
          .doc(dcId)
          .update({'likedBy': userIdLikeOne});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userid = auth.currentUser!.uid.toString();
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final docs = await collectionRef.doc(userid).get();
    userInfo = Userinfo.fromMap(docs);
    if (mounted) setState(() {});
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  void _onRefresh() async {
    setState(() {});

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  bool isLiked = false;
  Future<void> getImages2() async {
    log('Get Images');
    if (mounted)
      setState(() {
        isImagesLoading = true;
      });

    final snapshots = await FirebaseFirestore.instance
        .collection('userImages')
        .orderBy('uploadTime', descending: true)
        .get();
    images = snapshots.docs
        .map((e) => FirebaseImageModel.fromJson(e.data()))
        .toList();
    //log('IMAGES:: ${images.length.toString()}');
    if (mounted)
      setState(() {
        isImagesLoading = false;
      });
  }

  bool gettingMoreProducts = false;
  bool moreProductsAvailable = true;

  bool isImagesLoading = false;
  bool isLoading = true;
  List<FirebaseImageModel> images = List.empty(growable: true);
// This function adds a new comment to Firestore
  Future<void> addComment(String text) async {
    if (text.isNotEmpty && text != '') {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the current time
        DateTime now = DateTime.now();
        // Convert the time to a string
        String time = now.toString();
        // Add the comment to Firestore
        int data = 0;
        await FirebaseFirestore.instance.collection('communityComment').add({
          'text': text,
          'userId': user.uid,
          'userName': user.displayName,
          'profileImage': user.photoURL ?? "",
          'time': time,
          'likes': 0,
        });
        log("TIme :: ${time.toString()}");
      }
    } else {
      print('write some testt');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          clipBehavior: Clip.antiAlias,
          //action:SnackBarAction(label: ,)
          behavior: SnackBarBehavior.floating, // Set behavior to floating
          margin:
              EdgeInsets.only(top: 0, right: 8.0, left: 8.0), // Custom margin

          content: Text('Write Some Comments'),
          duration:
              Duration(seconds: 2), // How long the SnackBar should be visible
        ),
      );
    }
  }

  EventsInfo? eventsInfo;
  Userinfo? userinfo;

  Storage storage = Storage();
  int itemCount = 0;
  //List<dynamic> likedBy = List.empty(growable: true);
  bool iscomment = false;
  final _textController = TextEditingController();
// This function adds a new comment to Firestore
  // Future<void> addComment(String text) async {
  //   // Get the current user
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     // Get the current time
  //     DateTime now = DateTime.now();
  //     // Convert the time to a string
  //     String time = now.toString();
  //     // Add the comment to Firestore
  //     await FirebaseFirestore.instance.collection('communityComment').add({
  //       'text': text,
  //       'userId': user.uid,
  //       'userName': user.displayName,
  //       'time': time,
  //       'profileImage': user.photoURL,
  //       'likes': 0
  //     });
  //   }
  // }
  List<CommunityComment> commentsCommunity = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: InkWell(
      //   onTap: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => ChatNewScreen()));
      //   },
      //   child: Container(
      //     height: 50,
      //     width: 50,
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: const Color.fromARGB(255, 196, 38, 64),
      //     ),
      //     child: Icon(
      //       Icons.comment,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 198, 37, 65),
        title: Text('Live Chat'),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('communityComment')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                commentsCommunity = snapshot.data!.docs.map((document) {
                  final indexItem = document.data() as Map<String, dynamic>;
                  return CommunityComment.fromJson(indexItem, 'id');
                }).toList();
                final pagination = PaginateFirestore(
                    physics: const BouncingScrollPhysics(),
                    itemBuilderType: PaginateBuilderType.listView,
                    //  isLive: false,
                    query: FirebaseFirestore.instance
                        .collection('communityComment')
                        .limit(5)
                        .orderBy('time', descending: true),
                    itemsPerPage: 1,
                    itemBuilder: (context, documentSnapshot, index) {
                      final image = commentsCommunity[index];
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const Divider(thickness: 1),
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        const SizedBox(width: 10),
                                        image.profileImage.isEmpty
                                            ? Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/main_icons.png'),
                                                      fit: BoxFit.fill),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                            : Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          image.profileImage),
                                                      fit: BoxFit.fill),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                        const SizedBox(width: 8),
                                        RichText(
                                            text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                              TextSpan(
                                                  text: image.userName ?? "",
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 91, 78, 78),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13)),
                                            ]))
                                      ]),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Row(children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            ReportComment()));
                                              },
                                              child: Icon(Icons.report,
                                                  color: Colors.black45,
                                                  size: 16),
                                              /*const Text('[Report]',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal)
                                                )*/
                                            ),
                                          ]))
                                    ]),
                                const SizedBox(height: 10),
                                Row(children: [
                                  Expanded(
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: SizedBox(
                                              width: 350,
                                              child: Text(image.text,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13)))))
                                ]),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  final user = FirebaseAuth
                                                      .instance.currentUser;

                                                  final commentRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'communityComment')
                                                          .doc(documentSnapshot[
                                                                  index]
                                                              .id);
                                                  final likesRef =
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('likes')
                                                          .doc(documentSnapshot[
                                                                  index]
                                                              .id);

                                                  final likesDoc =
                                                      await likesRef.get();
                                                  final likedBy = likesDoc
                                                          .data()
                                                          ?.keys
                                                          ?.toList() ??
                                                      [];

                                                  if (likedBy
                                                      .contains(user?.uid)) {
                                                    // User has already liked this comment, remove the like.

                                                    await likesRef.update({
                                                      user!.uid:
                                                          FieldValue.delete(),
                                                    });
                                                    await commentRef.update({
                                                      'likes':
                                                          FieldValue.increment(
                                                              -1),
                                                    });
                                                    var snackBar = SnackBar(
                                                        content: Text(
                                                            'Unliked a comment'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  } else {
                                                    // User hasn't liked this comment yet, add the like.

                                                    await likesRef.set({
                                                      user!.uid: true,
                                                    }, SetOptions(merge: true));
                                                    await commentRef.update({
                                                      'likes':
                                                          FieldValue.increment(
                                                              1),
                                                    });
                                                    var snackBar = SnackBar(
                                                        content: Text(
                                                            'Liked a comment'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                  setState(() {
                                                    image.likes == false;
                                                  });
                                                },
                                                child: Icon(Icons.favorite,
                                                    color: documentSnapshot[
                                                                index]
                                                            .exists
                                                        ? Color.fromARGB(
                                                            255, 222, 156, 63)
                                                        : Color.fromARGB(
                                                            255, 31, 30, 30)),
                                              ),
                                              SizedBox(width: 5),
                                              Text(image.likes.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Text(
                                              '${timeago.format(image.time)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                            //   }).toList(),
                            // ),
                            ,
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    });
                return pagination;
              }),
          const SizedBox(height: 100),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.grey),
                            color: Colors.white),
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: TextFormField(
                          // onChanged: (value) {
                          //   print(value);
                          //   value = _textController.text;
                          // },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          controller: _textController,
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              hintText: 'Post your comment here.',
                              hintStyle: const TextStyle(fontSize: 15),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedErrorBorder: InputBorder.none),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      addComment(_textController.text);
                      _textController.clear();
                      // Navigator.pop(context);
                      // Clear the text field after adding the comment
                    },
                    child: Image.asset(
                      'images/comment.png',
                      height: 55,
                      width: 45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




//======================================
//  StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('communityComment')
//                   .orderBy('time', descending: true)
//                   .snapshots(),
//               builder: (BuildContext context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final pagination = PaginateFirestore(
//                     itemBuilderType: PaginateBuilderType.listView,
//                     //  isLive: false,
//                     query: FirebaseFirestore.instance
//                         .collection('communityComment')
//                         .limit(5)
//                         .orderBy('time', descending: true),
//                     itemsPerPage: 1,
//                     itemBuilder: (context, documentSnapshot, index) {
//                       return SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             ListView(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               children: snapshot.data!.docs.map((document) {
//                                 String dateString = document['time'];
//                                 DateTime date = DateTime.parse(dateString);
//                                 return Column(
//                                   children: [
//                                     const Divider(thickness: 1),
//                                     Column(
//                                       children: [