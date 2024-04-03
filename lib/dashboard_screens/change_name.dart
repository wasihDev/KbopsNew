// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:kbops/utils/firebase.dart';
//
// class ChangeName extends StatefulWidget {
//   const ChangeName({Key? key,}) : super(key: key);
//
//   @override
//   State<ChangeName> createState() => _ChangeNameState();
// }
//
// class _ChangeNameState extends State<ChangeName> {
//   @override
//   void initState(){
//     super.initState();
//     fetchuserinfo();
//   }
//
//   final _formKey = GlobalKey<FormState>();
//   FocusNode inputNode = FocusNode();
//
//   void openKeyboard() {
//     FocusScope.of(context).requestFocus(inputNode);
//   }
//   final NameController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.black,
//           elevation: 0,
//           title: Row(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   if (Navigator.canPop(context)) {
//                     Navigator.pop(context);
//                   } else {
//                     SystemNavigator.pop();
//                   }
//                 },
//                 icon: Icon(
//                   Icons.close,
//                   size: 25,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(
//                 width: 20,
//               ),
//               Text(
//                 "Change name",
//                 style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//               ),
//               Spacer(),
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.save_as_outlined,
//                   size: 25,
//                   color: Colors.blue,
//                 ),
//               )
//             ],
//           ),
//         ),
//         backgroundColor: Colors.black,
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: BorderRadius.all(Radius.circular(10))),
//                   child: TextFormField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Enter Name';
//                       }
//                       return null;
//                     },
//                     controller: NameController,
//                     focusNode: inputNode,
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       prefixIcon: Icon(Icons.person),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 IconButton(
//                   onPressed: () {
//
//                   },
//                   icon: Icon(
//                     Icons.save_as_outlined,
//                     size: 25,
//                     color: Colors.blue,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
//
//
// }
// //
