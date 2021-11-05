import 'package:flutter/material.dart';

class CurvedListItem extends StatelessWidget {
  const CurvedListItem(
      {this.title,
      this.conImage,
      this.spaceValue,
      this.boxSize,
      this.textPos,
      this.onTap});

  final String title;
  final AssetImage conImage;
  final int spaceValue;
  final int boxSize;
  final double textPos;
  final Function() onTap;

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
                    onTap: onTap,
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
                    child: Container(
                      child: Text(
                        title,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
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
