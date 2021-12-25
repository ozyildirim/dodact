import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
        onSelected: (value) async {
          if (value == 0) {
            NavigationService.instance.navigate(k_ROUTE_GROUP_INVITATIONS_PAGE);
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.question_answer, size: 16, color: Colors.black),
                    SizedBox(width: 14),
                    Text("Gönderilen Davetler", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: actions,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Üye Yönetimi"),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: buildMemberList()),
    );
  }

  Widget buildMemberList() {
    return FutureBuilder(
        future: groupProvider.getGroupMembers(groupProvider.group.groupId),
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
                                          child: Icon(Icons.add,
                                              color: Colors.black)),
                                      Text("Üye Ekle",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }
                      var user = members[index - 1];
                      return InkWell(
                        onLongPress: () {
                          if (userProvider.currentUser.uid != user.uid) {
                            showMemberOptions(user.uid);
                          }
                        },
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
                                  overflow: TextOverflow.ellipsis,
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
                  child: Text(
                    "Boş.",
                    style: TextStyle(fontSize: kPageCenteredTextSize),
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

  Future<void> deleteMember(String userID) async {
    try {
      await groupProvider.removeGroupMember(
          userID, groupProvider.group.groupId);
      NavigationService.instance.pop();
      setState(() {});
      CustomMethods.showSnackbar(
          context, "Üye başarıyla topluluktan çıkarıldı.");
    } catch (e) {
      CustomMethods.showSnackbar(context, "Bir hata oluştu.");
    }
  }

  Future setGroupManager(String userId, String groupId) async {
    await groupProvider.setGroupManager(userId, groupId);
  }

  void showMemberOptions(String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Üye Seçenekleri", textAlign: TextAlign.center),
            children: [
              userId != userProvider.currentUser.uid
                  ? SimpleDialogOption(
                      child: Text("Üyeyi Topluluktan Çıkar"),
                      onPressed: () {
                        NavigationService.instance.pop();
                        removeMemberDialog(userId);
                      },
                    )
                  : Container(),
              groupProvider.group.managerId != userId
                  ? SimpleDialogOption(
                      child: Text("Yönetici Yap"),
                      onPressed: () {
                        NavigationService.instance.pop();
                        setManagerDialog(userId);
                      },
                    )
                  : Container()
            ],
          );
        });
  }

  removeMemberDialog(String userId) {
    CustomMethods.showCustomDialog(
      context: context,
      confirmButtonText: "Evet",
      confirmActions: () {
        deleteMember(userId);
        setState(() {});
        NavigationService.instance.pop();
      },
      title: "Üyeyi topluluğundan çıkarmak istediğine emin misin?",
    );
  }

  setManagerDialog(String userId) {
    CustomMethods.showCustomDialog(
      context: context,
      confirmButtonText: "Evet",
      confirmActions: () async {
        try {
          await setGroupManager(userId, groupProvider.group.groupId);
          NavigationService.instance.popUntil(k_ROUTE_GROUP_DETAIL);
          CustomMethods.showSnackbar(
              context, "Topluluk yöneticisi başarıyla değiştirildi.");
        } catch (e) {
          CustomMethods.showSnackbar(context, "Bir hata oluştu.");
          NavigationService.instance.pop();
        }
      },
      title: "Bu kullanıcıyı yönetici yapmak istediğine emin misin?",
    );
  }
}
