import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreationPage extends StatelessWidget {
  int space = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        backwardsCompatibility: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: false,
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
              CurvedListItem(
                textPos: 180,
                boxSize: 240,
                spaceValue: 440,
                title: 'Topluluk Olustur',
                conImage:
                    AssetImage('assets/images/creation/icerik_olustur.jpeg'),
              ),
              CurvedListItem(
                textPos: 180,
                boxSize: 240,
                spaceValue: 285,
                title: 'Ekip Olustur',
                conImage:
                    AssetImage('assets/images/creation/grup_olustur.jpeg'),
              ),
              CurvedListItem(
                textPos: 150,
                boxSize: 246,
                spaceValue: 110,
                title: 'Etkinlik Oluştur',
                conImage:
                    AssetImage('assets/images/creation/etkinlik_olustur.jpeg'),
              ),
              CurvedListItem(
                textPos: 120,
                boxSize: 180,
                spaceValue: 0,
                title: 'İçerik Oluştur',
                conImage:
                    AssetImage('assets/images/creation/icerik_olustur.jpeg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    this.title,
    this.conImage,
    this.spaceValue,
    this.boxSize,
    this.textPos,
  });

  final String title;
  final AssetImage conImage;
  final int spaceValue;
  final int boxSize;
  final double textPos;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        Container(
          child: Column(
            children: [
              Container(
                height: spaceValue.toDouble(),
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      debugPrint(title);
                    },
                    child: Container(
                      height: boxSize.toDouble(),
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(80.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: conImage,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 32,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    bottom: textPos * 0.25.toDouble(),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
