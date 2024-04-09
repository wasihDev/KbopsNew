import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbops/dashboard_screens/faq.dart';
import 'package:kbops/dashboard_screens/support.dart';
import 'package:kbops/state_management/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'KPointsHistory.dart';
import 'about_screen.dart';
import 'account_withdrawl.dart';
import 'edit_profile.dart';

class WebViewProvider extends ChangeNotifier {
  String kbopsFaq = '';
  String kbopsNotice = '';
  String kbopsPrivacyPolicy = '';
  String kbopsSupport = '';
  String kbopsTos = '';
  String kbopswithdrawal = '';
  String ppopwithdrawal = '';

  Future<void> getWebView() async {
    final collectionRef = FirebaseFirestore.instance.collection('webviewlinks');
    final docs = await collectionRef.doc('c26Ice5IaicD2rjJXWR6').get();
    kbopsFaq = docs.get('kbopsFaq');
    kbopsNotice = docs.get('kbopsNotice');
    kbopsPrivacyPolicy = docs.get('kbopsPrivacyPolicy');
    kbopsSupport = docs.get('kbopsSupport');
    kbopsTos = docs.get('kbopsTos');
    kbopswithdrawal = docs.get('kbopswithdrawal');

    notifyListeners(); // Notify listeners once data is fetched
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // var pointsLoading = true;
  // NativeAd _ad;
  // bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    //loadNativeAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserProvider>(context, listen: false).getUserData();

    // final userProvider = Provider.of<UserProvider>(context);
    // userProvider.getUserData();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 196, 38, 64),
        title: Row(
          children: [
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Consumer<UserProvider>(builder: (context, userProvider, child) {
              return Row(
                children: [
                  Text(
                    "${userProvider.userInfo?.TotalKPoints ?? 0}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    'images/Heart Voting.png',
                    height: 30,
                    width: 30,
                  ),
                ],
              );
            })
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userProvider
                              .userInfo?.UserImage ??
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProvider.userInfo?.Username ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          userProvider.userInfo?.Email ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          (userProvider.userInfo?.MyReferralCode ?? ""),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        )
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 6),
              const Divider(thickness: 2),
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                return GestureDetector(
                  onTap: () async {
                    final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditProfile(
                                  userinfo: userProvider.userInfo,
                                )));
                    // Provider.of<UserProvider>(context, listen: false)
                    //     .getUserInfo();
                    // // setState(() {});
                  },
                  child: const ListTile(
                    leading: Text(
                      '☑︎Edit Profile →',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                );
              }),
              const Divider(thickness: 2),
              Consumer<WebViewProvider>(builder: (context, provider, _) {
                String kbopsFaq = provider.kbopsFaq;
                String kbopsPrivacyPolicy = provider.kbopsPrivacyPolicy;
                String kbopsSupport = provider.kbopsSupport;
                String kbopsTos = provider.kbopsTos;
                String kbopswithdrawal = provider.kbopswithdrawal;
                provider.getWebView();
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AccountWithdrawal(
                                      ppopwithdrawal:
                                          kbopswithdrawal.toString(),
                                    )));
                      },
                      child: const ListTile(
                        leading: Text('Account Deletion Request →',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FAQ(
                                      kbopsFaq: kbopsFaq.toString(),
                                    )));
                      },
                      child: const ListTile(
                        leading: Text(
                          'FAQ →',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                    const Divider(thickness: 2),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Support(
                                      kbopsSupport: kbopsSupport.toString(),
                                    )));
                      },
                      child: const ListTile(
                        leading: Text(
                          'Customer Service →',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => About(
                                      SendtoPriveacyPolicy:
                                          kbopsPrivacyPolicy.toString(),
                                      SendtoTOS: kbopsTos.toString(),
                                    )));
                      },
                      child: const ListTile(
                        leading: Text(
                          'About Us →',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
