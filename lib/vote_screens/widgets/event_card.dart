import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbops/models/userdata.dart';
import 'package:kbops/state_management/event_provider.dart';
import 'package:kbops/state_management/vote_now_provider.dart';
import 'package:kbops/vote_screens/screens/vote_now.dart';
import 'package:provider/provider.dart';

// class EventCard extends StatelessWidget {
//   // VoteNowProvider timestamp;
//   String eventName;
//   EventCard({super.key, required this.eventName});
//   @override
//   Widget build(BuildContext context) {
//     final eventProvider = Provider.of<EventsProvider>(context);
//     final voteProvider = Provider.of<VoteNowProvider>(context);
//     // final events = eventProvider.events;

//     // Fetch banners if they haven't been fetched yet
//     // if (events.isEmpty) {
//     // eventProvider.getEvents(eventName);
//     voteProvider.fetchDate();
//     // }
//     return Scaffold(body: Consumer(builder: (context, eventss, child) {
//       final events = eventProvider.events;

//       if (events.isEmpty) {
//         eventProvider.getEvents(eventName);
//       }
//       return ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           // final data = events[index];
//           // EventsInfo? eventInfos = EventsInfo.fromMap(data);
//           Timestamp? t = events[index].EventStartDate;
//           DateTime d = t!.toDate();
//           Timestamp? t2 = events[index].EventEndDate;
//           DateTime d2 = t2!.toDate();
//           final eventInfo = events[index];
//           return widgetCard(
//               eventInfo: eventInfo, d: d, d2: d2, voteProvider: voteProvider);
//         },
//       );
//     }));
//   }
// }

class widgetCard extends StatelessWidget {
  const widgetCard({
    super.key,
    required this.eventInfo,
    required this.d,
    required this.d2,
    required this.voteProvider,
  });

  final EventsInfo eventInfo;
  final DateTime d;
  final DateTime d2;
  final VoteNowProvider voteProvider;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              height: 30,
              width: 72,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(196, 38, 64, 1),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Center(
                  child: Text(
                eventInfo.EventStatus!,
                style: const TextStyle(color: Colors.white, fontSize: 9),
              )),
            ),
            title: Text(eventInfo.EventName ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${d.month}/${d.day} ~ ${d2.month}/${d2.day}/${d2.year}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal)),
                const SizedBox(width: 8),
                const Icon(
                  Icons.how_to_vote_outlined,
                  size: 14,
                ),
                Text("${eventInfo.EventTotalVotes} KPoints",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal))
                // const Icon(
                //   Icons.how_to_vote_outlined,
                //   size: 14,
                // ),
                // Text("${eventInfo.EventTotalVotes ?? 0} 🔥",
                //     style: const TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.normal))
              ],
            ),
          ),
          // Container(
          //   // height: 245,
          //   //decoration: const BoxDecoration(
          //   // color: Colors.white,
          //   // Color.fromARGB(255, 198, 38, 65),
          //   //borderRadius: BorderRadius.all(Radius.circular(11)),
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: const BorderRadius.all(Radius.circular(5)),
          //       image: DecorationImage(
          //           image: NetworkImage('${eventInfo.EventImage}'),
          //           fit: BoxFit.fill)),
          //   width: MediaQuery.of(context).size.width * 0.85,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              height: 180,
              width: MediaQuery.of(context).size.width * 0.80,
              // color: Colors.red,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  child: Image.network(eventInfo.EventImage!)),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          voteProvider.date?['time'] == null
              ? const CircularProgressIndicator()
              : DateTime.parse(voteProvider.date?['time']).compareTo(d) >= 0 &&
                      DateTime.parse(voteProvider.date?['time'])
                              .compareTo(d2) <=
                          0
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => VoteNow(
                                                  eventsInfo: eventInfo,
                                                  isVote: true,
                                                ))) ??
                                    false;

                                // setState(() {
                                //   isLoading = true;
                                // });
                                // await getUserInfo();
                                // await getEvents(
                                //     isRefresh: true);
                                // setState(() {
                                //   refreshChangeListener.refreshed =
                                //       true;
                                // });
                              },
                              // ignore: sort_child_properties_last
                              child: const Text(
                                "Participate",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromRGBO(196, 38, 64, 1),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                            color:
                                                Color.fromARGB(236, 38, 35, 35),
                                            width: 1.5)),
                                  )))),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => VoteNow(
                                                eventsInfo: eventInfo,
                                                isVote: false,
                                              ))) ??
                                  false;

                              // await getUserInfo();
                              // setState(() {
                              //   refreshChangeListener.refreshed =
                              //       true;
                              // });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(196, 38, 64, 1),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                        color: Color.fromARGB(236, 38, 35, 35),
                                      )),
                                )),
                            child: const Text(
                              "View Result",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ),
                    ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
