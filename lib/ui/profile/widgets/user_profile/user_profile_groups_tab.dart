import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/widgets/group_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileGroupsTab extends StatefulWidget {
  @override
  _UserProfileGroupsTabState createState() => _UserProfileGroupsTabState();
}

class _UserProfileGroupsTabState extends BaseState<UserProfileGroupsTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<GroupProvider>(context, listen: false);

    return FutureBuilder(
      future: provider.getUserGroups(userProvider.currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text(
                "Herhangi bir topluluğa dahil değil.",
                style: TextStyle(fontSize: kPageCenteredTextSize),
              ),
            );
          } else {
            List<GroupModel> groups = snapshot.data;

            return ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var groupItem = groups[index];
                  return Container(
                    child: GroupCard(group: groupItem),
                  );
                });
          }
        } else {
          return Center(child: spinkit);
        }
      },
    );
  }
}
