import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbops/models/userdata.dart';
import 'package:kbops/state_management/event_provider.dart';
import 'package:kbops/state_management/vote_now_provider.dart';
import 'package:kbops/vote_screens/screens/vote_now.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  VoteNowProvider timestamp;
  String eventName;
  EventCard({super.key, required this.timestamp, required this.eventName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, _) {
          return FutureBuilder<List<EventsInfo>>(
            future: eventsProvider.getEvents(eventName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final data = events[index];
                    // EventsInfo? eventInfos = EventsInfo.fromMap(data);
                    Timestamp? t = events[index].EventStartDate;
                    DateTime d = t!.toDate();
                    Timestamp? t2 = events[index].EventEndDate;
                    DateTime d2 = t2!.toDate();
                    final eventInfo = events[index];
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: Center(
                                  child: Text(
                                eventInfo.EventStatus!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9),
                              )),
                            ),
                            title: Text(eventInfo.EventName ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${d.month}/${d.day} ~ ${d2.month}/${d2.day}/${d2.year}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.how_to_vote_outlined,
                                  size: 14,
                                ),
                                Text("${eventInfo.EventTotalVotes} KPoints",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal))
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
                          Container(
                            height: 245,
                            //decoration: const BoxDecoration(
                            // color: Colors.white,
                            // Color.fromARGB(255, 198, 38, 65),
                            //borderRadius: BorderRadius.all(Radius.circular(11)),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0)),
                                image: DecorationImage(
                                    image:
                                        NetworkImage('${eventInfo.EventImage}'),
                                    fit: BoxFit.fill)),
                            width: MediaQuery.of(context).size.width * 0.85,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          timestamp.date?['time'] == null
                              ? const CircularProgressIndicator()
                              : DateTime.parse(timestamp.date?['time'])
                                              .compareTo(d) >=
                                          0 &&
                                      DateTime.parse(timestamp.date?['time'])
                                              .compareTo(d2) <=
                                          0
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                VoteNow(
                                                                  eventsInfo:
                                                                      eventInfo,
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
                                                "VOTE",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromRGBO(
                                                        196, 38, 64, 1),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        side: const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    236,
                                                                    38,
                                                                    35,
                                                                    35),
                                                            width: 1.5)),
                                                  )))),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              VoteNow(
                                                                eventsInfo:
                                                                    eventInfo,
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
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  const Color.fromRGBO(
                                                      196, 38, 64, 1),
                                                ),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      side: const BorderSide(
                                                        color: Color.fromARGB(
                                                            236, 38, 35, 35),
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
                  },
                );
              } else {
                return Center(child: Text('No data available'));
              }
            },
          );
        },
      ),
    );
  }
}
