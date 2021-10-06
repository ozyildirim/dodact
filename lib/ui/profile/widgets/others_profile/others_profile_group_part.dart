import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
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

    // provider.getUserGroups(userProvider.otherUser.uid);

    if (provider.userGroupList != null) {
      if (provider.userGroupList.isEmpty) {
        return Center(
          child: Text(
            "Herhangi bir gruba dahil değil.",
            style: TextStyle(fontSize: kPageCenteredTextSize),
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
                child:
                    Container(child: buildCustomListTile(context, groupItem)),
              );
            });
      }
    } else {
      return Center(child: spinkit);
    }
  }

  buildCustomListTile(BuildContext context, GroupModel group) {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigate(k_ROUTE_GROUP_DETAIL, args: group);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: group.groupProfilePicture,
            placeholder: (context, url) => Center(
              child: spinkit,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageBuilder) {
              return CircleAvatar(
                radius: 50,
                backgroundImage: imageBuilder,
              );
            },
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(group.groupName, style: TextStyle(fontSize: 24)),
                  SizedBox(height: 5),
                  Text(group.groupSubtitle, style: TextStyle(fontSize: 16))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
