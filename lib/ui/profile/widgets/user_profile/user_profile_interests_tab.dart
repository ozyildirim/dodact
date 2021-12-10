import 'dart:ui';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';

class UserProfileInterestsTab extends StatefulWidget {
  @override
  State<UserProfileInterestsTab> createState() =>
      _UserProfileInterestsTabState();
}

class _UserProfileInterestsTabState extends BaseState<UserProfileInterestsTab> {
  @override
  Widget build(BuildContext context) {
    if (userProvider.currentUser.interests == null ||
        userProvider.currentUser.interests.isEmpty) {
      return Container(
          child: Center(
        child: Text(
          "İlgi alanları belirtilmemiş",
          style: TextStyle(fontSize: kPageCenteredTextSize),
        ),
      ));
    } else {
      return Container(
        child: ListView(
          children: buildInterestElements(),
        ),
      );
    }
  }

  buildInterestElements() {
    var userInterests = userProvider.currentUser.interests;
    // var coverPhoto = group.coverPhoto;

    var elements = userInterests.map((interest) {
      if (interest['selectedSubcategories'].isEmpty) return Container();

      var coverPhoto = interestCategoryList
          .where((element) => element.name == interest["title"])
          .toList()[0]
          .coverPhotoUrl;

      return buildCard(coverPhoto, interest["title"],
          interest["selectedSubcategories"].cast<String>());
    }).toList();

    return elements;
  }

  Card buildCard(String coverPhoto, String title, List<String> elements) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(coverPhoto), fit: BoxFit.cover)),
        child: ExpansionTile(
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          collapsedTextColor: Colors.white,
          title: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Text(
              title,
              softWrap: true,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // children: elements
          //     .map((e) => Card(
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20)),
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text(
          //               e,
          //               style: TextStyle(fontSize: 18, color: Colors.black),
          //               textAlign: TextAlign.left,
          //             ),
          //           ),
          //         ))
          //     .toList(),

          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: elements
                      .map((e) => Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, bottom: 4.0),
                            child: Chip(
                              backgroundColor: Colors.white,
                              label: Text(e),
                            ),
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
