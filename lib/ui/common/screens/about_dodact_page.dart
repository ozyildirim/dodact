import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class AboutDodactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodact Nedir?'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
