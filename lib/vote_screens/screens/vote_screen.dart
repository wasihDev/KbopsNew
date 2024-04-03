// // so you want to add the comments on already end votingNow screen
// import 'dart:developer';
// import 'dart:io';
// import 'package:banner_carousel/banner_carousel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:kbops/dashboard_screens/vote_now.dart';
// import 'package:kbops/dashboard_screens/website.dart';
// import 'package:kbops/drawer.dart';
// import 'package:kbops/sharedpref.dart';
// import 'package:kbops/utils/functions.dart';
// import 'package:kbops/utils/new_versionPlugin.dart';
// import 'package:paginate_firestore/bloc/pagination_listeners.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';
// import 'package:upgrader/upgrader.dart';
// import '../gallery.dart';
// import '../models/userdata.dart';
// import 'fanproject.dart';

// class VoteScreen extends StatefulWidget {
//   const VoteScreen({Key? key}) : super(key: key);

//   @override
//   State<VoteScreen> createState() => _VoteScreenState();
// }

// class _VoteScreenState extends State<VoteScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool isChecked = false;
//   var sate = true;
//   String popUpImage = '';
//   List<EventsInfo> eventsList = [];
//   List<BannerModel> imgList = [];
//   Future<void> getPopUpImage() async {
//     final CollectionReference _collectionRef =
//         FirebaseFirestore.instance.collection('popImage');
//     var image = await _collectionRef.doc("image").get();
//     log("popImage ${image}");
//     popUpImage = image['url'];
//   }

//   Future<void> getData() async {
//     // Get docs from collection reference
//     var firbase = FirebaseFirestore.instance;
//     final CollectionReference collectionRef =
//         firbase.collection('sliderImages');

//     QuerySnapshot querySnapshot = await collectionRef.get();

//     // Get data from docs and convert map to List
//     final sliderData = querySnapshot.docs
//         .map((doc) =>
//             {'image': doc['imageSlider'], 'url': doc['imageSliderLink']})
//         .toList();

//     for (int i = 0; i < sliderData.length; i++) {
//       imgList.add(BannerModel(
//           imagePath: sliderData[i]['image'], id: (i + 1).toString()));
//     }
//   }

//   var pointsLoading = true;
//   Userinfo? userInfo;
//   Future<void> getUserInfo() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     String userid = auth.currentUser!.uid.toString();
//     final collectionRef = FirebaseFirestore.instance.collection('users');
//     final docs = await collectionRef.doc(userid).get();
//     userInfo = Userinfo.fromMap(docs);
//     pointsLoading = false;
//   }

//   late Map<dynamic, dynamic> timestamp;
//   PaginateRefreshedChangeListener refreshChangeListener =
//       PaginateRefreshedChangeListener();

//   @override
//   void initState() {
//     super.initState();
//     checkVersion();
//     _tabController = TabController(length: 3, vsync: this);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       timestamp = await fetchDate();
//       await getPopUpImage();
//       await checkPopUp();
//       await getData();
//       // await getEvents();
//       await getUserInfo();

//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     });
//   }

//   void checkVersion() async {
//     final newVersion = NewVersion(
//         androidId: "com.mbentertaintment.KBOPS_online",
//         iOSId: 'com.mbentertaintment.kbops');
//     final status = await newVersion.showAlertIfNecessary(context: context);
//     //   newVersion.showUpdateDialog(
//     //       context: context,
//     //       versionStatus: status!,
//     //       dialogText:
//     //           "Please update the app from ${status.localVersion} to ${status.storeVersion}",
//     //       dismissAction: () {
//     //         SystemNavigator.pop();
//     //       },
//     //       updateButtonText: "Let's Update ");
//     //   print("device: " + status.localVersion);
//     //   print("device: " + status.storeVersion);
//   }

//   checkPopUp() async {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('yyyy-MM-dd');
//     final String formatted = formatter.format(now);
//     final res = await getPopUp();
//     if (res.isNotEmpty) {
//       if (res == formatted) {
//         setState(() {
//           sate = false;
//         });
//       }
//     }
//   }

//   var isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     return UpgradeAlert(
//         upgrader: Upgrader(
//             showIgnore: false,
//             showLater: false,
//             canDismissDialog: false,
//             dialogStyle: Platform.isIOS
//                 ? UpgradeDialogStyle.cupertino
//                 : UpgradeDialogStyle.material),
//         child: Scaffold(
//           backgroundColor: Colors.grey[300],
//           drawer: Drawer(
//             child: Column(
//               children: [
//                 Container(
//                   height: 250,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(255, 198, 37, 65),
//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 70),
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: NetworkImage(userInfo?.UserImage ??
//                             "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         userInfo?.Username ?? "",
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 17,
//                             color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Lastest()));
//                   },
//                   child: const ListTile(
//                     leading: Text(
//                       'Live Chat',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios_rounded),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Gallery()));
//                   },
//                   child: const ListTile(
//                     leading: Text(
//                       'Image Feeds',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios_rounded),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Website()));
//                   },
//                   child: const ListTile(
//                     leading: Text(
//                       'Blogs & News',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios_rounded),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const FanProject()));
//                   },
//                   child: const ListTile(
//                     leading: Text('Fan Project Form',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w400, fontSize: 16)),
//                     trailing: Icon(Icons.arrow_forward_ios_rounded),
//                   ),
//                 )
//               ],
//             ),
//           ),
//
// appBar: AppBar(
//             backgroundColor: const Color.fromARGB(255, 198, 37, 65),
//             //  automaticallyImplyLeading: false,
//             title: Row(
//               children: [
//                 const Text(
//                   "kBOPS",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 /* Image.asset(
//                 'images/kBOPS Mobile icon.png',
//                 height: 65,
//                 width: 65,
//                 fit: BoxFit.fill,
//               ),*/

//                 const Spacer(),
//                 !pointsLoading
//                     ? Row(
//                         children: [
//                           Text(
//                             "${userInfo?.TotalKPoints ?? 0}",
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 18,
//                                 color: Colors.white),
//                           ),
//                           const SizedBox(
//                             width: 2,
//                           ),
//                           Image.asset(
//                             'images/Heart Voting.png',
//                             height: 30,
//                             width: 30,
//                           )
//                         ],
//                       )
//                     : const CircularProgressIndicator(
//                         color: Color.fromRGBO(196, 38, 64, 1),
//                       )
//               ],
//             ),
//           ),
//           body: isLoading
//               ? Container(
//                   height: MediaQuery.of(context).size.height * 1,
//                   width: MediaQuery.of(context).size.width * 1,
//                   child: const Center(
//                     child: CircularProgressIndicator(
//                       color: Color.fromRGBO(196, 38, 64, 1),
//                     ),
//                   ),
//                 )
//               : Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         // mainAxisSize: MainAxisSize.min,
//                         // mainAxisAlignment: ,
//                         // mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Carosal
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.2,
//                             child: BannerCarousel.fullScreen(
//                               borderRadius: 10,
//                               banners: imgList,
//                               height: MediaQuery.of(context).size.height * 0.2,
//                               initialPage: 0,
//                               customizedIndicators:
//                                   const IndicatorModel.animation(
//                                       width: 20,
//                                       height: 5,
//                                       spaceBetween: 2,
//                                       widthAnimation: 50),
//                               activeColor: Colors.amberAccent,
//                               disableColor: Colors.white,
//                               animation: true,
//                               indicatorBottom: false,

//                               // OR pageController: PageController(initialPage: 6),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Container(
//                               height: kToolbarHeight - 8.0,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               child: TabBar(
//                                 unselectedLabelColor: Colors.black,
//                                 // labelColor: _selectedColor,
//                                 labelStyle: const TextStyle(fontSize: 10),
//                                 indicator: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(25.0),
//                                   color: const Color.fromRGBO(196, 38, 64, 1),
//                                 ),
//                                 labelColor: Colors.white,
//                                 controller: _tabController,
//                                 tabs: const [
//                                   Tab(text: '🗳️ KPOP Vote'),
//                                   Tab(text: '🌏 GLOBAL Vote'),
//                                   Tab(text: '🎁 Fan Project'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.01),
//                           Expanded(
//                             child: TabBarView(
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 controller: _tabController,
//                                 children: [
//                                   // Text("P-POP Vote"),
//                                   // Expanded(child: ),
//                                   // Expanded(child: kbopsVote("KPOP Vote")),
//                                   kbopsVote("KPOP Vote"),
//                                   kbopsVote("Global Vote"),
//                                   kbopsVote("Fan Project"),
//                                   // Text("Birthday Poll"),
//                                 ]),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       child: sate
//                           ? Container(
//                               height: MediaQuery.of(context).size.height * 1,
//                               width: MediaQuery.of(context).size.width * 1,
//                               color: Colors.black54,
//                               child: Center(
//                                 child: Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.65,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.85,
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(20)),
//                                       image: DecorationImage(
//                                           image: NetworkImage(popUpImage),
//                                           fit: BoxFit.fill)),
//                                   child: Column(
//                                     children: [
//                                       const SizedBox(height: 10),
//                                       Row(
//                                         children: [
//                                           const Spacer(),
//                                           CircleAvatar(
//                                               radius: 20,
//                                               backgroundColor: Colors.black,
//                                               child: Center(
//                                                 child: IconButton(
//                                                   onPressed: () {
//                                                     setState(() {
//                                                       sate = false;
//                                                     });
//                                                   },
//                                                   icon: const Icon(
//                                                     Icons.close,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               )),
//                                           const SizedBox(width: 10),
//                                         ],
//                                       ),
//                                       const Spacer(),
//                                       Container(
//                                         decoration: const BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                               bottomRight: Radius.circular(20),
//                                               bottomLeft: Radius.circular(20)),
//                                           color: Colors.black,
//                                         ),
//                                         height: 50,
//                                         child: Row(
//                                           children: [
//                                             Theme(
//                                               data: Theme.of(context).copyWith(
//                                                 unselectedWidgetColor:
//                                                     Colors.white,
//                                               ),
//                                               child: Checkbox(
//                                                 activeColor: Colors.grey,
//                                                 checkColor: Colors.black,
//                                                 value: isChecked,
//                                                 onChanged: (value) {
//                                                   if (value!) {
//                                                     final DateTime now =
//                                                         DateTime.now();
//                                                     final DateFormat formatter =
//                                                         DateFormat(
//                                                             'yyyy-MM-dd');
//                                                     final String formatted =
//                                                         formatter.format(now);
//                                                     DontShowToday(formatted);
//                                                   }
//                                                   setState(() {
//                                                     isChecked = value;
//                                                   });
//                                                 },
//                                               ),
//                                             ),
//                                             // Checkbox(
//                                             //   activeColor: Colors.grey,
//                                             //   checkColor: Colors.black,
//                                             //   value: isChecked,
//                                             //   onChanged: (value) {
//                                             //     setState(() {
//                                             //       isChecked = value!;
//                                             //     });
//                                             //   },
//                                             // ),
//                                             const SizedBox(
//                                               width: 20,
//                                             ),
//                                             const Text(
//                                               "Don't Show Today",
//                                               style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.white),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                     )
//                   ],
//                 ),
//         ));
//   }

//   RefreshIndicator kbopsVote(String event) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         refreshChangeListener.refreshed = true;
//       },
//       child: PaginateFirestore(
//         initialLoader: const CircularProgressIndicator(
//             color: Color.fromRGBO(196, 38, 64, 1)),

//         listeners: [refreshChangeListener],
//         shrinkWrap: true,
//         // physics: const NeverScrollableScrollPhysics(),
//         physics: const BouncingScrollPhysics(),
//         //item builder type is compulsory.
//         itemBuilder: (context, documentSnapshots, index) {
//           final data = documentSnapshots[index].data() as Map?;
//           EventsInfo eventInfo = EventsInfo.fromMap(data);
//           Timestamp? t = eventInfo.EventStartDate;
//           DateTime d = t!.toDate();
//           Timestamp? t2 = eventInfo.EventEndDate;
//           DateTime d2 = t2!.toDate();

//           DateTime currentPhoneDate = DateTime.now(); //DateTime

//           Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
//           // Timestamp t3 =
//           DateTime d3 = DateTime.parse(timestamp['time']);
//           var status = "UPCOMING";
//           if (d3.compareTo(d) >= 0 && d3.compareTo(d2) <= 0) {
//             status = "ONGOING";
//           } else if (d3.compareTo(d2) >= 0) {
//             status = "ENDED";
//           }
//           return Card(
//             elevation: 1,
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: Container(
//                     height: 30,
//                     width: 72,
//                     decoration: const BoxDecoration(
//                         color: Color.fromARGB(255, 21, 21, 21),
//                         borderRadius: BorderRadius.all(Radius.circular(8))),
//                     child: Center(
//                         child: Text(
//                       eventInfo.EventStatus!,
//                       style: const TextStyle(color: Colors.white, fontSize: 9),
//                     )),
//                   ),
//                   title: Text("${eventInfo.EventName}",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                           fontSize: 13, fontWeight: FontWeight.bold)),
//                   subtitle: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                           '${d.month}/${d.day} ~ ${d2.month}/${d2.day}/${d2.year}',
//                           style: const TextStyle(
//                               fontSize: 12, fontWeight: FontWeight.normal)),
//                       const SizedBox(
//                         width: 8,
//                       ),
// const Icon(
//   Icons.how_to_vote_outlined,
//   size: 14,
// ),
// Text("${eventInfo.EventTotalVotes} KPoints",
//     style: const TextStyle(
//         fontSize: 12, fontWeight: FontWeight.normal))
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 235,
//                   //decoration: const BoxDecoration(
//                   // color: Colors.white,
//                   // Color.fromARGB(255, 198, 38, 65),
//                   //borderRadius: BorderRadius.all(Radius.circular(11)),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       // borderRadius: const BorderRadius.all(Radius.circular(20)),
//                       image: DecorationImage(
//                         image: NetworkImage('${eventInfo.EventImage}'),
//                         //scale: 16 / 9,
//                         // fit: BoxFit.fill
//                       )),
//                   width: MediaQuery.of(context).size.width * 0.85,
//                   //child:
//                   //Image.network('${eventInfo.EventImage}',
//                   //scale: 16 / 9,
//                   //fit image
//                   //fit: BoxFit.fill,
//                   //),
//                 ),
//                 const SizedBox(
//                   height: 3,
//                 ),
//                 d3.compareTo(d) >= 0 && d3.compareTo(d2) <= 0
//                     ? Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Align(
//                             alignment: Alignment.centerRight,
//                             child: ElevatedButton(
//                                 onPressed: () async {
//                                   final result = await Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (_) => VoteNow(
//                                                     eventsInfo: eventInfo,
//                                                     isVote: true,
//                                                   ))) ??
//                                       false;

//                                   // setState(() {
//                                   //   isLoading = true;
//                                   // });
//                                   await getUserInfo();
//                                   // await getEvents(
//                                   //     isRefresh: true);
//                                   setState(() {
//                                     refreshChangeListener.refreshed = true;
//                                   });
//                                 },
//                                 child: const Text(
//                                   "Participate →",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 11,
//                                       color: Colors.white),
//                                 ),
//                                 style: ButtonStyle(
//                                     backgroundColor: MaterialStateProperty.all<
//                                             Color>(
//                                         const Color.fromARGB(255, 198, 38, 65)),
//                                     shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           side: const BorderSide(
//                                               color: Color.fromARGB(
//                                                   236, 38, 35, 35),
//                                               width: 1.5)),
//                                     )))),
//                       )
//                     : Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Align(
//                           alignment: Alignment.centerRight,
//                           child: ElevatedButton(
//                               onPressed: () async {
//                                 final result = await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (_) => VoteNow(
//                                                   eventsInfo: eventInfo,
//                                                   isVote: false,
//                                                 ))) ??
//                                     false;

//                                 // setState(() {
//                                 //   isLoading = true;
//                                 // });
//                                 await getUserInfo();
//                                 setState(() {
//                                   refreshChangeListener.refreshed = true;
//                                 });
//                               },
//                               child: const Text(
//                                 "View Result",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       const Color.fromARGB(255, 198, 38, 65)),
//                                   shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(15),
//                                         side: const BorderSide(
//                                             color: Color.fromARGB(
//                                                 255, 65, 60, 60))),
//                                   ))),
//                         ),
//                       ),
//                 const SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           );
//         },
//         // orderBy is compulsory to enable pagination
//         query: FirebaseFirestore.instance
//             .collection('events')
//             .where('eventCategory', isEqualTo: event)
//             .orderBy('eventEndDate', descending: true),
//         itemBuilderType: PaginateBuilderType.listView,
//         // to fetch real-time data
//         isLive: true,
//       ),
//     );
//   }
// }
// // so you want to add the comments on already end votingNow screen

import 'dart:developer';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbops/state_management/event_provider.dart';
import 'package:kbops/utils/functions.dart';
import 'package:kbops/vote_screens/widgets/event_card.dart';
import 'package:kbops/vote_screens/widgets/my_drawer.dart';
import 'package:kbops/vote_screens/screens/vote_now.dart';
import 'package:kbops/state_management/vote_now_provider.dart';
import 'package:kbops/vote_screens/widgets/slider_widget.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/userdata.dart';
import '../../sharedpref.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen>
    with SingleTickerProviderStateMixin {
  var sate = true;
  String popUpImage = '';
  // List<EventsInfo> eventsList = [];
  // List<BannerModel> imgList = [];
  Future<void> getPopUpImage() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('popImage');
    var image = await _collectionRef.doc("image").get();
    log(image.toString());
    popUpImage = image['url'] ??
        "https://img-cdn.pixlr.com/pixlr-templates/63e219d5893ed2e1318e0ae6/thumbnail_medium.webp";
  }

  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   var firbase = FirebaseFirestore.instance;
  //   final CollectionReference collectionRef =
  //       firbase.collection('sliderImages');
  //   QuerySnapshot querySnapshot = await collectionRef.get();
  //   // Get data from docs and convert map to List
  //   final sliderData = querySnapshot.docs
  //       .map((doc) =>
  //           {'image': doc['imageSlider'], 'url': doc['imageSliderLink']})
  //       .toList();
  //   for (int i = 0; i < sliderData.length; i++) {
  //     imgList.add(BannerModel(
  //         imagePath: sliderData[i]['image'], id: (i + 1).toString()));
  //   }
  // }

  checkPopUp() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    final res = await getPopUp();
    if (res.isNotEmpty) {
      if (res == formatted) {
        setState(() {
          sate = false;
        });
      }
    }
  }

  var pointsLoading = true;

  // late Map<dynamic, dynamic> timestamp;
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<VoteNowProvider>(context, listen: false).fetchDate();
    });
    // Provider.of<VoteNowProvider>(context, listen: false).getUserData();
    // Provider.of<VoteNowProvider>(context, listen: false).getEventInfo();
    // Provider.of<VoteNowProvider>(context, listen: false).getUserInfo();
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<VoteNowProvider>(context, listen: false).getData();
    });

    // getData();
    getPopUpImage();
  }
  // Future<List<String>> getData() async {
  //   var firebase = FirebaseFirestore.instance;
  //   final CollectionReference collectionRef =
  //       firebase.collection('sliderImages');
  //   QuerySnapshot querySnapshot = await collectionRef.get();

  //   final sliderData =
  //       querySnapshot.docs.map((doc) => doc['imageSlider'] as String).toList();
  //   return sliderData;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   //checkVersion();
  // _tabController = TabController(length: 3, vsync: this);
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     timestamp = await fetchDate();
  //     await getPopUpImage();
  //     await checkPopUp();
  //     await getData();
  //     getWebView();

  //     //await getEvents();

  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   });
  // }

  // void checkVersion() async {
  //   final newVersion = NewVersion(androidId: "com.mbentertaintment.PPOP_app");
  //   final status = await newVersion.showAlertIfNecessary(context: context);
  // }

  // Future<void> getWebView() async {
  //   final collectionRef = FirebaseFirestore.instance.collection('webviewlinks');
  //   final docs = await collectionRef.doc('c26Ice5IaicD2rjJXWR6').get();
  //   kbopsFaq = docs.get('kbopsFaq');
  //   kbopsNotice = docs.get('kbopsNotice');
  //   kbopsPrivacyPolicy = docs.get('kbopsPrivacyPolicy');
  //   kbopsSupport = docs.get('kbopsSupport');
  //   kbopsTos = docs.get('kbopsTos');
  //   ppopwithdrawal = docs.get('kbopswithdrawal');

  //   setState(() {});
  // }

  // final _selectedColor = const Color.fromARGB(255, 204, 108, 33);
  // final _unselectedColor = const Color(0xff5f6368);

  // var isLoading = true;
  @override
  Widget build(BuildContext context) {
    final sliderImagesProvider = Provider.of<VoteNowProvider>(context);
    final timestamp = Provider.of<VoteNowProvider>(context);

    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 198, 37, 65),
        //  automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              "kBOPS",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),

            const Spacer(),
            // !pointsLoading
            //     ? Row(
            //         children: [
            //           Text(
            //             "${userInfo?.TotalKPoints ?? 0}",
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.w400,
            //                 fontSize: 18,
            //                 color: Colors.white),
            //           ),
            //           const SizedBox(
            //             width: 2,
            //           ),
            //           Image.asset(
            //             'images/Heart Voting.png',
            //             height: 30,
            //             width: 30,
            //           )
            //         ],
            //       )
            //     : const CircularProgressIndicator(
            //         color: Color.fromRGBO(196, 38, 64, 1),
            //       )
          ],
        ),
      ),
      body:
          // isLoading
          //     ? SizedBox(
          //         height: MediaQuery.of(context).size.height * 1,
          //         width: MediaQuery.of(context).size.width * 1,
          //         child: const Center(
          //             child: CircularProgressIndicator(
          //           color: Color.fromARGB(255, 192, 30, 21),
          //         )),
          //       )
          //     :
          Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          children: [
            sliderImagesProvider.imgList.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.24,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  )
                : SilderWidget(imgList: sliderImagesProvider.imgList),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: kToolbarHeight - 8.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  // labelColor: _selectedColor,
                  labelStyle: const TextStyle(fontSize: 10),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: const Color.fromRGBO(196, 38, 64, 1),
                  ),
                  labelColor: Colors.white,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '🗳️ KPOP Vote'),
                    Tab(text: '🌏 GLOBAL Vote'),
                    Tab(text: '🎁 Fan Project'),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Expanded(
              // height: MediaQuery.of(context).s,
              child: TabBarView(
                  //  clipBehavior: Clip.none,
                  controller: _tabController,
                  children: [
                    EventCard(
                      timestamp: timestamp,
                      eventName: 'KPOP Vote',
                    ),
                    EventCard(
                      timestamp: timestamp,
                      eventName: 'Global Vote',
                    ),
                    EventCard(
                      timestamp: timestamp,
                      eventName: 'Fan Project',
                    ),
                  ]),
            ),
            // sate
            //     ? Container(
            //         height: MediaQuery.of(context).size.height * .2,
            //         width: MediaQuery.of(context).size.width * 1,
            //         color: Colors.black54,
            //         child: Center(
            //           child: Container(
            //             height: MediaQuery.of(context).size.height * 0.65,
            //             width: MediaQuery.of(context).size.width * 0.85,
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: const BorderRadius.all(
            //                     Radius.circular(20)),
            //                 image: DecorationImage(
            //                     image: NetworkImage(popUpImage),
            //                     fit: BoxFit.fill)),
            //             child: Column(
            //               children: [
            //                 const SizedBox(
            //                   height: 10,
            //                 ),
            //                 Row(
            //                   children: [
            //                     const Spacer(),
            //                     CircleAvatar(
            //                         radius: 20,
            //                         backgroundColor: Colors.black,
            //                         child: Center(
            //                           child: IconButton(
            //                             onPressed: () {
            //                               setState(() {
            //                                 sate = false;
            //                               });
            //                             },
            //                             icon: const Icon(
            //                               Icons.close,
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                         )),
            //                     const SizedBox(
            //                       width: 10,
            //                     ),
            //                   ],
            //                 ),
            //                 const Spacer(),
            //                 Container(
            //                   decoration: const BoxDecoration(
            //                     borderRadius: BorderRadius.only(
            //                         bottomRight: Radius.circular(20),
            //                         bottomLeft: Radius.circular(20)),
            //                     color: Colors.black,
            //                   ),
            //                   height: 50,
            //                   child: Row(
            //                     children: [
            //                       Theme(
            //                         data: Theme.of(context).copyWith(
            //                           unselectedWidgetColor: Colors.white,
            //                         ),
            //                         child: Checkbox(
            //                           activeColor: Colors.grey,
            //                           checkColor: Colors.black,
            //                           value: isChecked,
            //                           onChanged: (value) {
            //                             if (value!) {
            //                               final DateTime now =
            //                                   DateTime.now();
            //                               final DateFormat formatter =
            //                                   DateFormat('yyyy-MM-dd');
            //                               final String formatted =
            //                                   formatter.format(now);
            //                               DontShowToday(formatted);
            //                             }
            //                             setState(() {
            //                               isChecked = value;
            //                             });
            //                           },
            //                         ),
            //                       ),
            //                       const SizedBox(
            //                         width: 20,
            //                       ),
            //                       const Text(
            //                         "Don't Show Today",
            //                         style: TextStyle(
            //                             fontSize: 12,
            //                             color: Colors.white),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     : Container()
          ],
        ),
      ),
    );
  }

  // FutureBuilder<QuerySnapshot<Map<String, dynamic>>> ppopVote(
  //     String event, VoteNowProvider timestamp) {
  //   return FutureBuilder(
  //       future: FirebaseFirestore.instance
  //           .collection('events')
  //           .where('eventCategory', isEqualTo: event)
  //           .get(),
  //       builder: (context, snapshot) {
  //         return snapshot.data?.docs != null
  //             ? ListView.builder(
  //                 itemCount: snapshot.data?.docs.length,
  //                 // physics: const NeverScrollableScrollPhysics(),
  //                 itemBuilder: (context, index) {
  //                   final data = snapshot.data?.docs[index];
  //                   EventsInfo? eventInfo = EventsInfo.fromMap(data);
  //                   Timestamp? t = eventInfo.EventStartDate;
  //                   DateTime d = t!.toDate();
  //                   Timestamp? t2 = eventInfo.EventEndDate;
  //                   DateTime d2 = t2!.toDate();
  //                   DateTime currentPhoneDate = DateTime.now(); //DateTime
  //                   Timestamp myTimeStamp =
  //                       Timestamp.fromDate(currentPhoneDate);
  //                   // Timestamp t3 =
  //                   // DateTime d3 = DateTime.parse(timestamp.date!['time']);
  //                   return Card(
  //                     elevation: 1,
  //                     child: Column(
  //                       children: [
  //                         ListTile(
  //                           leading: Container(
  //                             height: 30,
  //                             width: 72,
  //                             decoration: const BoxDecoration(
  //                                 color: Color.fromRGBO(196, 38, 64, 1),
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(6))),
  //                             child: Center(
  //                                 child: Text(
  //                               eventInfo.EventStatus!,
  //                               style: const TextStyle(
  //                                   color: Colors.white, fontSize: 9),
  //                             )),
  //                           ),
  //                           title: Text(eventInfo.EventName ?? "",
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: const TextStyle(
  //                                   fontSize: 13, fontWeight: FontWeight.bold)),
  //                           subtitle: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.end,
  //                             children: [
  //                               Text(
  //                                   '${d.month}/${d.day} ~ ${d2.month}/${d2.day}/${d2.year}',
  //                                   style: const TextStyle(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.normal)),
  //                               const SizedBox(width: 8),
  //                               const Icon(
  //                                 Icons.how_to_vote_outlined,
  //                                 size: 14,
  //                               ),
  //                               Text("${eventInfo.EventTotalVotes} KPoints",
  //                                   style: const TextStyle(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.normal))
  //                               // const Icon(
  //                               //   Icons.how_to_vote_outlined,
  //                               //   size: 14,
  //                               // ),
  //                               // Text("${eventInfo.EventTotalVotes ?? 0} 🔥",
  //                               //     style: const TextStyle(
  //                               //         fontSize: 12,
  //                               //         fontWeight: FontWeight.normal))
  //                             ],
  //                           ),
  //                         ),
  //                         Container(
  //                           height: 245,
  //                           //decoration: const BoxDecoration(
  //                           // color: Colors.white,
  //                           // Color.fromARGB(255, 198, 38, 65),
  //                           //borderRadius: BorderRadius.all(Radius.circular(11)),
  //                           decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius:
  //                                   const BorderRadius.all(Radius.circular(0)),
  //                               image: DecorationImage(
  //                                   image:
  //                                       NetworkImage('${eventInfo.EventImage}'),
  //                                   fit: BoxFit.fill)),
  //                           width: MediaQuery.of(context).size.width * 0.85,
  //                         ),
  //                         const SizedBox(
  //                           height: 3,
  //                         ),
  //                         DateTime.parse(timestamp.date['time']).compareTo(d) >=
  //                                     0 &&
  //                                 DateTime.parse(timestamp.date['time'])
  //                                         .compareTo(d2) <=
  //                                     0
  //                             ? Container(
  //                                 margin: const EdgeInsets.symmetric(
  //                                     horizontal: 20),
  //                                 child: Align(
  //                                     alignment: Alignment.centerRight,
  //                                     child: ElevatedButton(
  //                                         onPressed: () async {
  //                                           await Navigator.push(
  //                                                   context,
  //                                                   MaterialPageRoute(
  //                                                       builder: (_) => VoteNow(
  //                                                             eventsInfo:
  //                                                                 eventInfo,
  //                                                             isVote: true,
  //                                                           ))) ??
  //                                               false;
  //                                           // setState(() {
  //                                           //   isLoading = true;
  //                                           // });
  //                                           // await getUserInfo();
  //                                           // await getEvents(
  //                                           //     isRefresh: true);
  //                                           setState(() {
  //                                             refreshChangeListener.refreshed =
  //                                                 true;
  //                                           });
  //                                         },
  //                                         // ignore: sort_child_properties_last
  //                                         child: const Text(
  //                                           "VOTE",
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 12,
  //                                               color: Colors.white),
  //                                         ),
  //                                         style: ButtonStyle(
  //                                             backgroundColor:
  //                                                 MaterialStateProperty.all<
  //                                                     Color>(
  //                                               const Color.fromRGBO(
  //                                                   196, 38, 64, 1),
  //                                             ),
  //                                             shape: MaterialStateProperty.all<
  //                                                 RoundedRectangleBorder>(
  //                                               RoundedRectangleBorder(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           15),
  //                                                   side: const BorderSide(
  //                                                       color: Color.fromARGB(
  //                                                           236, 38, 35, 35),
  //                                                       width: 1.5)),
  //                                             )))),
  //                               )
  //                             : Container(
  //                                 margin: const EdgeInsets.symmetric(
  //                                     horizontal: 20),
  //                                 child: Align(
  //                                   alignment: Alignment.centerRight,
  //                                   child: ElevatedButton(
  //                                       onPressed: () async {
  //                                         await Navigator.push(
  //                                                 context,
  //                                                 MaterialPageRoute(
  //                                                     builder: (_) => VoteNow(
  //                                                           eventsInfo:
  //                                                               eventInfo,
  //                                                           isVote: false,
  //                                                         ))) ??
  //                                             false;
  //                                         // await getUserInfo();
  //                                         setState(() {
  //                                           refreshChangeListener.refreshed =
  //                                               true;
  //                                         });
  //                                       },
  //                                       style: ButtonStyle(
  //                                           backgroundColor:
  //                                               MaterialStateProperty.all<
  //                                                   Color>(
  //                                             const Color.fromRGBO(
  //                                                 196, 38, 64, 1),
  //                                           ),
  //                                           shape: MaterialStateProperty.all<
  //                                               RoundedRectangleBorder>(
  //                                             RoundedRectangleBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(15),
  //                                                 side: const BorderSide(
  //                                                   color: Color.fromARGB(
  //                                                       236, 38, 35, 35),
  //                                                 )),
  //                                           )),
  //                                       child: const Text(
  //                                         "View Result",
  //                                         style: TextStyle(
  //                                             fontSize: 12,
  //                                             fontWeight: FontWeight.bold,
  //                                             color: Colors.white),
  //                                       )),
  //                                 ),
  //                               ),
  //                         const SizedBox(
  //                           height: 10,
  //                         )
  //                       ],
  //                     ),
  //                   );
  //                 })
  //             : const Center(
  //                 child: Text(
  //                 'Loading...',
  //                 style: TextStyle(fontWeight: FontWeight.w600),
  //               ));
  //       });
}



// //
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../../models/user_model.dart';

// class VoteScreenn extends StatefulWidget {
//   const VoteScreenn({super.key});

//   @override
//   State<VoteScreenn> createState() => _VoteScreennState();
// }

// class _VoteScreennState extends State<VoteScreenn> {
//   Userinfo? userInfo;
//   var pointsLoading = true;
//   Future getUserInfo(String username, String userimage, String Email) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     String userid = auth.currentUser!.uid.toString();
//     log("userID ==>> ${userid.toString()}");
//     final collectionRef = FirebaseFirestore.instance.collection('users');
//     log("collectionRef ==>> ${collectionRef.toString()}");
//     var docs = await collectionRef
//         .doc(userid)
//         .set({
//           'userid': userid,
//           'username': username,
//           'userimage': userimage,
//           'email': Email,
//           'totalkpoints': 0,
//           'myreferralcode': "",
//           'socialmedia': "",
//           'rewardDate': "",
//           'referralUsed': false,
//           'termsAndAgreement': false,
//           'ads': 0,
//           'adsDate': ''
//         })
//         .then((value) => log("success  "))
//         .onError((error, stackTrace) => log("Error: $error"));
//     //log("Doc ==>> ${docs.toString()}");
//     userInfo = Userinfo.fromMap(docs as dynamic);
//     log("USERINFO ===>>>${userInfo.toString()}");
//     pointsLoading = false;
//     setState(() {});
//   }

//   //List<Userinfo> userinfoList = [];

//   @override
//   void initState() {
//     super.initState();
//     //loadNativeAd();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // userSetup();
//       getUserInfo("${userInfo?.Username}", "${userInfo?.UserImage}",
//           "${userInfo?.Email}");
//       log("All info === >> ${getUserInfo.toString()}");
//       //  getWebView();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
// Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color.fromARGB(255, 196, 38, 64),
//         title: Row(
//           children: [
//             const Text(
//               "Profile",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             const Spacer(),
//             !pointsLoading
//                 ? Row(
//                     children: [
//                       Text(
//                         "${userInfo?.TotalKPoints ?? 0}",
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 18,
//                             color: Colors.white),
//                       ),
//                       const SizedBox(
//                         width: 2,
//                       ),
//                       Image.asset(
//                         'images/Heart Voting.png',
//                         height: 30,
//                         width: 30,
//                       ),
//                     ],
//                   )
//                 : const Text(
//                     "loading..",
//                     style: TextStyle(fontSize: 12),
//                   )
//           ],
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             userInfo?.Username ?? "Name not found!",
//             style: const TextStyle(
//                 fontWeight: FontWeight.w600, fontSize: 17, color: Colors.black),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             userInfo?.Email ?? "Email not found!",
//             style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13,
//                 color: Colors.black54),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             (userInfo?.MyReferralCode ?? "Referral Code not found!"),
//             style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black54),
//           ),
//           // getUserInfo();
//           //  setState(() {});
//           MaterialButton(
//             color: Colors.grey,
//             height: 40,
//             minWidth: 80,
//             onPressed: () {
//               // Navigator.push(context,
//               //     MaterialPageRoute(builder: (context) => NewScreen()));
//             },
//             child: Text("next"),
//           )
//         ],
//       ),
//     );
//   }
// }
