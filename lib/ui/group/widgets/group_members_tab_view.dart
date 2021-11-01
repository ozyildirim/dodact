import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMembersTab extends StatelessWidget {
  final GroupModel group;

  GroupMembersTab({this.group});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    // return Container(
    //   child: provider.groupMembers != null
    //       ? provider.groupMembers.isNotEmpty
    //           ? GridView.builder(
    //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                   crossAxisCount: 3, childAspectRatio: 0.5),
    //               itemCount: provider.groupMembers.length,
    //               itemBuilder: (context, index) {
    //                 var user = provider.groupMembers[index];
    //                 return InkWell(
    //                   onTap: () => navigateUserProfile(user),
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(12.0),
    //                     child: Column(
    //                       children: [
    //                         CachedNetworkImage(
    //                           imageUrl: user.profilePictureURL,
    //                           imageBuilder: (context, imageProvider) {
    //                             return CircleAvatar(
    //                               radius: 60,
    //                               backgroundImage:
    //                                   NetworkImage(user.profilePictureURL),
    //                             );
    //                           },
    //                         ),
    //                         Text(user.nameSurname,
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                                 fontSize: 15, fontWeight: FontWeight.bold))
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               })
    //           : Container(
    //               child: Text("Boş"),
    //             )
    //       : Center(
    //           child: spinkit,
    //         ),
    // );

    return FutureBuilder(
        future: provider.getGroupMembers(group),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 0.5),
                    itemCount: provider.groupMembers.length,
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
                                    radius: 60,
                                    backgroundImage:
                                        NetworkImage(user.profilePictureURL),
                                  );
                                },
                              ),
                              Text(user.nameSurname,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Container(
                    color: Colors.white60,
                    child: Text("Boş.",
                        style: TextStyle(fontSize: kPageCenteredTextSize)),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  "Bir hata oluştu.",
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
    NavigationService.instance
        .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: user);
  }
}
