import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kbops/dashboard_screens/privacy_webview.dart';
import 'package:kbops/dashboard_screens/terms_and_agreement.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'notification_setting.dart';

class About extends StatefulWidget {
  About({Key? key, required this.SendtoPriveacyPolicy, required this.SendtoTOS})
      : super(key: key);
  String SendtoPriveacyPolicy;
  String SendtoTOS;
  @override
  AboutState createState() => AboutState(SendtoPriveacyPolicy, SendtoTOS);
}

class AboutState extends State<About> {
  AboutState(this.SendtoPriveacyPolicy, this.SendtoTOS);
  String SendtoTOS;
  String SendtoPriveacyPolicy;
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 198, 37, 65),
        centerTitle: true,
        title: Text("About Us"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PrivacyPolicy(
                            kbopsPrivacyPolicy: SendtoPriveacyPolicy.toString(),
                          )));
            },
            child: ListTile(
              leading: Text('Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TermsAndAgreement(
                            kbopsTos: SendtoTOS,
                          )));
            },
            child: ListTile(
              leading: Text('Terms & Agreement',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          // GestureDetector(
          //onTap: (){
          //  Navigator.push(context,MaterialPageRoute(builder: (_)=>NotificationSetting()));
          // },
          //   child: ListTile(
          //  leading: Text('Notification Settings',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
          // trailing:Icon(Icons.navigate_next)
          //),
          // )
        ],
      ),
    );
  }
}
