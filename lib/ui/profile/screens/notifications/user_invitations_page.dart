import 'package:cloud_functions/cloud_functions.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInvitationsPage extends StatefulWidget {
  @override
  State<UserInvitationsPage> createState() => _UserInvitationsPageState();
}

class _UserInvitationsPageState extends BaseState<UserInvitationsPage> {
  List<GroupInvitationModel> groupInvitationModels = [];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<InvitationProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendNotification(authProvider.currentUser.uid);
        },
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        actions: [],
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
            buildGroupInvitations(provider, groupInvitationModels),
          ],
        ),
      ),
    );
  }

  buildGroupInvitations(InvitationProvider provider,
      List<GroupInvitationModel> groupInvitationModels) {
    List<InvitationModel> groupInvitations = [];

    groupInvitations = provider.usersInvitations.map((e) {
      if (e.type == "InvitationType.GroupMembership") {
        return e;
      }
    }).toList();

    if (groupInvitations.isNotEmpty) {
      getGroups(groupInvitations);

      if (groupInvitationModels != null && groupInvitationModels.length > 0) {
        return Container(
          height: 400,
          child: ListView.builder(
              itemCount: groupInvitationModels.length,
              itemBuilder: (context, index) {
                String groupId = groupInvitationModels[index].groupId;
                String groupProfilePicture =
                    groupInvitationModels[index].groupProfilePicture;
                String groupName = groupInvitationModels[index].groupName;
                // String groupCategory =
                //     groupInvitationModels[index].groupCategory;
                String invitationId = groupInvitationModels[index].invitationId;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(groupProfilePicture),
                    ),
                    title: Text(groupName, style: TextStyle(fontSize: 20)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              acceptGroupInvitation(
                                  provider.usersInvitations.first.receiverId,
                                  groupId,
                                  invitationId);
                            },
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

    List<GroupInvitationModel> models = [];

    groupInvitations.forEach((invitation) async {
      var group = await groupProvider.getGroupDetail(invitation.senderId);
      // tempGroups.add(group);
      models.add(GroupInvitationModel(
        groupCategory: group.groupCategory,
        groupId: group.groupId,
        groupName: group.groupName,
        groupProfilePicture: group.groupProfilePicture,
        invitationId: invitation.invitationId,
      ));
    });
    setState(() {
      groupInvitationModels = models;
    });
  }

  acceptGroupInvitation(
      String userId, String groupId, String invitationId) async {
    await Provider.of<InvitationProvider>(context, listen: false)
        .acceptGroupInvitation(userId, groupId, invitationId);
  }

  rejectGroupInvitation() {}

  sendNotification(String userId) async {
    debugPrint(userId);
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    // firebaseFunctions.useFunctionsEmulator("localhost", 5001);
    var callable = firebaseFunctions.httpsCallable('sendNotificationToUser');
    try {
      final HttpsCallableResult result =
          await callable.call(<String, dynamic>{'userId': userId});
      print(result.data);
    } on FirebaseFunctionsException catch (e) {
      print('Firebase Functions Exception');
      print(e.code);
      print(e.message);
    } catch (e) {
      print('Caught Exception');
      print(e);
    }
  }
}

class GroupInvitationModel {
  String groupId;
  String invitationId;
  String groupProfilePicture;
  String groupName;
  String groupCategory;

  GroupInvitationModel(
      {this.groupId,
      this.invitationId,
      this.groupProfilePicture,
      this.groupName,
      this.groupCategory});
}
