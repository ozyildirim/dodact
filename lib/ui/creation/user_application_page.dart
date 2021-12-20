import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/application_model.dart';
import 'package:dodact_v1/provider/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApplicationMenuPage extends StatefulWidget {
  @override
  State<UserApplicationMenuPage> createState() =>
      _UserApplicationMenuPageState();
}

class _UserApplicationMenuPageState extends BaseState<UserApplicationMenuPage> {
  ApplicationProvider applicationProvider;

  @override
  void initState() {
    super.initState();
    checkIntroduction();
    applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
  }

  checkIntroduction() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var result = _prefs.getInt("userApplicationsIntroductionScreen");
    if (result == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ApplicationPageIntroductionPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Başvur"),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ApplicationPageIntroductionPage();
              }));
            },
            icon: Icon(Icons.info),
          ),
          IconButton(
              icon: Icon(
                Icons.history_outlined,
              ),
              onPressed: () {
                NavigationService.instance
                    .navigate(k_ROUTE_USER_APPLICATION_HISTORY)
                    .then((value) => setState(() {}));
              })
        ],
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop),
          image: AssetImage(kBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: buildCardPart(),
      ),
    );
  }

  buildCardPart() {
    return FutureBuilder(
        future: applicationProvider
            .getUserApplications(userProvider.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: spinkit,
            );
          } else if (snapshot.hasData) {
            List<ApplicationModel> applications = snapshot.data;

            bool hasStreamerApplication = false;
            bool hasContentCreatorApplication = false;
            bool hasEventCreatorApplication = false;
            bool hasGroupApplication = false;

            for (var application in applications) {
              if (application.applicationType == "Streamer") {
                hasStreamerApplication = true;
              } else if (application.applicationType == "Content_Creator") {
                hasContentCreatorApplication = true;
              } else if (application.applicationType == "Event_Creator") {
                hasEventCreatorApplication = true;
              } else if (application.applicationType == "Group") {
                hasGroupApplication = true;
              }
            }

            print("hasStreamerApplication: $hasStreamerApplication");
            print(
                "hasContentCreatorApplication: $hasContentCreatorApplication");
            print("hasEventCreatorApplication: $hasEventCreatorApplication");
            print("hasGroupApplication: $hasGroupApplication");

            return Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  hasContentCreatorApplication == false &&
                          userProvider.currentUser.permissions["create_post"] ==
                              false
                      ? _buildCard(Icons.post_add, "İçerik Üretici Başvurusu",
                          "Kendine özgü içeriklerini sanatseverlerle paylaş!",
                          () {
                          NavigationService.instance
                              .navigate(k_ROUTE_CONTENT_CREATOR_APPLICATION)
                              .then((value) => setState(() {}));
                        })
                      : Container(),
                  hasEventCreatorApplication == false &&
                          userProvider
                                  .currentUser.permissions["create_event"] ==
                              false
                      ? _buildCard(
                          Icons.post_add,
                          "Etkinlik Oluşturucu Başvurusu",
                          "Sanatsal aktivitelerini diğer sanatseverlere kolayca ulaştır!",
                          () {
                          NavigationService.instance
                              .navigate(k_ROUTE_EVENT_CREATOR_APPLICATION)
                              .then((value) => setState(() {}));
                        })
                      : Container(),
                  hasGroupApplication == false &&
                          userProvider
                                  .currentUser.permissions["create_group"] ==
                              false
                      ? _buildCard(Icons.group, "Topluluk Başvurusu",
                          "Sanat topluluğu oluştur, mevcut topluluklara katıl",
                          () {
                          NavigationService.instance
                              .navigate(k_ROUTE_GROUP_APPLICATION)
                              .then((value) => setState(() {}));
                        })
                      : Container(),

                  hasAnythingToApply(
                              hasStreamerApplication,
                              hasContentCreatorApplication,
                              hasEventCreatorApplication,
                              hasGroupApplication) ==
                          false
                      ? Container(
                          child: Center(
                            child: Text(
                              "Tüm başvuruları gerçekleştirdin, mevcut başvurularını sağ üstteki menüden takip edebilirsin",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: kPageCenteredTextSize,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      : Container(),
                  // hasStreamerApplication == false &&
                  //         userProvider
                  //                 .currentUser.permissions["create_stream"] ==
                  //             false
                  //     ? _buildCard(Icons.live_tv, "Yayıncı Başvurusu",
                  //         "Canlı yayınlarını Dodact üzerinden yayınla, hedef kitlene daha kolay ulaş!",
                  //         () {
                  //         // NavigationService.instance
                  //         //     .navigate(k_ROUTE_STREAMER_APPLICATION)
                  //         //     .then((value) => setState(() {}));
                  //         showSnackBar("Çok yakında!");
                  //       })
                  //     : Container(),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("Bir hata oluştu."),
            );
          }
        });
  }

  hasAnythingToApply(
      bool hasStreamerApplication,
      bool hasContentCreatorApplication,
      bool hasEventCreatorApplication,
      bool hasGroupApplication) {
    if (hasContentCreatorApplication == false &&
        hasEventCreatorApplication == false &&
        hasGroupApplication == false) {
      return true;
    } else {
      return false;
    }
  }

  showSnackBar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }

  _buildCard(IconData icon, String title, String description, Function onTap,
      {String groupId}) {
    // var cardBackgroundColor = Color(0xFFF8F9FA);
    var cardBackgroundColor = Colors.grey[100];
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: cardBackgroundColor,
          child: Container(
            width: size.width * 0.2,
            height: size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 8,
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.12,
                    child: Icon(icon, size: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplicationPageIntroductionPage extends StatelessWidget {
  var listPages;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    listPages = [
      PageViewModel(
        image: Image.asset(
          'assets/images/application_page/application_onboarding_1.png',
          height: size.height * 0.3,
        ),
        titleWidget: Text(
          "İçeriklerinle Görünür Ol",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        body:
            "Dodact'ta içeriklerini kolayca paylaşır, farkedilir ve hedef kitlene ulaşırsın",
      ),
      PageViewModel(
        image: Image.asset(
          'assets/images/application_page/application_onboarding_2.png',
          height: size.height * 0.4,
        ),
        titleWidget: Text(
          "Etkinliklerinle Sanatseverleri Bir Araya Getir",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        body:
            "Dodact'ta yayınladığın etkinlikler ile sanatseverleri bir araya getirir, sanata katkı sağlarsın",
      ),
      PageViewModel(
        image: Image.asset(
          'assets/images/application_page/application_onboarding_3.png',
          height: size.height * 0.3,
        ),
        titleWidget: Text(
          "Canlı Yayınlarını Dodact Üzerinden Paylaş",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        body:
            "Diğer platformlarda oluşturduğun(Twitch, Youtube vb.) yayınlarını sanatseverlere ulaştır",
      ),
      PageViewModel(
        image: Image.asset(
          'assets/images/onboarding/onboarding_3.png',
          height: size.height * 0.3,
        ),
        titleWidget: Text(
          "Topluluk Oluştur & Topluluğa Katıl",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        body:
            "Sanat topluluğu oluşturabilir ve/veya mevcut bir topluluğa katılabilirsin",
      ),
    ];

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    // );
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: listPages,
      onDone: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt("userApplicationsIntroductionScreen", 1);
        NavigationService.instance.pop();
      },
      onSkip: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt("userApplicationsIntroductionScreen", 1);

        NavigationService.instance.pop();
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
