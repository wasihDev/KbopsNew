import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference user = FirebaseFirestore.instance.collection('users');

Future<void> userSetup(
  String username,
  String userimage,
  String Email,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userid = auth.currentUser!.uid.toString();
  final result = await doesUserExist(userid);
  print(result);
  if (!result) {
    user.doc(userid).set({
      'userid': userid,
      'username': username,
      'userimage': userimage,
      'email': Email,
      'totalkpoints': 0,
      'myreferralcode': "",
      'socialmedia': "",
      'rewardDate': "",
      'referralUsed': false,
      'termsAndAgreement': false,
      'ads': 0,
      'ads2': 0,
      'adsDate': ''
    });
  }
}

doesUserExist(uid) async {
  try {
// if the size of value is greater then 0 then that doc exist.
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userid', isEqualTo: uid)
        .get()
        .then((value) => value.size > 0 ? true : false);
  } catch (e) {
    print(e.toString());
  }
}
