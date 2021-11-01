import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

enum InvitationType { GroupMembership }

class GroupMemberManagementPage extends StatefulWidget {
  @override
  _GroupMemberManagementPageState createState() =>
      _GroupMemberManagementPageState();
}

class _GroupMemberManagementPageState
    extends BaseState<GroupMemberManagementPage> {
  GroupProvider groupProvider;
  InvitationProvider invitationProvider;
  @override
  void initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);

    invitationProvider =
        Provider.of<InvitationProvider>(context, listen: false);
    fetchGroupInvitations();
  }

  fetchGroupInvitations() async {
    await invitationProvider
        .getSentGroupInvitations(groupProvider.group.groupId);
  }

  var actions = [
    PopupMenuButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text("Gönderilen Davetler"),
                  onTap: () async {
                    NavigationService.instance
                        .navigate(k_ROUTE_GROUP_INVITATIONS_PAGE);
                  },
                ),
              ),
            ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: actions,
        title: Text("Üye Yönetimi"),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshGroup(),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: AssetImage(kBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: buildMemberList()),
      ),
    );
  }

  Widget buildMemberList() {
    return FutureBuilder(
        future: groupProvider.getGroupMembers(groupProvider.group),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                List<UserObject> members = snapshot.data;

                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: members.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return InkWell(
                          onTap: () {
                            NavigationService.instance
                                .navigate(k_ROUTE_GROUP_ADD_MEMBER_PAGE);
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 55,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.add),
                                      ),
                                      Text("Üye Ekle"),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }
                      var user = members[index - 1];
                      return InkWell(
                        onTap: () => navigateUserProfile(user),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
    if (userProvider.currentUser.uid != user.uid) {
      NavigationService.instance
          .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: user);
    }
  }

//TODO: Sayfa içerisinde güncellemiyor.
  Future<void> deleteMember(String userID) async {
    await groupProvider.removeGroupMember(userID, groupProvider.group.groupId);
  }

  refreshGroup() async {
    await groupProvider.getGroupDetail(groupProvider.group.groupId);
  }
}
