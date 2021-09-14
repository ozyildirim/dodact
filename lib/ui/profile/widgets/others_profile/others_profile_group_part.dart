import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class OthersProfileGroupsTab extends StatefulWidget {
  @override
  _OthersProfileGroupsTabState createState() => _OthersProfileGroupsTabState();
}

class _OthersProfileGroupsTabState extends State<OthersProfileGroupsTab> {
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    Provider.of<GroupProvider>(context, listen: false)
        .getUserGroups(userProvider.otherUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);

    provider.getUserGroups(userProvider.otherUser.uid);

    Logger().i("UserGroups: " + provider.userGroupList.toString());
    if (provider.userGroupList != null) {
      if (provider.userGroupList.isEmpty) {
        return Center(
          child: Text(
            "Herhangi bir gruba dahil değil.",
            style: TextStyle(fontSize: 22),
          ),
        );
      } else {
        return ListView.builder(
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
            itemCount: provider.userGroupList.length,
            itemBuilder: (context, index) {
              var groupItem = provider.userGroupList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white70,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Image.network(groupItem.groupProfilePicture),
                      backgroundColor: Colors.transparent,
                      maxRadius: 80,
                    ),
                    title: Text(
                      groupItem.groupName,
                      style: TextStyle(fontSize: 22),
                    ),
                    subtitle: Text(
                      groupItem.groupDescription,
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      NavigationService.instance
                          .navigate(k_ROUTE_GROUP_DETAIL, args: groupItem);
                    },
                  ),
                ),
              );
            });
      }
    } else {
      return Center(child: spinkit);
    }
  }
}
