import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kbops/dashboard_screens/profile.dart';
import 'package:kbops/dashboard_screens/store_screen.dart';
import 'package:kbops/vote_screens/screens/vote_now.dart';
import 'package:kbops/vote_screens/screens/vote_screen.dart';
import 'package:kbops/dashboard_screens/web_view.dart';
import '../components.dart';
import '../notificationservice/local_notification_service.dart';
import 'mission_daily_reward.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // This widget is the root of your application.
  int _selectedIndex = 2;
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
    const VoteScreen(),
    const MissionDailyReward(),
    WebViewExample(),
    const StoreScreen(),
    const Profile(),
  ];
  late PageController pageController;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: _selectedIndex);
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/votingbox.png',
                height: 25,
                width: 25,
                fit: BoxFit.fill,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/mission.png',
                height: 25,
                width: 25,
                fit: BoxFit.fill,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'images/kBOPS Mobile icon.png',
                  height: 65,
                  width: 65,
                  fit: BoxFit.fill,
                ),
                label: ''),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/shopping-cart.png',
                height: 25,
                width: 25,
                fit: BoxFit.fill,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/user.png',
                height: 25,
                width: 25,
                fit: BoxFit.fill,
              ),
              label: '',
            ),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 198, 38, 65),
          unselectedItemColor: const Color.fromARGB(255, 198, 38, 65),
          selectedFontSize: 14,
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Would you like to exit the app?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('❌ CANCEL'),
                    ),
                    const Spacer(),
                    MaterialButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text('EXIT →'),
                    ),
                  ],
                ),
              ],
            ));
    return Future.value(true);
  }
}
