import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/userdata.dart';

class ReportComment extends StatefulWidget {
  ReportComment({Key? key, this.userinfo, this.com, this.user})
      : super(key: key);
  Userinfo? userinfo;
  Comments? com;
  Userinfo? user;
  @override
  State<ReportComment> createState() =>
      _ReportCommentState(userinfo, com, user);
}

class _ReportCommentState extends State<ReportComment> {
  _ReportCommentState(this.userinfo, this.com, this.user);
  Userinfo? userinfo;
  Comments? com;
  Userinfo? user;

  bool isChecked = false;
  bool chk1 = false;
  bool chk2 = false;
  bool chk3 = false;
  bool chk4 = false;
  bool chk5 = false;
  bool chk6 = false;
  bool chk7 = false;
  bool chk8 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 196, 38, 64),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Report Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Please select if user behaviour fails at least one of the below category:',
                            style: TextStyle(fontSize: 13),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Text('Illegal information',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk1,
                                onChanged: (value) {
                                  setState(() {
                                    chk1 = value!;
                                  });
                                },
                              ),
                              Text('Sexually explicit content',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk2,
                                onChanged: (value) {
                                  setState(() {
                                    chk2 = value!;
                                  });
                                },
                              ),
                              Text('Swearing/Personal abuse',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk3,
                                onChanged: (value) {
                                  setState(() {
                                    chk3 = value!;
                                  });
                                },
                              ),
                              Text('Exposure of personal information',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk4,
                                onChanged: (value) {
                                  setState(() {
                                    chk4 = value!;
                                  });
                                },
                              ),
                              Text(
                                  'Spamming/Repeated post of the same\ncontent (duplicate post)',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk5,
                                onChanged: (value) {
                                  setState(() {
                                    chk5 = value!;
                                  });
                                },
                              ),
                              Text('Copyright infringement',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk6,
                                onChanged: (value) {
                                  setState(() {
                                    chk6 = value!;
                                  });
                                },
                              ),
                              Text(
                                  'Inappropriate user/Cyberbullying\n(Causing discomfort)',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk7,
                                onChanged: (value) {
                                  setState(() {
                                    chk7 = value!;
                                  });
                                },
                              ),
                              Text('Inappropriate or unrelated service)',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                'To continue, please agree to our terms of service:',
                                style: TextStyle(fontSize: 14),
                              )),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Checkbox(
                                value: chk8,
                                onChanged: (value) {
                                  setState(() {
                                    chk8 = value!;
                                  });
                                },
                              ),
                              Text(
                                  'I have agreed to the Term of Service\nand Privacy Policy.',
                                  style: TextStyle(fontSize: 12))
                            ],
                          ),
                          Text('Notice:'),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'images/pin.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    ' Reported content will be reviewed by our team and may perform necessary actions.',
                                    maxLines: 5,
                                    style: TextStyle(fontSize: 12),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'images/pin.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    'If the reviewed user is identified as either inappropriate or found out the behaviour does not comply with our terms and prvacy policy.',
                                    maxLines: 5,
                                    style: TextStyle(fontSize: 12),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'images/pin.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                      'If the report is found to be fraud, service may become restricted for the reporter.',
                                      maxLines: 5,
                                      style: TextStyle(fontSize: 12)))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    Colors.black, //background color of button
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                if (isChecked ||
                                    chk1 ||
                                    chk2 ||
                                    chk3 ||
                                    chk4 ||
                                    chk5 ||
                                    chk6 ||
                                    chk7 ||
                                    chk7 ||
                                    chk8) {
                                  postReport();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "[✓] Please select at least one category")));
                                }
                              },
                              child: Text(
                                'SUBMIT REPORT',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                        ]),
                  ))

              //     Text('Reports content will be reviewed by our team\n and may perform necessory actions',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w400),),
              //
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  postReport() async {
    var description = '';
    if (isChecked) {
      description += "illegal Information ";
    }
    if (chk1) {
      description += 'Sexually explicit content';
    }
    if (chk2) {
      description += 'Swearing/Personal abuse';
    }
    if (chk3) {
      description += 'Exposure pf personal information';
    }
    if (chk4) {
      description +=
          'Spamming/Reapeted post of the \n same content(duplicate content)';
    }
    if (chk5) {
      description += 'copyright infringment';
    }
    if (chk6) {
      description += 'inappropriate user/Cyberbullying (Causing discomfort)';
    }
    if (chk7) {
      description += 'other(inappropriate or unrelated service)';
    }
    var firbase = FirebaseFirestore.instance;
    final CollectionReference collectionRef = firbase.collection('report');
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRef
        .doc(id)
        .set({
          'WhoReportedID': userinfo?.UserID,
          'ReportedDate': myTimeStamp,
          'commentId': com?.CommentID ?? "",
          'ReportID': id,
          'ReportDescription': description,
          'ReportAgree': chk8,
        })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print("Error: $error"));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Text("» Our team will review the submitted report.")));
    }
    Navigator.pop(context);
  }
}
