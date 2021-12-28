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

    List<MultiSelectItem> items = userInterests.take(10).map((e) {
      return MultiSelectItem(e, e);
    }).toList();

    if (userInterests.length > 10) {
      items.add(MultiSelectItem<String>("+${userInterests.length - 10}",
          "+${userInterests.length - 10} Kategori"));
    }

    return MultiSelectChipDisplay(
        onTap: (value) {
          openCategoriesDialog(userInterests);
        },
        chipColor: Colors.grey[200],
        textStyle: TextStyle(color: Colors.black),
        items: items);
  }

  openCategoriesDialog(List items) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: MultiSelectChipDisplay(
                        chipColor: Colors.grey[200],
                        textStyle: TextStyle(color: Colors.black),
                        items: items
                            .map((e) => MultiSelectItem<String>(e, e))
                            .toList()),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
