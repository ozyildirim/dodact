import 'dart:ui';

import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GroupInterestsTabView extends StatelessWidget {
  final GroupModel group;

  GroupInterestsTabView({this.group});
  @override
  Widget build(BuildContext context) {
    if (group.selectedInterests != null) {
      if (group.selectedInterests.isNotEmpty) {
        return SingleChildScrollView(
          child: Container(
            child: buildInterestElements(),
          ),
        );
      }
    } else {
      return Container(
        child: Center(
          child: Text(
            "Topluluk İlgi alanı belirtilmemiş",
            style: TextStyle(
              fontSize: kPageCenteredTextSize,
            ),
          ),
        ),
      );
    }
  }

  buildInterestElements() {
    var groupInterests = [];
    group.selectedInterests.forEach((e) {
      if (categoryList.contains(e)) {
        return groupInterests.add(e);
      } else {
        return null;
      }
    });

    print(groupInterests);

    return MultiSelectChipDisplay(
        chipColor: Colors.grey[200],
        textStyle: TextStyle(color: Colors.black),
        items: groupInterests.map((e) {
          return MultiSelectItem(e, e);
        }).toList());
  }
}
