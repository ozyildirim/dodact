import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/application_model.dart';
import 'package:dodact_v1/provider/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ApplicationPageIntroductionPage();
                }));
              },
              icon: Icon(Icons.info))
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
      // child: Column(
      //   children: [
      //     // Card(
      //     //   margin: EdgeInsets.zero,
      //     //   elevation: 2,
      //     //   child: Container(
      //     //     height: size.height * 0.3,
      //     //     child: CachedNetworkImage(
      //     //         imageUrl:
      //     //             "https://ae01.alicdn.com/kf/HTB1U7dDX6LuK1Rjy0Fhq6xpdFXad.jpg",
      //     //         width: size.width,
      //     //         fit: BoxFit.cover),
      //     //   ),
      //     // ),
      //     // Expanded(
      //     //   child: buildCardPart(),
      //     // )
      //   ],
      // ),
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
            bool hasCreatorApplication = false;
            bool hasGroupApplication = false;

            for (var application in applications) {
              if (application.applicationType == "Streamer") {
                hasStreamerApplication = true;
              } else if (application.applicationType == "Creator") {
                hasCreatorApplication = true;
              } else if (application.applicationType == "Group") {
                hasGroupApplication = true;
              }
            }

            print("hasStreamerApplication: $hasStreamerApplication");
            print("hasCreatorApplication: $hasCreatorApplication");
            print("hasGroupApplication: $hasGroupApplication");

            return GridView(
              reverse: true,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: 2),
              children: [
                hasCreatorApplication == false
                    ? _buildCard(
                        Icons.post_add,
                        "İçerik&Etkinlik Üretici Başvurusu",
                        "Kendine özgü içeriklerinle topluluk arasındaki yerini al!",
                        () {
                        NavigationService.instance
                            .navigate(k_ROUTE_CREATOR_APPLICATION)
                            .then((value) => setState(() {}));
                      })
                    : Container(),
                hasStreamerApplication == false
                    ? _buildCard(Icons.live_tv, "Canlı Yayın Üretici Başvurusu",
                        "Canlı yayınlarını Dodact üzerinden yayınla, hedef kitlene daha kolay ulaş!",
                        () {
                        // NavigationService.instance
                        //     .navigate(k_ROUTE_STREAMER_APPLICATION)
                        //     .then((value) => setState(() {}));
                        showSnackBar("Çok yakında!");
                      })
                    : Container(),
                hasGroupApplication == false
                    ? _buildCard(Icons.group, "Topluluk Başvurusu",
                        "Topluluğunu Dodact'in gücü ile buluştur!", () {
                        NavigationService.instance
                            .navigate(k_ROUTE_GROUP_APPLICATION)
                            .then((value) => setState(() {}));
                      })
                    : Container(),
              ],
            );
          } else {
            return Center(
              child: Text("Bir hata oluştu."),
            );
          }
        });

    // return GridView(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 2, childAspectRatio: 1),
    //   children: [
    //     hasCreatorApplication != true
    // ? _buildCard(Icons.post_add, "İçerik&Etkinlik Üretici",
    //     "Kendine özgü içeriklerinle topluluk arasındaki yerini al!",
    //     () {
    //     NavigationService.instance
    //         .navigate(k_ROUTE_CREATOR_APPLICATION);
    //           })
    //         : Container(),
    //     hasStreamerApplication != true
    //         ? _buildCard(
    //             Icons.stream,
    //             "Canlı Yayın Üretici",
    //             "Canlı yayınlarını Dodact üzerinden yayınla, hedef kitlene daha kolay ulaş!",
    //             () {})
    //         : Container(),
    //     hasGroupApplication != true
    //         ? _buildCard(Icons.group, "Topluluk Başvurusu",
    //             "Topluluğunu Dodact'in gücü ile buluştur!", () {})
    //         : Container(),
    //   ],
    // );
  }

  showSnackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          message,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  _buildCard(IconData icon, String title, String description, Function onTap,
      {String groupId}) {
    var cardBackgroundColor = Color(0xFFF8F9FA);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
        image: SvgPicture.asset(
          'assets/images/application_page/application_onboarding1.svg',
          height: size.height * 0.3,
          currentColor: kNavbarColor,
        ),
        titleWidget: Text(
          "İçeriklerini & Etkinliklerini Herkes Kolaylıkla Görsün",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        body:
            "Dodact içerisinde içeriklerini ve etkinliklerini yayınlayarak hedef kitlene kolaylıkla ulaş. Belirli koşulları karşılaman durumunda kolaylıkla içeriklerini paylaşabilirsin!",
      ),
      PageViewModel(
        image: SvgPicture.asset(
          'assets/images/application_page/application_onboarding2.svg',
          height: size.height * 0.3,
          currentColor: kNavbarColor,
        ),
        titleWidget: Text(
          "Canlı Yayınlarını Dodact Üzerinden Paylaş",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        body:
            "Canlı yayınlarını Dodact üzerinden paylaşarak, diğer sanatçı takipçilerinle kolayca interaktif bir süreç başlatabilirsin.",
      ),
      PageViewModel(
        image: Image.asset('assets/images/onboarding/onboarding_1.png'),
        titleWidget: Text(
          "Topluluğunu Oluştur & Topluluğa Katıl",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        body:
            "Dahil olduğun sanat topluluğunu Dodact üzerinde temsil etme şansı yakala ve çalışmalarını daha çok kişiye ulaştır. Yeni ekip arkadaşları bulabilir ya da mevcut ekiplere katılarak gücünü birleştirebilirsin.",
      ),
    ];

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    // );
    return SafeArea(
      child: IntroductionScreen(
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
      ),
    );
  }
}
