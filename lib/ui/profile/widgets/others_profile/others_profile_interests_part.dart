import 'dart:ui';

import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class OthersProfileInterestsPart extends StatefulWidget {
  final UserObject user;

  OthersProfileInterestsPart({this.user});

  @override
  _OthersProfileInterestsPartState createState() =>
      _OthersProfileInterestsPartState();
}

class _OthersProfileInterestsPartState
    extends State<OthersProfileInterestsPart> {
  UserObject user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user.selectedInterests == null || user.selectedInterests.isEmpty) {
      return Container(
          child: Center(
        child: Text(
          "İlgi alanları belirtilmemiş",
          style: TextStyle(fontSize: kPageCenteredTextSize),
        ),
      ));
    } else {
      return SingleChildScrollView(
        child: Container(
          child: buildInterestElements(),
        ),
      );
    }
  }

  buildInterestElements() {
    var userInterests = [];
    user.selectedInterests.forEach((e) {
      if (categoryList.contains(e)) {
        return userInterests.add(e);
      } else {
        return null;
      }
    });

    print(userInterests);

    return MultiSelectChipDisplay(
        chipColor: Colors.grey[200],
        textStyle: TextStyle(color: Colors.black),
        items: userInterests.map((e) {
          return MultiSelectItem(e, e);
        }).toList());
  }
}
