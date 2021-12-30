import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class GroupInterestsTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    if (provider.group.selectedInterests != null) {
      if (provider.group.selectedInterests.isNotEmpty) {
        return SingleChildScrollView(
          child: Container(
            child: buildInterestElements(provider.group),
          ),
        );
      } else {
        return Container(
          child: Center(
            child: Text(
              "Topluluk henüz İlgi alanı belirtmedi",
              style: TextStyle(
                fontSize: kPageCenteredTextSize,
              ),
            ),
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

  buildInterestElements(GroupModel group) {
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
