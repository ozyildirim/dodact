import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double width;
  const TextFieldContainer({Key key, this.child, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: width != null ? width : size.width * 0.8,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 5.0,
            spreadRadius: 0.5,
          ),
        ],
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
