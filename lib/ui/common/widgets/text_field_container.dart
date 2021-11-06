import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;
  const TextFieldContainer(
      {Key key, this.child, this.width, this.height, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: height != null ? height : null,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: padding != null
          ? padding
          : EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
