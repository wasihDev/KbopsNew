import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbops/vote_screens/widgets/event_card.dart';
import 'package:kbops/vote_screens/widgets/my_drawer.dart';
import 'package:kbops/state_management/vote_now_provider.dart';
import 'package:kbops/vote_screens/widgets/slider_widget.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/anony.dart';
import '../../sharedpref.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../state_management/event_provider.dart';
import '../../state_management/user_info_provider.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen>
    with SingleTickerProviderStateMixin {
  var sate = true;
  String popUpImage = '';

  Future<void> getPopUpImage() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('popImage');
    var image = await _collectionRef.doc("image").get();
    log(image.toString());
    popUpImage = image['url'] ??
        "https://img-cdn.pixlr.com/pixlr-templates/63e219d5893ed2e1318e0ae6/thumbnail_medium.webp";
  }

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

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Provider.of<UserProvider>(context,listen: false);
      // Provider.of<VoteNowProvider>(context, listen: false).getAllBanners();
      Provider.of<VoteNowProvider>(context, listen: false).fetchDate();
    });
    _tabController = TabController(length: 3, vsync: this);

    // getPopUpImage();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final sliderImagesProvider = Provider.of<VoteNowProvider>(context);
    // final timestamp = Provider.of<VoteNowProvider>(context);
    // final readDate = context.read<VoteNowProvider>().fetchDate();
    // final bannerProvider = Provider.of<VoteNowProvider>(context);
    // final banners = bannerProvider.banners;
    // // Fetch banners if they haven't been fetched yet
    // if (banners.isEmpty) {
    //   bannerProvider.getAllBanners();
    // }
    // final currentIndexProvider = Provider.of<VoteNowProvider>(context);
    // final currentIndex = bannerProvider.currentIndex;
    // final eventProvider = Provider.of<EventsProvider>(context);
    // final voteProvider = Provider.of<VoteNowProvider>(context);
    // final events = eventProvider.events;
    // final userProvider = Provider.of<UserProvider>(context);
    // Fetch banners if they haven't been fetched yet
    // if (events.isEmpty) {
    // eventProvider.getEvents(eventName);
    // voteProvider.fetchDate();
    log('BUILD VOTE SCREEN');
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 198, 37, 65),
        //  automaticallyImplyLeading: false,
        title: const Text(
          "kBOPS",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Consumer<UserProvider>(builder: (context, userProvider, child) {
                  return Text(
                    "${userProvider.userInfo?.TotalKPoints ?? 0}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white),
                  );
                }),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'images/Heart Voting.png',
                  height: 30,
                  width: 30,
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          children: [
            // Container(
            //     decoration:
            //         BoxDecoration(borderRadius: BorderRadius.circular(10)),
            //     child: CarouselSlider(
            //       options: CarouselOptions(
            //           onPageChanged: (index, reason) {
            //             // bannerProvider.setCurrentIndex(index);
            //           },
            //           aspectRatio: 2.0,
            //           enlargeCenterPage: true,
            //           scrollDirection: Axis.horizontal,
            //           autoPlay: true,
            //           viewportFraction: 1),
            //       items: List.generate(
            //           banners.length,
            //           (index) => Container(
            //                 height: 300,
            //                 width: double.infinity,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10)),
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(10),
            //                   child: Image.network(
            //                     banners[index].imageSlider,
            //                     fit: BoxFit.fill,
            //                   ),
            //                 ),
            //               )),
            //     )),
            // DotsIndicator(
            //   dotsCount: banners.length,
            //   position: currentIndex,
            // ),
            // Consumer<VoteNowProvider>(builder: (context, sliderProvider, _) {
            //   if (sliderProvider.isImageLoading) {
            //     return Container(
            //       height: MediaQuery.of(context).size.height * 0.24,
            //       width: double.infinity,
            //       color: Colors.grey[700],
            //       padding: const EdgeInsets.symmetric(horizontal: 16),
            //     );
            //   } else {
            //     return SilderWidget(imgList: sliderProvider.imgList);
            //   }
            // }),
            // sliderImagesProvider.imgList.isEmpty
            // ? Container(
            //     height: MediaQuery.of(context).size.height * 0.24,
            //     width: double.infinity,
            //     color: Colors.grey[700],
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //   )
            //     :
            //   SilderWidget(imgList: context.read<VoteNowProvider>().imgList),
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
            Consumer<VoteNowProvider>(builder: (context, timestam, child) {
              return Expanded(
                // height: MediaQuery.of(context).s,
                child: TabBarView(
                    //  clipBehavior: Clip.none,
                    controller: _tabController,
                    children: [
                      Consumer<EventsProvider>(
                          builder: (context, eventProvider, child) {
                        final events = eventProvider.events1;

                        // if (events.isEmpty) {

                        eventProvider.getEventsKPOP();
                        // events.clear();

                        // }
                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            // final data = events[index];
                            // EventsInfo? eventInfos = EventsInfo.fromMap(data);
                            Timestamp? t = events[index].EventStartDate;
                            DateTime d = t!.toDate();
                            Timestamp? t2 = events[index].EventEndDate;
                            DateTime d2 = t2!.toDate();
                            final eventInfo = events[index];
                            return Consumer<VoteNowProvider>(
                                builder: (context, voteProvider, child) {
                              return widgetCard(
                                  eventInfo: eventInfo,
                                  d: d,
                                  d2: d2,
                                  voteProvider: voteProvider);
                            });
                          },
                        );
                      }),
                      Consumer<EventsProvider>(
                          builder: (context, eventProvider, child) {
                        final events = eventProvider.events2;

                        // if (events.isEmpty) {

                        eventProvider.getEventsGLOBAL();
                        // events.clear();
                        // }
                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            // final data = events[index];
                            // EventsInfo? eventInfos = EventsInfo.fromMap(data);
                            Timestamp? t = events[index].EventStartDate;
                            DateTime d = t!.toDate();
                            Timestamp? t2 = events[index].EventEndDate;
                            DateTime d2 = t2!.toDate();
                            final eventInfo = events[index];
                            return Consumer<VoteNowProvider>(
                                builder: (context, voteProvider, child) {
                              return widgetCard(
                                  eventInfo: eventInfo,
                                  d: d,
                                  d2: d2,
                                  voteProvider: voteProvider);
                            });
                          },
                        );
                      }),
                      Consumer<EventsProvider>(
                          builder: (context, eventProvider, child) {
                        final events = eventProvider.events3;
                        // log('fanProjcet');
                        // events.clear();
                        eventProvider.getEventsFan();

                        // if (events.isEmpty) {}
                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            // final data = events[index];
                            // EventsInfo? eventInfos = EventsInfo.fromMap(data);
                            Timestamp? t = events[index].EventStartDate;
                            DateTime d = t!.toDate();
                            Timestamp? t2 = events[index].EventEndDate;
                            DateTime d2 = t2!.toDate();
                            final eventInfo = events[index];
                            return Consumer<VoteNowProvider>(
                                builder: (context, voteProvider, child) {
                              return widgetCard(
                                  eventInfo: eventInfo,
                                  d: d,
                                  d2: d2,
                                  voteProvider: voteProvider);
                            });
                          },
                        );
                      })
                      // EventCard(
                      //   eventName: 'KPOP Vote',
                      // ),
                      // EventCard(
                      //   eventName: 'Global Vote',
                      // ),
                      // EventCard(
                      //   eventName: 'Fan Project',
                      // ),
                    ]),
              );
            }),

            ///==============================
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
}
