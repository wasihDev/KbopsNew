import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:images_picker/images_picker.dart";
import 'package:kbops/loginscreen.dart';
import 'package:kbops/models/userdata.dart';
import 'package:kbops/sharedpref.dart';

import '../utils/functions.dart';

bool _isButtonDisabled = false;

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.userinfo}) : super(key: key);
  Userinfo? userinfo;

  @override
  State<EditProfile> createState() => _EditProfileState(userinfo);
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState(this.userinfo);

  final referralCodeController = TextEditingController();
  final referralCodeShowController = TextEditingController();
  final myReferralCodeController = TextEditingController();
  Userinfo? userinfo;
  var isLoading = false;
  var error = false;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = userinfo?.Username ?? "";
    socialMediaController.text = userinfo?.SocialMedia ?? "";
    myReferralCodeController.text = (userinfo?.MyReferralCode ?? "").isEmpty
        ? ""
        : (userinfo?.MyReferralCode?.substring(6) ?? "");
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Share my Referral Code »',
        text: 'Join kBOPS using my referral codes: ${userinfo?.MyReferralCode} to earn 20 KPoints. ',
        chooserTitle: 'Join kBOPS');
  }

  var referralLoading = false;

  Future<void> getUserInfo() async {
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final docs = await collectionRef.doc(userinfo!.UserID).get();
    userinfo = Userinfo.fromMap(docs);
    referralCodeShowController.text = userinfo?.MyReferralCode ?? "";

    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  final _refKey = GlobalKey<FormState>();

  final socialMediaController = TextEditingController();
  final nameController = TextEditingController();

  // final ImagePicker _picker = ImagePicker();
  File? image;

  // Capture a photo
  submitForm() async {
    hideKeyboard(context);
    if (_formKey.currentState!.validate()) {
      final res = await updateUserData();
      if (res) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("[✔︎] Profile has been updated.")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 196, 38, 64),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            children: [
              const Text("Edit Profile",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  submitForm();
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Ink(
                  child: const Text(
                    "Save →",
                    style: TextStyle(
                        fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 50,
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: image == null
                                  ? Image.network(userinfo?.UserImage ?? "",
                                  fit: BoxFit.cover)
                                  : Image.file(image!, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // XFile? pickedImage = await _picker.pickImage(
                          //     source: ImageSource.gallery);
                          List<Media>? res = await ImagesPicker.pick(
                            count: 1,
                            pickType: PickType.image,
                          );
                          if (res?.isNotEmpty ?? false) {
                            setState(() {
                              image = File(res?[0].path ?? "");
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              color: Color.fromRGBO(198, 37, 65, 1),
                            ),
                            Text(
                              "Choose Image",
                              style: TextStyle(
                                  color: Color.fromRGBO(198, 37, 65, 1)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.centerLeft, child: Text('Username')),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return " » Please enter a username.";
                        }
                        return null;
                      },
                      controller: nameController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: " ",
                          hintStyle: TextStyle(color: Colors.black)),
                      cursorColor: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Twitter @username')),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: socialMediaController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: '@username',
                          hintStyle: TextStyle(color: Colors.black)),
                      cursorColor: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('My Referral Code')),
                  const SizedBox(
                    height: 5,
                  ),
                  userinfo?.MyReferralCode?.isEmpty ?? false ?Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: error ? Colors.red : Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
    children: [
                          SizedBox(
                              height: 40,
                              width: 100,
                              child: Center(
                                child: Text(
                                  "kBOPS-",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              )),
                          SizedBox(
                          width: MediaQuery.of(context).size.width * 0.52,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: myReferralCodeController,

                              validator: (val) {
                                if (val!.isEmpty) {
                                  return " » Please create a Referral Code. \n ";
                                } else if (val.length < 4) {
                                  return "» Must be atleast 4 characters.";
                                } else if (val.length > 10) {
                                  return " » Maximum of 10 characters only. ";
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Create a referral code",

                                  hintStyle: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.normal),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      )):
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black),
                      borderRadius:
                      BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text("${userinfo?.MyReferralCode ?? ""}"),
                    ),
                  ),
                  error
                      ? const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '\n » Referral Code already exists.',
                        style: TextStyle(color: Colors.red),
                      ))
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(196, 38, 64, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _refKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (userinfo?.ReferralUsed ?? false)
                                ? Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                //border: Border.all(color: Colors.white70),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(
                                child: Text("[✔︎] Referral code claimed. "),
                              ),
                            )
                                : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.52,
                                      child: Center(
                                        child: TextFormField(
                                          controller: referralCodeController,
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return " » Please enter a referral code.\n ";
                                            } else if (!val
                                                .toLowerCase()
                                                .contains("kbops-")) {
                                              referralLoading=false;
                                              setState((){

                                              });
                                              return "» Referral code does not exist. \n ";
                                            }

                                          },
                                          decoration: const InputDecoration(
                                              hintText: "Add a referral code",
                                              hintStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                  horizontal: 10)),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 40,
                                      width: 130,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.black87,
                                          //background color of button
                                          shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                              borderRadius:
                                              BorderRadius.circular(12)),
                                        ),
                                        //onPressed: () async {

                                        onPressed: _isButtonDisabled ? null : ()
                                        async {
                                            setState(() {
                                              _isButtonDisabled = true;
                                              referralLoading = true;
                                            });
                                            hideKeyboard(context);
                                            if (_refKey.currentState!
                                                .validate()) {
                                              final res = await checkCode(
                                                  referralCodeController
                                                      .text);

                                              if (res != null) {
                                                await executeReferalCode(res);
                                                await getUserInfo();
                                                if (mounted) {
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "[✔︎] 20 KPoints for adding referral."),
                                                        duration:
                                                        Duration(seconds: 3),
                                                      ));
                                                }
                                              } else {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "» The referral code does not exist."),
                                                        duration:
                                                        Duration(seconds: 3),
                                                      ));
                                                }
                                              }
                                              setState(() {
                                                referralLoading = false;
                                                _isButtonDisabled = false;
                                              });
                                            }
                                        },
                                        child: referralLoading
                                            ? const Text ("Searching..",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.normal),
                                      )
                                        //CircularProgressIndicator(
                                         // color: Color.fromARGB( 255, 198, 37, 65)
                                       // )
                                            : const Text(
                                          "Submit",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .white70, //background color of button
                                  shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () async {
                                  await share();
                                },
                                child: Text(
                                  " « Share Referral Code » ️",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 40,
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(196, 38, 64, 1), //background color of button
                        shape: RoundedRectangleBorder(
                          //to set border radius to button
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        await _signOut();
                        await logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                                (route) => false);
                      },
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<LoginScreen> _signOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    final googleCurrentUser = firebaseAuth.currentUser;
    if (googleCurrentUser != null) {
      googleSignIn.signOut();
      await firebaseAuth.signOut();
    }

    return new LoginScreen();
  }

  Future<bool> updateUserData() async {
    setState(() {
      isLoading = true;
    });
    if (userinfo?.MyReferralCode != "kBOPS-${myReferralCodeController.text}") {
      final result =
      await checkMyCode("kBOPS-${myReferralCodeController.text}");
      if (result) {
        print("yes exist");
        setState(() {
          error = true;
          isLoading = false;
        });
        return false;
      } else {
        setState(() {
          error = false;
        });
      }
    }

    if (image != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('user/' + DateTime.now().toString());
      await ref.putFile(File(image!.path));
      String imageUrl = await ref.getDownloadURL();
      var firbase = FirebaseFirestore.instance;

      final CollectionReference collectionRefUser = firbase.collection('users');

      await collectionRefUser
          .doc(userinfo!.UserID)
          .update({
        'username': nameController.text,
        'userimage': imageUrl,
        'socialmedia': socialMediaController.text.isEmpty
            ? ""
            : socialMediaController.text,
        "myreferralcode": "kBOPS-${myReferralCodeController.text}"
      })
          .then((value) => print("succes"))
          .onError((error, stackTrace) => print(error));
    } else {
      var firbase = FirebaseFirestore.instance;

      final CollectionReference collectionRefUser = firbase.collection('users');

      await collectionRefUser
          .doc(userinfo!.UserID)
          .update({
        'username': nameController.text,
        'socialmedia': socialMediaController.text.isEmpty
            ? ""
            : socialMediaController.text,
        "myreferralcode": "kBOPS-${myReferralCodeController.text}"
      })
          .then((value) => print("succes"))
          .onError((error, stackTrace) => print(error));
    }

    return true;
  }

  Future<bool> checkMyCode(code) async {
    final collectionRef = FirebaseFirestore.instance.collection('users');
    var result = await collectionRef
        .where('myreferralcode', isEqualTo: code)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<Userinfo> checkCode(code) async {
    print(code);
    final collectionRef = FirebaseFirestore.instance.collection('users');
    var result = await collectionRef
        .where('myreferralcode', isEqualTo: code)
        .limit(1)
        .get();
    print(result.docs);
    return Userinfo.fromMap(result.docs[0]);
  }

  Future<bool> executeReferalCode(Userinfo referralUser) async {
    var firebase = FirebaseFirestore.instance;
    final CollectionReference collectionRefUser = firebase.collection('users');

    await collectionRefUser
        .doc(userinfo!.UserID)
        .update(
        {'totalkpoints': FieldValue.increment(20), 'referralUsed': true})
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    final CollectionReference collectionRefDonor = firebase.collection('users');

    await collectionRefDonor
        .doc(referralUser.UserID)
        .update({
      'totalkpoints': FieldValue.increment(20),
    })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));

    final CollectionReference collectionRefUsedHistory =
    firebase.collection('kPointsCharged');

    DateTime currentPhoneDate = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await collectionRefUsedHistory
        .doc(id)
        .set({
      'kPointsDate': FieldValue.serverTimestamp(),
      'kPointsId': id,
      'kPointsMethod': 'referral',
      'kPointsOption': ' 20 KPoints » Adding Referral ',
      'kPointsValue': 20,
      'userId': "${userinfo?.UserID}"
    })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    DateTime currentPhoneDate2 = DateTime.now();
    Timestamp myTimeStamp2 = Timestamp.fromDate(currentPhoneDate2);
    var id2 = DateTime.now().millisecondsSinceEpoch.toString();
    print(referralUser.UserID);
    await collectionRefUsedHistory
        .doc(id2)
        .set({
      'kPointsDate': FieldValue.serverTimestamp(),
      'kPointsId': id2,
      'kPointsMethod': 'invite',
      'kPointsOption': '20 KPoints » Friend Referral  ',
      'kPointsValue': 20,
      'userId': referralUser.UserID
    })
        .then((value) => print("success"))
        .onError((error, stackTrace) => print(error));
    return true;
  }
}
