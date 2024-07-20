import 'dart:async';
import 'package:flutter/material.dart';

class ContainerWithImages extends StatefulWidget {
  @override
  _ContainerWithImagesState createState() => _ContainerWithImagesState();
}

class _ContainerWithImagesState extends State<ContainerWithImages> {
  final List<String> imageUrls = [
    "images/ai-generated-8672132_1920.jpg",
    "images/artem-beliaikin-BpQ-ClsKeXg-unsplash.jpg",
    "images/digital-art-with-planet-earth.jpg",
    "images/iron-1508269_1920.jpg",
    "images/recycle-concept-with-box-rubbish.jpg",
  ];
  int currentIndex = 0;
  late Timer timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % imageUrls.length;
        _pageController.animateToPage(
          currentIndex,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Adjust the height according to your preference
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0), // Customize border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0), // Clip rounded corners
        child: Stack(
          children: [
            PageView.builder(
              itemCount: imageUrls.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  imageUrls[index],
                  fit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              bottom: 10.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageUrls.length,
                  (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: currentIndex == index ? 10.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
