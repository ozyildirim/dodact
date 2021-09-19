import 'dart:async';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';

class SpinnerPage extends StatefulWidget {
  @override
  _SpinnerPageState createState() => _SpinnerPageState();
}

class _SpinnerPageState extends BaseState<SpinnerPage> {
  StreamController<int> selected = StreamController<int>();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var value = 0;

    final items = <String>[
      'Grogu',
      'Mace Windu',
      'Obi-Wan Kenobi',
      'Han Solo',
      'Luke Skywalker',
      'Darth Vader',
      'Yoda',
      'Ahsoka Tano',
    ];

    List<FortuneItem> objeler = [
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
      FortuneItem(
        child: Text("Kaynak Önerisi"),
        style: FortuneItemStyle(
            color: Colors.orange[900],
            borderColor: Colors.orangeAccent,
            borderWidth: 10),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dodact Çark'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
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
                selected: selected.stream,
                afterSpinningValue: value,
                items: objeler,
                onAnimationEnd: () async {
                  print("animasyon bitti");
                  print(value);
                },
                onAnimationStart: () {},
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GFButton(
              shape: GFButtonShape.pills,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  var sayi = Fortune.randomInt(0, objeler.length);
                  selected.add(sayi);
                });
              },
              child: Text(
                "Çevir",
                style: TextStyle(fontSize: 18, fontFamily: "Raleway"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
