import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget icon;
  final Function() onPressed;
  final Color color;
  final Text titleText;

  const CustomButton({
    this.icon,
    this.onPressed,
    this.titleText,
    this.color,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 15,
          ),
          titleText
        ],
      ),
    );
  }
}
