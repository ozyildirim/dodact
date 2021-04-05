import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const purple = Color(0xff8A2387);
const red = Color(0xffE94057);
const orange = Color(0xffF27121);

const oxfordBlue = Color(0xFF161A2C);
const bone = Color(0xFFDDD5C1);
const darkGreen = Color(0xFF003322);

const kPrimaryColor = Colors.black;
const kPrimaryLightColor = Colors.white;
const kBackgroundColor = Color(0xFFF1F0F2);
const kBackgroundColorDarker = Color(0xFF929292);

const kButtonFontSize = 20;

const kFontFamily = "Rubik";

const guzel = Color(0xFF162A49);

final spinkit = SpinKitChasingDots(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.black : Colors.grey,
      ),
    );
  },
);
