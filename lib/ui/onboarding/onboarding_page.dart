import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class OnBoardingPage extends StatelessWidget {
  var listPages;
  String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    listPages = [
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.only(top: 48),
          child: Image.asset('assets/images/onboarding/onboarding_1.png'),
        ),
        titleWidget: Text(
          "Sanat Kimliğini Yarat",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body:
            "Sanatçı ruhunu ortaya çıkar, yeteneklerini hedef kitlenle paylaş",
      ),
      PageViewModel(
        image: Image.asset('assets/images/onboarding/onboarding_2.png'),
        titleWidget: Text(
          "Etkinlikler Bir Tık Uzağında",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body:
            "Çevrende olup biten sanatsal etkinliklerden haberdar ol, etkinliklerini paylaş!",
      ),
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.only(top: 48),
          child: Image.asset('assets/images/onboarding/onboarding_3.png'),
        ),
        titleWidget: Text(
          "Topluluğunu Oluştur",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body:
            "Yeni ekip arkadaşları bul\nMevcut ekiplere katılarak gücünü birleştir",
      ),
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.only(top: 48),
          child: Image.asset('assets/images/onboarding/onboarding_4.png'),
        ),
        titleWidget: Text(
          "Diğer Sanatseverleri Destekle",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body:
            "Sanatseverlerin paylaşımlarını beğendiğini göster, desteğini yansıt!",
      ),
    ];

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: listPages,
      onDone: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt("initScreen", 1);
        NavigationService.instance
            .navigateReplacement(k_ROUTE_VERSION_CONTROL_PAGE);
      },
      onSkip: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt("initScreen", 1);
        NavigationService.instance
            .navigateReplacement(k_ROUTE_VERSION_CONTROL_PAGE);
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
}
