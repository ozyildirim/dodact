import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class OnBoardingPage extends StatelessWidget {
  var listPages;
  @override
  Widget build(BuildContext context) {
    listPages = [
      PageViewModel(
        image: Image.asset('assets/images/onboarding/onboarding_6.png'),
        titleWidget: Text(
          "Sanatçı Kimliğini Yarat",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body:
            "Sanatçı ruhunu ortaya çıkar, yeteneklerini binlerce kişiye sergile.",
      ),
      PageViewModel(
        image: Image.asset('assets/images/onboarding/onboarding_1.png'),
        titleWidget: Text(
          "Ekibini Oluştur",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body:
            "Yeni ekip arkadaşları bul ya da mevcut ekiplere katılarak gücünü birleştir.",
      ),
      PageViewModel(
        image: Image.asset('assets/images/onboarding/onboarding_7.png'),
        titleWidget: Text(
          "Etkinlikler Bir Tık Uzağında",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        body:
            "Çevrende olup biten sanatsal aktivitelerden haberdar ol, kendi etkinliklerini de başkalarına ulaştır!",
      ),
      PageViewModel(
        image: Image.asset('assets/images/onboarding/onboarding_8.png'),
        titleWidget: Text(
          "Sanatınla Değer Yarat",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        //TODO: Buraya metin yazısı yazılacak
        body: "YAZI BUL",
      )
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
}
