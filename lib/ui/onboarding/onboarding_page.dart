import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends BaseState<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPages,
      onDone: () {
        NavigationService.instance.navigate('/landing');
      },
      onSkip: () {
        NavigationService.instance.navigate('/landing');
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
              borderRadius: BorderRadius.circular(25.0))),
    );
  }

  var listPages = [
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
