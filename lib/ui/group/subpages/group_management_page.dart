import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class GroupManagementPage extends StatelessWidget {
  AppBar appBar = new AppBar(
    title: Text("Grup Yönetim"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  pageBody() {
    return Column(
      children: [],
    );
  }
}
