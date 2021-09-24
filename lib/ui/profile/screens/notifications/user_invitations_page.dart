import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInvitationsPage extends StatefulWidget {
  @override
  State<UserInvitationsPage> createState() => _UserInvitationsPageState();
}

class _UserInvitationsPageState extends State<UserInvitationsPage> {
  List<GroupModel> groups;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<InvitationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Davetler'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            buildGroupInvitations(provider, groups),
          ],
        ),
      ),
    );
  }

  buildGroupInvitations(InvitationProvider provider, List<GroupModel> groups) {
    List<InvitationModel> groupInvitations = [];

    groupInvitations = provider.usersInvitations.map((e) {
      if (e.type == "InvitationType.GroupMembership") {
        return e;
      }
    }).toList();

    if (groupInvitations.isNotEmpty) {
      getGroups(groupInvitations);
      if (groups != null && groups.length > 0) {
        return Container(
          height: 400,
          child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                var group = groups[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(group.groupProfilePicture),
                    ),
                    title:
                        Text(group.groupName, style: TextStyle(fontSize: 20)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.check),
                            color: Colors.green),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.close),
                            color: Colors.red),
                      ],
                    ),
                  ),
                );
              }),
        );
      } else {
        return Container(height: 400, child: Center(child: spinkit));
      }
    } else {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            "Herhangi bir grup davetin bulunmuyor",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }

  getGroups(List<InvitationModel> groupInvitations) async {
    var groupProvider = Provider.of<GroupProvider>(context, listen: false);
    List<GroupModel> tempGroups = [];
    groupInvitations.forEach((invitation) async {
      var group = await groupProvider.getGroupDetail(invitation.senderId);
      print(group.founderId);
      tempGroups.add(group);
    });
    setState(() {
      groups = tempGroups;
    });
  }

  acceptGroupInvitation(
      String userId, String groupId, String invitationId) async {}

  rejectGroupInvitation() {}
}
