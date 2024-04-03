import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kbops/dashboard_screens/bottom_nav.dart';
import 'package:kbops/dashboard_screens/terms_and_agreement.dart';
import 'package:kbops/utils/firebase.dart';
import 'package:kbops/sharedpref.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

import 'dashboard_screens/privacy_webview.dart';
import 'dashboard_screens/term_service_webiew.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? name;
  String? email;
  String? photo;
  String? socialmedia;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> twitter(BuildContext context) async {
    final twiiterlogin = TwitterLogin(
        apiKey: "6oIB5iXnP9uvWRIqz5oljFBvX",
        apiSecretKey: 'mNQ1LWcyshUeEWQTbfElDh1GUcldlmgdzFp4pNBpp0aILhNBAA',
        redirectURI: 'https://kbops-main.firebaseapp.com/__/auth/handler');
    await twiiterlogin.login().then((value) async {
      final authToken = value.authToken;
      final authTokenSecret = value.authTokenSecret;
      if (authToken != null && authTokenSecret != null) {
        final twitterAuthCredentials = TwitterAuthProvider.credential(
            accessToken: authToken, secret: authTokenSecret);
        await FirebaseAuth.instance
            .signInWithCredential(twitterAuthCredentials);
      }
    });
  }

  String _extractUsernameFromEmail(String email) {
    if (email.contains('@')) {
      return email.split('@')[0];
    }
    return email;
  }

  var state = false;
  Future<void> appleSignIn(BuildContext context) async {
    final isAvailable = await SignInWithApple.isAvailable();

    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final OAuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = result.user;
      log(_extractUsernameFromEmail(user!.email.toString()));
      log(user.displayName.toString());
      log(user.email.toString());
      log(user.photoURL.toString());
      setState(() {
        name = _extractUsernameFromEmail(user.email.toString());
        email = user.email.toString();
        photo = user.photoURL ??
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.escapeauthority.com%2Freview-south-end-psycho%2Fno-image-found%2F&psig=AOvVaw1adMK6dZj59nfQz22DPm4G&ust=1686408997997000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCMDQqZy5tv8CFQAAAAAdAAAAABAE";

        setUser(name, email, photo);
        if (user != null) {
          userSetup(
              _extractUsernameFromEmail(user.email.toString()),
              user.photoURL ??
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.escapeauthority.com%2Freview-south-end-psycho%2Fno-image-found%2F&psig=AOvVaw1adMK6dZj59nfQz22DPm4G&ust=1686408997997000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCMDQqZy5tv8CFQAAAAAdAAAAABAE",
              user.email.toString());
        }
      });
      if (result != null) {
        state = true;
      } //
      if (!isAvailable) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Apple Sign-In Not Available'),
              content:
                  const Text('Apple Sign-In is not available on this device.'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
      if (Platform.isIOS && Platform.version.startsWith('12')) {
        // Handle iOS 12 and lower versions differently
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('iOS Version Not Supported'),
              content: const Text('Apple Sign-In requires iOS 13 or later.'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    } catch (error) {
      log(error.toString());
      if (!isAvailable) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Apple Sign-In Error'),
              content: Text(error.toString()),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return;
    }
  }

  Future<void> signup(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        // Getting users credential
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;
        setState(() {
          name = user?.displayName.toString();
          email = user?.email.toString();
          photo = user?.photoURL.toString();
          setUser(name, email, photo);
          if (user != null) {
            userSetup(user.displayName.toString(), user.photoURL.toString(),
                user.email.toString());
          }
        });

        if (result != null) {
          state = true;
        } // if result not null we simply call the MaterialpageRoute,
        // for go to the HomePage screen
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Image.asset(
                      'images/main4.png',
                      fit: BoxFit.fitWidth,
                    )),
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    signup(context);
                  },
                  child: Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                            color: const Color.fromARGB(255, 12, 37, 84))),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'images/google.png',
                          height: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          "Sign in with Google",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Platform.isIOS
                  ? Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          log("SIGN IN Through Apple ");
                          appleSignIn(context);
                          //AuthService().SignInWithGoogle();
                        },
                        child: Container(
                          height: 45,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 12, 37, 84))),
                          child: Row(
                            children: const [
                              SizedBox(width: 10),
                              Icon(
                                Icons.apple,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Sign in with Apple",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  const Text('By signing up, you agree to: \n',
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  const Spacer(),
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TermsAndAgreement(
                                      kbopsTos:
                                          'https://main.kbops.online/terms-and-agreement/',
                                    )));
                      },
                      child: const Text('Terms of Service',
                          style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold))),
                  const Text(' and '),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PrivacyPolicy(
                                      kbopsPrivacyPolicy:
                                          'https://main.kbops.online/privacy-policy/',
                                    )));
                      },
                      child: const Text('Privacy Policy.',
                          style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold))),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "© 2024 kBOPS All Rights Reserved.",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  )),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        Positioned(
            top: 0,
            child: state
                ? Container(
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width * 1,
                    child: AlertDialog(
                      content: const Text(
                        'By signing in, you agree to our:\n\n ✓ Terms of Service. \n\n ✓ Privacy Policy. \n\n ✓You are 14 years old and older. ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 13),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'CONTINUE → ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () async {
                            await setLogin();
                            await acceptTermsAgreement();

                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BottomNav()),
                                  (route) => false);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : Container())
      ],
    ));
  }

// void logintwitter() async {
//   final twiiterlogin = TwitterLogin(
//       apiKey: "6oIB5iXnP9uvWRIqz5oljFBvX",
//       apiSecretKey: 'mNQ1LWcyshUeEWQTbfElDh1GUcldlmgdzFp4pNBpp0aILhNBAA',
//       redirectURI: 'https://kbops-main.firebaseapp.com/__/auth/handler');
//   await twiiterlogin.login().then((value) async {
//     final authToken = value.authToken;
//     final authTokenSecret = value.authTokenSecret;
//     if (authToken != null && authTokenSecret != null){
//       final twitterAuthCredentials = TwitterAuthProvider.credential(accessToken: authToken, secret: authTokenSecret);
//       await FirebaseAuth.instance.signInWithCredential(twitterAuthCredentials);
//     }
//   });
// }

  acceptTermsAgreement() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userid = auth.currentUser!.uid.toString();
    var firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefUser = firebase.collection('users');

    await collectionRefUser
        .doc(userid)
        .update({'termsAndAgreement': true})
        .then((value) => print("succes"))
        .onError((error, stackTrace) => print(error));
  }
}
