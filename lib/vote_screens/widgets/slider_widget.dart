import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';

class SilderWidget extends StatelessWidget {
  const SilderWidget({
    super.key,
    required this.imgList,
  });

  final List<BannerModel> imgList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.24,
      child: BannerCarousel.fullScreen(
        borderRadius: 10,
        banners: imgList,
        height: MediaQuery.of(context).size.height * 0.3,
        initialPage: 0,
        customizedIndicators: const IndicatorModel.animation(
            width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
        activeColor: const Color.fromARGB(255, 192, 30, 21),
        disableColor: Colors.white,
        animation: true,
        indicatorBottom: false,

        // OR pageController: PageController(initialPage: 6),
      ),
    );
  }
}
