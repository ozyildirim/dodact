import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMembersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    return Container(
      child: provider.groupMembers != null
          ? provider.groupMembers.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var user = provider.groupMembers[index];
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
                                  radius: 80,
                                  backgroundImage:
                                      NetworkImage(user.profilePictureURL),
                                );
                              },
                            ),
                            Text("@" + user.username,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: provider.groupMembers.length,
                )
              : Container(
                  child: Text("Boş"),
                )
          : Center(
              child: spinkit,
            ),
    );
  }

  navigateUserProfile(UserObject user) {
    NavigationService.instance
        .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: user);
  }
}
