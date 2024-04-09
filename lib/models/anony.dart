import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModels {
  // final String? id;
  final String imageSlider;
  BannerModels({required this.imageSlider});
  factory BannerModels.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return BannerModels(imageSlider: doc['imageSlider']);
  }
}
