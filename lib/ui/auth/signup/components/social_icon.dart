import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  final Color backgroundColor;
  const SocialIcon({
    Key key,
    this.iconSrc,
    this.press,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          iconSrc,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
