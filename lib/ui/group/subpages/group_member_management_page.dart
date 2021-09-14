import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMemberManagementPage extends StatefulWidget {
  @override
  _GroupMemberManagementPageState createState() =>
      _GroupMemberManagementPageState();
}

class _GroupMemberManagementPageState
    extends BaseState<GroupMemberManagementPage> {
  GroupProvider groupProvider;
  @override
  void initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    groupProvider.getGroupMembers(groupProvider.group);
  }

  @override
  Widget build(BuildContext context) {
    GroupProvider provider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Üye Yönetimi"),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshGroup(),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(kBackgroundImage),
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
