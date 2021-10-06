import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserGroupInvitationsPart extends StatelessWidget {
  List<InvitationModel> invitations;

  UserGroupInvitationsPart(this.invitations);

  List<InvitationModel> groupInvitations;

  List<InvitationModel> checkGroupInvitations() {
    groupInvitations = invitations.map((e) {
      if (e.type == "InvitationType.GroupMembership") {
        return e;
      }
    }).toList();

    return groupInvitations;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<InvitationProvider>(context);

    groupInvitations = checkGroupInvitations();

    return Container(
      height: size.height * 0.8,
      width: size.width,
      child: FutureBuilder(
          future: getGroups(context, groupInvitations),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Container(
                  child: Center(
                    child: Text("Davet Yok",
                        style: TextStyle(fontSize: kPageCenteredTextSize)),
                  ),
                );
              } else {
                List<GroupInvitationModel> list = snapshot.data;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var invitationModel = list[index];
                      String groupId = invitationModel.groupId;
                      String groupProfilePicture =
                          invitationModel.groupProfilePicture;
                      String groupName = invitationModel.groupName;
                      String invitationId = invitationModel.invitationId;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(groupProfilePicture),
                          ),
                          title:
                              Text(groupName, style: TextStyle(fontSize: 20)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    acceptGroupInvitation(
                                        provider
                                            .usersInvitations.first.receiverId,
                                        groupId,
                                        invitationId,
                                        context);
                                  },
                                  icon: Icon(Icons.check),
                                  color: Colors.green),
                              IconButton(
                                  onPressed: () {
                                    rejectGroupInvitation(
                                        invitationId, context);
                                  },
                                  icon: Icon(Icons.close),
                                  color: Colors.red),
                            ],
                          ),
                        ),
                      );
                    });
              }
            } else {
              return Center(
                child: spinkit,
              );
            }
          }),
    );
  }

  Future getGroups(
      BuildContext context, List<InvitationModel> invitationList) async {
    var groupProvider = Provider.of<GroupProvider>(context, listen: false);

    List<GroupInvitationModel> models = [];

    for (var invitation in invitationList) {
      var group = await groupProvider.getGroupDetail(invitation.senderId);
      print(group);
      var groupModel = GroupInvitationModel(
        groupCategory: group.groupCategory,
        groupId: group.groupId,
        groupName: group.groupName,
        groupProfilePicture: group.groupProfilePicture,
        invitationId: invitation.invitationId,
      );
      models.add(groupModel);
    }
    return models;
  }

  acceptGroupInvitation(String userId, String groupId, String invitationId,
      BuildContext context) async {
    print(invitationId);
    CommonMethods().showLoaderDialog(context, "İşlemini gerçekleştiriyoruz");
    var result = await Provider.of<InvitationProvider>(context, listen: false)
        .acceptGroupInvitation(userId, groupId, invitationId);
    print(result);
    NavigationService.instance.pop();
  }

  rejectGroupInvitation(String invitationId, BuildContext context) async {
    CommonMethods().showLoaderDialog(context, "İşlemini gerçekleştiriyoruz");
    try {
      await Provider.of<InvitationProvider>(context, listen: false)
          .rejectGroupInvitation(invitationId);
    } catch (e) {
      print(e);
    }

    NavigationService.instance.pop();
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
