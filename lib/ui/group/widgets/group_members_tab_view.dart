import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMembersTab extends StatefulWidget {
  final GroupModel group;

  GroupMembersTab({this.group});

  @override
  State<GroupMembersTab> createState() => _GroupMembersTabState();
}

class _GroupMembersTabState extends BaseState<GroupMembersTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context, listen: false);

    return FutureBuilder(
        future: provider.getGroupMembers(widget.group.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                List<UserObject> members = snapshot.data;
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 0.5),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      var user = members[index];
                      return InkWell(
                        onTap: () => navigateUserProfile(user),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: user.profilePictureURL,
                                imageBuilder: (context, imageProvider) {
                                  return CircleAvatar(
                                    radius: 43,
                                    backgroundColor: kNavbarColor,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          NetworkImage(user.profilePictureURL),
                                    ),
                                  );
                                },
                              ),
                              Text(user.nameSurname,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Text("Boş",
                      style: TextStyle(fontSize: kPageCenteredTextSize)),
                );
              }
            } else {
              return Center(
                child: Text(
                  "Bir hata oluştu",
                  style: TextStyle(fontSize: kPageCenteredTextSize),
                ),
              );
            }
          } else {
            return Center(
              child: spinkit,
            );
          }
        });
  }

  navigateUserProfile(UserObject user) {
    if (user.uid != userProvider.currentUser.uid)
      NavigationService.instance
          .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: user);
  }
}
