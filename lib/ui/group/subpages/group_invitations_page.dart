import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GroupMemberInvitationsPage extends StatefulWidget {
  @override
  _GroupMemberSentInvitationsPageState createState() =>
      _GroupMemberSentInvitationsPageState();
}

class _GroupMemberSentInvitationsPageState
    extends State<GroupMemberInvitationsPage> {
  InvitationProvider invitationProvider;
  GroupProvider groupProvider;
  UserProvider userProvider;

  List<UserObject> userList = [];

  @override
  void initState() {
    super.initState();
    invitationProvider =
        Provider.of<InvitationProvider>(context, listen: false);
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getInvitedUsers(invitationProvider.sentGroupInvitations);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<InvitationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Davetler'),
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
        child: invitationProvider.sentGroupInvitations.length > 0
            ? userList != null && userList.length > 0
                ? ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      var user = userList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(user.profilePictureURL),
                          ),
                          title: Text(user.username,
                              style: TextStyle(fontSize: 20)),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              rollbackGroupInvitation(user.uid);
                            },
                          ),
                        ),
                      );
                    })
                : userList.isEmpty
                    ? Center(child: Text('Davet yok'))
                    : Center(child: spinkit)
            : Center(
                child: Text('Davet yok'),
              ),
      ),
    );
  }

  // buildBody() {
  //   if (userList != null && userList.length > 0) {
  //   } else if (userList.isEmpty) {
  //     return Center(child: Text('Davet yok'));
  //   } else {
  //     return Center(child: spinkit);
  //   }
  // }

  Future<List<UserObject>> getInvitedUsers(List<InvitationModel> list) async {
    list.forEach((element) async {
      DocumentSnapshot doc = await usersRef.doc(element.receiverId).get();
      UserObject user = UserObject.fromDoc(doc);
      Logger().d(user.toString());
      setState(() {
        userList.add(user);
      });
    });
  }

  void rollbackGroupInvitation(String uid) async {
    await invitationProvider.rollbackGroupMembershipInvitation(
        uid, groupProvider.group.groupId);
    setState(() {});

    // invitationProvider.sentGroupInvitations.forEach((element) {
    //   print(element.toString());
    // });
  }
}
