import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RandomGroups extends StatefulWidget {
  @override
  _RandomGroupsState createState() => _RandomGroupsState();
}

class _RandomGroupsState extends State<RandomGroups> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupProvider>(
      builder: (_, provider, child) {
        if (provider.groupList != null) {
          if (provider.groupList.isNotEmpty) {
            List<GroupModel> groups = provider.groupList;
            print(provider.groupList.length);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(),
            );
          } else {
            return Center(
              child: spinkit,
            );
          }
        } else {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              color: Colors.purple,
              child: Center(
                  child: Text(
                "Henüz bir grup yok :(",
                style: TextStyle(fontSize: 25),
              )),
            ),
          ));
        }
      },
    );
  }
}
