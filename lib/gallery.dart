import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kbops/image_docs.dart';
import 'package:kbops/models/userdata.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
// import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
// import 'package:p_pops/components/images_docs.dart';
// import 'package:p_pops/screens/report_comment.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import '../../models/user_model.dart';
// import '../chat_newScree.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

import 'dashboard_screens/report_comment.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
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
  }

  EventsInfo? eventsInfo;
  Userinfo? userinfo;

  Storage storage = Storage();
  int itemCount = 0;
  List<dynamic> likedBy = List.empty(growable: true);
  bool iscomment = false;
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 198, 37, 65),
        title: Text('Image Feeds'),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          print("object");
          final results = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['png', 'jpg'],
          );
          setState(() {
            results;
          });
          if (results == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No file has been selected.')));
            return null;
          }

          final path = results.files.single.path!;
          final fileName = results.files.single.name;
          final files = File(path);

          // Check file size
          final fileSize = files.lengthSync();
          if (fileSize > 2 * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please upload file with maximum 2MB.')),
            );
            return null;
          }
          print(path);
          print(fileName);
          final Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('images/${DateTime.now().millisecondsSinceEpoch}');
          File file = File(path);
          final UploadTask uploadTask =
              storageRef.putData(await file.readAsBytes());
          final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
              () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Image has been uploaded.'),
                  )));
          final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          FirebaseImageModel image = FirebaseImageModel(
              uploadUserId: userInfo.UserID!,
              imageUrl: downloadUrl,
              userName: userInfo.Username!,
              imageUploadTime: DateTime.now(),
              docId: FirebaseFirestore.instance.collection('Dummy').doc().id,
              userProfileImage: userInfo.UserImage!,
              likecount: 0,
              dislikecount: 0,
              likedBy: []);
          await FirebaseFirestore.instance
              .collection('userImages')
              .doc(image.docId)
              .set(image.toJson())
              .then((_) {
            setState(() {
              images.insert(0, image);
            });
          });
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 198, 37, 65), shape: BoxShape.circle),
          child: const Center(
            child: Icon(
              Icons.photo,
              color: Colors.white,
            ),
          ),
        ),
      )
      // SpeedDial(
      //   icon: Icons.add,
      //   overlayColor: Colors.transparent,
      //   overlayOpacity: 0.0,
      //   backgroundColor: const Color.fromARGB(255, 196, 38, 64),
      //   spacing: 10,
      //   children: [
      //     // SpeedDialChild(
      //     //     backgroundColor: const Color.fromARGB(255, 196, 38, 64),
      //     //     child: const Icon(
      //     //       Icons.chat,
      //     //       color: Colors.white,
      //     //     ),
      //     //     onTap: () {
      //     //       Navigator.push(
      //     //           context,
      //     //           MaterialPageRoute(
      //     //               builder: (context) => const ChatNewScreen()));
      //     //     }),
      //     SpeedDialChild(
      //         backgroundColor: const Color.fromARGB(255, 196, 38, 64),
      //         child: const Icon(
      //           Icons.photo,
      //           color: Colors.white,
      //         ),
      //         onTap: () async {
      //           final results = await FilePicker.platform.pickFiles(
      //             allowMultiple: false,
      //             type: FileType.custom,
      //             allowedExtensions: ['png', 'jpg'],
      //           );
      //           setState(() {
      //             results;
      //           });
      //           if (results == null) {
      //             ScaffoldMessenger.of(context).showSnackBar(
      //                 const SnackBar(content: Text('No file Selected')));
      //             return null;
      //           }

      //           final path = results.files.single.path!;
      //           final fileName = results.files.single.name;
      //           print(path);
      //           print(fileName);
      //           final Reference storageRef = FirebaseStorage.instance
      //               .ref()
      //               .child('images/${DateTime.now().millisecondsSinceEpoch}');
      //           File file = File(path);
      //           final UploadTask uploadTask =
      //               storageRef.putData(await file.readAsBytes());
      //           final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
      //               () => ScaffoldMessenger.of(context)
      //                       .showSnackBar(const SnackBar(
      //                     content: Text('Picture Uploaded'),
      //                   )));
      //           final String downloadUrl =
      //               await taskSnapshot.ref.getDownloadURL();

      //           FirebaseImageModel image = FirebaseImageModel(
      //               uploadUserId: userInfo.UserID!,
      //               imageUrl: downloadUrl,
      //               userName: userInfo.Username!,
      //               imageUploadTime: DateTime.now(),
      //               docId:
      //                   FirebaseFirestore.instance.collection('Dummy').doc().id,
      //               userProfileImage: userInfo.UserImage!,
      //               likecount: 0,
      //               dislikecount: 0,
      //               likedBy: []);
      //           await FirebaseFirestore.instance
      //               .collection('userImages')
      //               .doc(image.docId)
      //               .set(image.toJson())
      //               .then((_) {
      //             setState(() {
      //               images.insert(0, image);
      //             });
      //           });
      //         })
      //   ],
      // ),
      ,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: isImagesLoading == true
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : images.isEmpty
                ? const Center(
                    child: Text('No Images'),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('userImages')
                        .orderBy('uploadTime', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      images = snapshot.data!.docs.map((document) {
                        final indexItem =
                            document.data() as Map<String, dynamic>;
                        return FirebaseImageModel.fromJson(indexItem);
                      }).toList();

                      final pagination = PaginateFirestore(
                        itemBuilderType: PaginateBuilderType.listView,

                        isLive: false,

                        query: FirebaseFirestore.instance
                            .collection('userImages')
                            .orderBy('uploadTime', descending: true),
                        itemsPerPage: 1,
                        itemBuilder: (context, documentSnapshot, index) {
                          final image = images[index];

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        NetworkImage(image.userProfileImage),
                                  ),
                                  title: Text(image.userName),
                                  subtitle: Text(
                                      timeago.format(image.imageUploadTime)),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          List<String> likedUsers =
                                              List.empty(growable: true);
                                          likedUsers = image.likedBy;
                                          if (image.likedBy
                                              .contains(userInfo.UserID)) {
                                            likedUsers.removeWhere((element) =>
                                                element == userInfo.UserID);

                                            print('itemremoved');
                                          } else {
                                            likedUsers.add(userInfo.UserID!);
                                            print('itemAdd');
                                          }

                                          await likeOrUnlikeImage(
                                            docId: image.docId,
                                            users: likedUsers,
                                          );
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            // Icon(
                                            //   Icons.favorite,
                                            //   size: 28,
                                            //   color: image
                                            //           .likedBy
                                            //           .contains(userInfo
                                            //               .UserID)
                                            //       ? Colors.red
                                            //       : Colors
                                            //           .grey,
                                            // ),
                                            Icon(Icons.favorite,
                                                size: 28,
                                                color: Color.fromARGB(
                                                    255, 222, 156, 63)),
                                            Text(
                                              image.likedBy.length.toString(),
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 34, 34, 34),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context as BuildContext)
                                          .size
                                          .height *
                                      0.3,
                                  width: MediaQuery.of(context as BuildContext)
                                          .size
                                          .width *
                                      0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(image.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ReportComment()));
                                        },
                                        child: const Text('[Report]',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                        /*Icon(Icons.report,
                                            color: Colors.black45,
                                            size: 16),*/
                                      ),

                                      /*  const Text('[Report]',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ),*/
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[500],
                                )
                              ],
                            ),
                          );
                        },
                        //emptyDisplay: Text('No images found.'),
                      );

                      return pagination;
                    },
                  ),
      ),
    );
  }
}
