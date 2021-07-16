import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: listPages,
      onDone: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt("initScreen", 1);
        NavigationService.instance.navigateReplacement(k_ROUTE_LANDING);
      },
      onSkip: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt("initScreen", 1);
        NavigationService.instance.navigateReplacement(k_ROUTE_LANDING);
      },
      showSkipButton: true,
      skip: Text(
        "Atla",
        style: TextStyle(color: Colors.black),
      ),
      next: const Icon(
        Icons.navigate_next,
        color: Colors.black,
      ),
      done: const Text("Başla",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.black,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  final listPages = [
    PageViewModel(
      titleWidget: Column(
        children: [
          SizedBox(
            height: 500,
          ),
          Text(
            "Sanatçı Kimliğini Yarat",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      body:
          "Here you can write the description of the page, to explain someting...",
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          SizedBox(
            height: 500,
          ),
          Text(
            "Ekibini Oluştur",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      body:
          "Here you can write the description of the page, to explain someting...",
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          SizedBox(
            height: 500,
          ),
          Text(
            "Etkinliklerden Haberdar Ol",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      body:
          "Here you can write the description of the page, to explain someting...",
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          SizedBox(
            height: 500,
          ),
          Text(
            "Sanatçı Kimliğini Yarat",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      body:
          "Here you can write the description of the page, to explain someting...",
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          SizedBox(
            height: 500,
          ),
          Text(
            "Sanatçı Kimliğini Yarat",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      body:
          "Here you can write the description of the page, to explain someting...",
    )
  ];
}
