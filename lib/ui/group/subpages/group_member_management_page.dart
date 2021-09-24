import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
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
    groupProvider.getGroupMembers(groupProvider.group);
    invitationProvider =
        Provider.of<InvitationProvider>(context, listen: false);
    fetchGroupInvitations();
    invitationProvider.getInvitations();
  }

  fetchGroupInvitations() async {
    await invitationProvider
        .getSentGroupInvitations(groupProvider.group.groupId)
        .then((value) {
      Logger().e(value);
      value.forEach((element) {
        debugPrint("kişi ID: ${element.receiverId}");
      });
    });
  }

  var actions = [
    PopupMenuButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Üye Ekle"),
                    onTap: () async {
                      NavigationService.instance
                          .navigate(k_ROUTE_GROUP_ADD_MEMBER_PAGE);
                    }),
              ),
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
    GroupProvider provider = Provider.of<GroupProvider>(context);
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
    if (groupProvider.groupMembers != null) {
      return ListView.builder(
        itemCount: groupProvider.groupMembers.length,
        itemBuilder: (context, index) {
          var user = groupProvider.groupMembers[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white60,
              child: ListTile(
                leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      user.profilePictureURL,
                    )),
                title: Text(
                  user.nameSurname != null ? user.nameSurname : user.username,
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(user.email),
                trailing: user.uid != groupProvider.group.founderId
                    ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await deleteMember(user.uid);
                        },
                      )
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      return Center(child: spinkit);
    }
  }

//TODO: Sayfa içerisinde güncellemiyor.
  Future<void> deleteMember(String userID) async {
    await groupProvider.removeGroupMember(userID, groupProvider.group.groupId);
    setState(() {});
  }

  refreshGroup() async {
    await groupProvider.getGroupDetail(groupProvider.group.groupId);
  }
}
