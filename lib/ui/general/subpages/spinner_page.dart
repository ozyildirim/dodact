import 'dart:async';
import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/spinner_result_model.dart';
import 'package:dodact_v1/services/concrete/firebase_spinner_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:intl/intl.dart';

class SpinnerPage extends StatefulWidget {
  @override
  _SpinnerPageState createState() => _SpinnerPageState();
}

class _SpinnerPageState extends BaseState<SpinnerPage> {
  FirebaseSpinnerService firebaseSpinnerService = FirebaseSpinnerService();
  StreamController<int> controller = StreamController<int>.broadcast();
  var result;

  bool isButtonAvailable = true;

  @override
  void dispose() {
    controller.close();

    super.dispose();
  }

  List<FortuneItem> categoryItems = [
    FortuneItem(
      child: Text(
        "Profesyonel Sanatçı",
        style: TextStyle(color: Colors.black),
      ),
      style: FortuneItemStyle(
          color: Colors.grey[200],
          borderColor: Colors.orangeAccent,
          borderWidth: 10),
    ),
    FortuneItem(
        child: Text("Eğitim Kurumu"),
        style: FortuneItemStyle(
            color: Colors.orange[900],
            borderColor: Colors.orangeAccent,
            borderWidth: 10)),
    FortuneItem(
      child: Text("Etkinlik Önerisi", style: TextStyle(color: Colors.black)),
      style: FortuneItemStyle(
          color: Colors.grey[200],
          borderColor: Colors.orangeAccent,
          borderWidth: 10),
    ),
    FortuneItem(
      child: Text("Kaynak Önerisi"),
      style: FortuneItemStyle(
          color: Colors.orange[900],
          borderColor: Colors.orangeAccent,
          borderWidth: 10),
    ),
    FortuneItem(
      child: Text("Sürpriz", style: TextStyle(color: Colors.black)),
      style: FortuneItemStyle(
          color: Colors.grey[200],
          borderColor: Colors.orangeAccent,
          borderWidth: 10),
    ),
  ];

  List<String> categoryTitles = [
    "Profesyonel Sanatçı",
    "Eğitim Kurumu",
    "Etkinlik Önerisi",
    "Kaynak Önerisi",
    "Sürpriz",
  ];

  List<Map<String, dynamic>> categoryRewards = [
    {
      'title': 'Profesyonel Sanatçılar',
      'rewards': [
        "Ahmet Cemil Demirbakan",
        "Kutay Yıldırım",
        "Salih Duhan Sayar",
        "İbrahim Çırak"
      ],
    },
    {
      'title': 'Eğitim Kurumları',
      'rewards': [
        "Oda Sahne Tiyatro Okulu",
        "Öznacar Sanat Okulu",
        "Yıldırım Sanat Okulu",
      ],
    },
    {
      'title': 'Etkinlik Önerileri',
      'rewards': [
        "Örnek Etkinlik 1",
        "Örnek Etkinlik 2",
        "Örnek Etkinlik 3",
      ],
    },
    {
      'title': 'Kaynak Önerileri',
      'rewards': [
        "Örnek Kaynak 1",
        "Örnek Kaynak 2",
        "Örnek Kaynak 3",
      ],
    },
    {
      'title': 'Sürprizler',
      'rewards': [
        "Örnek Sürpriz 1",
        "Örnek Sürpriz 2",
        "Örnek Sürpriz 3",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SpinnerResultsPage()));
              },
              icon: Icon(Icons.history))
        ],
        title: Text('Dodact Çark'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              child: FortuneWheel(
                animateFirst: false,
                indicators: [
                  FortuneIndicator(
                    child: Stack(children: [
                      Center(
                        child: Transform(
                          transform: Matrix4.rotationX(180),
                          child: TriangleIndicator(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(175.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ]),
                  )
                ],
                rotationCount: 6,
                selected: controller.stream,
                items: categoryItems,
                onAnimationEnd: () async {
                  print("animasyon bitti");
                  showSpinnerReward(result);
                },
                onAnimationStart: () {},
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isButtonAvailable
                ? FutureBuilder(
                    future: canUser(),
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == true) {
                          return GFButton(
                            shape: GFButtonShape.pills,
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                isButtonAvailable = false;
                                var sayi =
                                    Fortune.randomInt(0, categoryItems.length);
                                controller.add(sayi);
                                controller.stream.listen((value) {
                                  print(value);
                                  result = value;
                                });
                              });
                            },
                            child: Text(
                              "Çevir",
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Raleway"),
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "Her gün 1 kez çevirebilirsin",
                              style: TextStyle(fontSize: 22),
                            ),
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: spinkit,
                        );
                      } else {
                        return Center(
                          child: Text("Bir hata oluştu"),
                        );
                      }
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<bool> canUser() async {
    return firebaseSpinnerService
        .canUserUseSpinner(authProvider.currentUser.uid);
  }

  showSpinnerReward(int result) async {
    if (result != null) {
      var randomRewardOrder =
          Random().nextInt(categoryRewards[result].length - 1);

      // await CommonMethods().showSuccessDialog(context,
      //     "Kazandınız: " + categoryRewards[result]["rewards"][randomRewardOrder]);

      await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: "Kazandın",
        text:
            "${categoryRewards[result]["title"]} kategorisinden ${categoryRewards[result]["rewards"][randomRewardOrder]} kazandın.",
      );

      var spinnerResultObject = SpinnerResultModel(
        createdAt: DateTime.now(),
        userId: authProvider.currentUser.uid,
        reward: categoryRewards[result]["rewards"][randomRewardOrder],
        rewardTitle: categoryRewards[result]["title"],
      );

      await saveSpinnerResult(spinnerResultObject);
    } else {
      setState(() {
        var sayi = Fortune.randomInt(0, categoryItems.length);
        controller.add(sayi);
        controller.stream.listen((value) {
          print(value);
          result = value;
        });
      });
    }
  }

  saveSpinnerResult(SpinnerResultModel result) async {
    try {
      await firebaseSpinnerService.addSpinnerResult(result);
      setState(() {
        isButtonAvailable = true;
      });
    } catch (e) {
      print("kaydederken hata oldu");
      setState(() {
        isButtonAvailable = true;
      });
    }
  }
}

class SpinnerResultsPage extends StatefulWidget {
  @override
  _SpinnerResultsPageState createState() => _SpinnerResultsPageState();
}

class _SpinnerResultsPageState extends BaseState<SpinnerResultsPage> {
  FirebaseSpinnerService firebaseSpinnerService = FirebaseSpinnerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geçmiş"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: firebaseSpinnerService
              .getUserSpinners(authProvider.currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text((index + 1).toString()),
                    ),
                    title: Text(snapshot.data[index].reward,
                        style: TextStyle(fontSize: 18)),
                    subtitle: Text(snapshot.data[index].rewardTitle),
                    trailing: Text(DateFormat("dd/MM/yyyy")
                        .format(snapshot.data[index].createdAt)),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Hata"),
              );
            } else {
              return Center(
                child: spinkit,
              );
            }
          },
        ),
      ),
    );
  }
}
