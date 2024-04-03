import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('images/$fileName').putData(await file.readAsBytes());
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> getImages(String userId, String imagePath) async {
    // final user = FirebaseAuth.instance.currentUser;
    // ListResult result = await storage.ref('images/').listAll();
    // List<Reference> allImages = result.items;
    // List<String> imageUrls = [];
    //print(imageUrls);
    // for (var imageRef in allImages) {
    //   String imageUrl = await imageRef.getDownloadURL();
    //   imageUrls.add(imageUrl);
    //   print(imageUrl);
    // }

    // Get a reference to the Firebase Storage location to store the image.
    final Reference storageRef = _storage
        .ref()
        .child('images/$userId/${DateTime.now().millisecondsSinceEpoch}');
    log("Storage Ref: ${storageRef.toString()}");
    // Upload the image file to Firebase Storage.
    File file = File(imagePath);
    final UploadTask uploadTask = storageRef.putData(await file.readAsBytes());
    log("File $file");
    //OLD===>>  final UploadTask uploadTask = storageRef.putFile(File(imagePath));

    final TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => log('Done'));

    // Get the download URL for the uploaded image.
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    // Image.network(downloadUrl);

    log("Download Image $downloadUrl");

    // Store the download URL in Firestore under the user's document.
    await _firestore.collection('users').doc(userId).update({
      'imageUrl': FieldValue.arrayUnion([downloadUrl])
    });

    return downloadUrl;
  }

  // Retrieve the list of images for a specific user from Firestore.
  Future<List<String>> getImagesForUser(String userId) async {
    final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    final List<dynamic> images = userDoc.get('imageUrl');
    return List<String>.from(images);
  }

////////////OLD GETIMAGES
}


// Future<String> getImages() async { 
//     final results = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: ['png', 'jpg'],
//     );
//     // Get a reference to the Firebase Storage location to store the image.
//     final Reference storageRef = _storage.ref('images/');
//     log("Storage Ref: ${storageRef.toString()}");
//     // Upload the image file to Firebase Storage.
//     File file = File(results!.files.single.path!);
//     final UploadTask uploadTask = storageRef.putData(await file.readAsBytes());
//     log("File ${file}");
//     //OLD===>>  final UploadTask uploadTask = storageRef.putFile(File(imagePath));

//     final TaskSnapshot taskSnapshot =
//         await uploadTask.whenComplete(() => log('Done'));

//     // Get the download URL for the uploaded image.
//     final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//     Image.network(downloadUrl);

//     log("Download Image $downloadUrl");

//     // Store the download URL in Firestore under the user's document.
//     await _firestore
//         .collection('users')
//         .doc('2HF3vUYEmuNeuP2TCD24sK2Xdns1')
//         .update({
//       'imageUrl': FieldValue.arrayUnion([downloadUrl])
//     });

//     return downloadUrl;
//   }
