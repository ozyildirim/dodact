import 'dart:async';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:getwidget/components/button/gf_button.dart';

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
        child: Text("Profesyonel Sanatçı"),
        style: FortuneItemStyle(color: Colors.blue),
      ),
      FortuneItem(
        child: Text("Eğitim Kurumu"),
        style: FortuneItemStyle(color: Colors.blueAccent),
      ),
      FortuneItem(
        child: Text("Etkinlik Önerisi"),
        style: FortuneItemStyle(color: Colors.deepPurple),
      ),
      FortuneItem(
        child: Text("Kaynak Önerisi"),
        style: FortuneItemStyle(color: Colors.red),
      ),
      FortuneItem(
        child: Text("Sürpriz"),
        style: FortuneItemStyle(color: Colors.green),
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
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Bana ne var?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FortuneWheel(
                  animateFirst: false,
                  rotationCount: 6,
                  selected: selected.stream,
                  items: objeler,
                  onAnimationEnd: () async {
                    print("animasyon bitti");
                    print(value);
                  },
                  onAnimationStart: () {},
                ),
              ),
            ),
            GFButton(
              onPressed: () {
                setState(() {
                  var sayi = Fortune.randomInt(0, objeler.length);
                  selected.add(sayi);
                });
              },
              child: Text("Çevir"),
            )
          ],
        ),
      ),
    );
  }
}
