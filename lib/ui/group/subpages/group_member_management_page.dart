import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GroupMemberAddPage();
              }));
            },
          ),
        ],
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

class GroupMemberAddPage extends StatefulWidget {
  @override
  _GroupMemberAddPageState createState() => _GroupMemberAddPageState();
}

class _GroupMemberAddPageState extends State<GroupMemberAddPage> {
  GroupProvider groupProvider;
  List<String> memberList;

  initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    memberList = groupProvider.group.groupMemberList;
  }

  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ara'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
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
        ),
      ),
    );
  }

  buildStreamer(BuildContext context, String input) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: StreamBuilder<QuerySnapshot>(
        stream: (input != "" && input != null)
            ? usersRef
                .where('username', isEqualTo: input)
                // .where('isAdmin', isEqualTo: false)
                .snapshots()
            : usersRef.limit(1).snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: spinkit)
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    UserObject user = UserObject.fromDoc(data);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white70,
                        child: ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(user.profilePictureURL),
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
                              ? IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: () async {
                                    await sendGroupInvitation(user.uid);
                                  },
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  sendGroupInvitation(String uid) {}
}
