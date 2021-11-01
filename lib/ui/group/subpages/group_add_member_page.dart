import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/group/subpages/group_member_management_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GroupAddMemberPage extends StatefulWidget {
  List<UserObject> userList;

  GroupAddMemberPage({this.userList});

  @override
  _GroupAddMemberPageState createState() => _GroupAddMemberPageState();
}

class _GroupAddMemberPageState extends State<GroupAddMemberPage> {
  GroupProvider groupProvider;
  InvitationProvider invitationProvider;
  List<UserObject> memberList;
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    invitationProvider =
        Provider.of<InvitationProvider>(context, listen: false);
    memberList = widget.userList;
  }

  bool checkIfInvitationSent(String userId) {
    if (invitationProvider.sentGroupInvitations != null &&
        invitationProvider.sentGroupInvitations.length > 0) {
      var result = invitationProvider.sentGroupInvitations
          .where((element) => element.receiverId == userId);

      if (result.isEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  // bool checkGroupMember(String userId) {
  //   if (groupProvider.groupMembers != null &&
  //       groupProvider.groupMembers.length > 0) {
  //     // var result = groupProvider.group.groupMemberList
  //     //     .where((element) => element == userId);
  //     return groupProvider.group.groupMemberList.contains(userId);
  //   }
  // }

  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Ara'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Consumer<InvitationProvider>(
            builder: (context, invitationProvider, child) {
          if (invitationProvider.sentGroupInvitations != null) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: AssetImage(kBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFieldContainer(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Ara',
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.search)),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                      ),
                    ),
                    buildStreamer(context, username),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: spinkit);
          }
        }),
      ),
    );
  }

  buildStreamer(BuildContext context, String input) {
    Logger().d(groupProvider.group.groupMemberList);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8 - kToolbarHeight,
      child: StreamBuilder<QuerySnapshot>(
        stream: (input != "" && input != null)
            ? usersRef
                .where('searchKeywords', arrayContains: input)
                .where('newUser', isEqualTo: false)
                .snapshots()
            : usersRef.limit(5).snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: spinkit)
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    UserObject user = UserObject.fromDoc(data);

                    // if (checkGroupMember(user.uid)) {
                    //   return Container();
                    // } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePictureURL),
                          radius: 40,
                        ),
                        title: Text(
                          user.username,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(user.email),
                        trailing: user.uid != groupProvider.group.founderId
                            ? checkIfInvitationSent(user.uid) == false
                                ? IconButton(
                                    icon: Icon(Icons.person_add),
                                    onPressed: () async {
                                      await sendGroupInvitation(user.uid,
                                          groupProvider.group.groupId);
                                    },
                                  )
                                : null
                            : null,
                      ),
                    );
                  }
                  // },
                  );
        },
      ),
    );
  }

  void showSnackBar(String message, {int duration = 2}) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        duration: new Duration(seconds: duration),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new CircularProgressIndicator(),
            Expanded(
              child: new Text(
                message,
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  sendGroupInvitation(String userId, String groupId) async {
    try {
      await invitationProvider.inviteUserToGroup(
          userId, groupId, InvitationType.GroupMembership.toString());
      showSnackBar('Kullanıcıya davet gönderildi.');
    } catch (e) {
      showSnackBar('Bir hata oluştu.');
    }
  }
}
