import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupInfoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    return Container(
      child: provider.group != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  provider.group.groupDescription,
                  style: TextStyle(fontSize: 22),
                ),
              ),
            )
          : Center(
              child: spinkit,
            ),
    );
  }
}
