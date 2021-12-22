import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class UserProfileInterestsTab extends StatefulWidget {
  @override
  State<UserProfileInterestsTab> createState() =>
      _UserProfileInterestsTabState();
}

class _UserProfileInterestsTabState extends BaseState<UserProfileInterestsTab> {
  @override
  Widget build(BuildContext context) {
    if (userProvider.currentUser.selectedInterests == null ||
        userProvider.currentUser.selectedInterests.isEmpty) {
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
    userProvider.currentUser.selectedInterests.forEach((e) {
      if (categoryList.contains(e)) {
        return userInterests.add(e);
      } else {
        return null;
      }
    });

    return MultiSelectChipDisplay(
        chipColor: Colors.grey[200],
        textStyle: TextStyle(color: Colors.black),
        items: userInterests.map((e) {
          return MultiSelectItem(e, e);
        }).toList());
  }
}
