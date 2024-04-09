import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kbops/models/userdata.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ParticipantCard extends StatelessWidget {
  final EventsParticipant participant;
  final int index;
  final bool isVote;
  var pro;
  final VoidCallback ontap;
  ParticipantCard(
      {super.key,
      required this.participant,
      required this.index,
      required this.isVote,
      required this.pro,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: index == 0
                        ? const Color.fromARGB(255, 238, 233, 233)
                        : const Color.fromARGB(255, 246, 246, 250),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.11,
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
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: '${index + 1}',
                                      style: TextStyle(
                                        color: index == 0
                                            ? const Color.fromARGB(
                                                255, 198, 38, 65)
                                            : const Color.fromARGB(
                                                255, 198, 38, 65),
                                        fontWeight: FontWeight.bold,
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
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.52,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                      "  ${participant.ParticipantName.toString()}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: index == 0
                                              ? Colors.black
                                              : Colors.black)),
                                  const SizedBox(height: 10),
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
                                              animation: true,
                                              lineHeight: 16.0,
                                              animationDuration: 100,
                                              percent: pro,
                                              barRadius:
                                                  const Radius.circular(10),
                                              center: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.how_to_vote_rounded,
                                                    color: Colors.white,
                                                    size: 10,
                                                  ),
                                                  Text(
                                                    "${participant.ParticipantTotalVotes}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              linearStrokeCap:
                                                  // ignore: deprecated_member_use
                                                  LinearStrokeCap.roundAll,
                                              progressColor:
                                                  const Color.fromARGB(
                                                      255, 108, 4, 22),
                                            ),
                                          ]))
                                ])),
                        isVote
                            ? InkWell(
                                onTap: ontap,
                                child: Image.asset(
                                  'images/Heart Voting.png',
                                  // width: 38,
                                  scale: 10,
                                ))
                            : Container(),
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
  }
}
