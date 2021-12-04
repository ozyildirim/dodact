import 'dart:ui';

import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';

class GroupInterestsTabView extends StatelessWidget {
  final GroupModel group;

  GroupInterestsTabView({this.group});
  @override
  Widget build(BuildContext context) {
    if (group.interests != null) {
      if (group.interests.isNotEmpty) {
        return Container(
          child: ListView(
            children: buildInterestElements(),
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

  // buildInterstCard() {
  //   return Card(
  //     child: Container(
  //       decoration: BoxDecoration(
  //           image: DecorationImage(
  //               image: AssetImage('assets/images/app/interests/tiyatro.jpeg'),
  //               fit: BoxFit.cover)),
  //       child: ExpansionTile(
  //         title: Text('Birth of Universe'),
  //         children: <Widget>[
  //           Text('Big Bang'),
  //           Text('Birth of the Sun'),
  //           Text('Earth is Born'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  buildInterestElements() {
    var groupInterests = group.interests;
    // var coverPhoto = group.coverPhoto;

    var elements = groupInterests.map((interest) {
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
          collapsedTextColor: Colors.white,
          title: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Text(title, style: TextStyle(fontSize: 20))),
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
