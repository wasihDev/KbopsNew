import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:kbops/models/userdata.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class KPointsHistory extends StatefulWidget {
  KPointsHistory({Key? key, required this.userinfo}) : super(key: key);
  Userinfo? userinfo;

  @override
  State<KPointsHistory> createState() => _KPointsHistoryState(userinfo);
}

class _KPointsHistoryState extends State<KPointsHistory> {
  _KPointsHistoryState(this.userinfo);

  Userinfo? userinfo;
  List<KPointsUsedHistoryModel> kPointsUsedList = [];
  List<KPointsUsedHistoryModel> kPointsChargedList = [];
  List<DocumentSnapshot> documentList = [];

  Future<bool> getUsedKpoints() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('kPointsUsed')
        .orderBy('kPointsDate', descending: true)
        .where("userId", isEqualTo: userinfo!.UserID);
    var kPointsUsedHistory = await collectionRef.limit(2).get();
    final collectionRefCharged = FirebaseFirestore.instance
        .collection(
          'kPointsCharged',
        )
        .orderBy('kPointsDate', descending: true)
        .where("userId", isEqualTo: userinfo!.UserID);
    var kPointsCharged = await collectionRefCharged.get();
    for (var i in kPointsUsedHistory.docs) {
      kPointsUsedList.add(KPointsUsedHistoryModel.fromMap(i));
    }
    for (var i in kPointsCharged.docs) {
      kPointsChargedList.add(KPointsUsedHistoryModel.fromMap(i));
    }
    return true;
  }

  Userinfo? userInfo;
  var pointsLoading = true;

  Future<void> getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userid = auth.currentUser!.uid.toString();
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final docs = await collectionRef.doc(userid).get();
    userInfo = Userinfo.fromMap(docs);
    pointsLoading = false;
    setState(() {});
  }

  var isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getUserInfo();
      await getUsedKpoints();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 196, 38, 64),
          title: const Text(
            "KPoints History",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Color.fromRGBO(255, 256, 256, 1),
            tabs: [
              Tab(
                icon: Image.asset(
                  'images/kplus.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                text: "Charged",
              ),
              Tab(
                icon: Image.asset(
                  'images/kminus.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                text: "Used",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // isLoading? const SizedBox(height: 300,child: Center(child: CircularProgressIndicator(),),):
            // ListView.builder(
            //   itemCount: kPointsChargedList.length,
            //   itemBuilder: (BuildContext context, int i) {
            //     KPointsUsedHistoryModel kPoints = kPointsChargedList[i];
            //     Timestamp? t = kPoints.KPointsDate;
            //     DateTime d = t!.toDate();
            //     return Card(
            //       elevation: 1,
            //       child: ListTile(
            //         title: Text(kPoints.KPointsOption.toString()),
            //         subtitle: Text(
            //             '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute}'),
            //       ),
            //     );
            //   }),

            PaginateFirestore(
              initialLoader: const CircularProgressIndicator(
                  color: Color.fromRGBO(196, 38, 64, 1)),
              //item builder type is compulsory.
              itemBuilder: (context, documentSnapshots, index) {
                final data = documentSnapshots[index].data() as Map?;
                Timestamp? t = data!['kPointsDate'];
                DateTime d = t!.toDate();
                return Card(
                  elevation: 1,
                  child: ListTile(
                      title: Text(data['kPointsOption'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          )),
                      subtitle: Text(
                          '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ))),
                );
              },
              // orderBy is compulsory to enable pagination
              query: FirebaseFirestore.instance
                  .collection(
                    'kPointsCharged',
                  )
                  .orderBy('kPointsDate', descending: true)
                  .where("userId", isEqualTo: userinfo?.UserID ?? "null"),
              //Change types accordingly
              itemBuilderType: PaginateBuilderType.listView,
              // to fetch real-time data
              isLive: false,
            ),
            PaginateFirestore(
              initialLoader: const CircularProgressIndicator(
                  color: Color.fromRGBO(196, 38, 64, 1)),

              //item builder type is compulsory.
              itemBuilder: (context, documentSnapshots, index) {
                final data = documentSnapshots[index].data() as Map?;
                Timestamp? t = data!['kPointsDate'];
                DateTime d = t!.toDate();
                log("Date :::: ${data["kPointsOption"]}");
                return Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(data['kPointsOption'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        )),
                    subtitle: Text(
                        '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        )),
                  ),
                );
              },
              // orderBy is compulsory to enable pagination
              query: FirebaseFirestore.instance
                  .collection('kPointsUsed')
                  .orderBy('kPointsDate', descending: true)
                  .where("userId", isEqualTo: userinfo!.UserID),
              //Change types accordingly
              itemBuilderType: PaginateBuilderType.listView,
              // to fetch real-time data
              isLive: false,
            ),
            //     isLoading?const SizedBox(height: 300,child: Center(child: CircularProgressIndicator(),),):ListView.builder(
            // itemCount: kPointsUsedList.length,
            // itemBuilder: (BuildContext context, int i) {
            //   KPointsUsedHistoryModel kPoints = kPointsUsedList[i];
            //   Timestamp? t = kPoints.KPointsDate;
            //   DateTime d = t!.toDate();
            //   return Card(
            //     elevation: 1,
            //     child: ListTile(
            //       title: Text(kPoints.KPointsOption.toString()),
            //       subtitle: Text(
            //           '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute}'),
            //     ),
            //   );
            // })
          ],
        ),
      ),
    );
  }
}
