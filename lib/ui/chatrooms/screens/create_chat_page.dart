import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateChatPage extends StatefulWidget {
  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Sohbet Oluştur'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFieldContainer(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.only(
                            left: 16, bottom: 4, top: 4, right: 4),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Kullanıcı Adı',
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search)),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                buildStreamer(context, name)
              ],
            ),
          ),
        ));
  }

  buildStreamer(BuildContext context, String input) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: (input != "" && input != null)
              ? FirebaseFirestore.instance
                  .collection('users')
                  .where("searchKeywords", arrayContains: input)
                  .where('newUser', isEqualTo: false)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection("users")
                  .where('newUser', isEqualTo: false)
                  .limit(10)
                  .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: spinkit)
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      UserObject user = UserObject.fromDoc(data);

                      if (user.profilePictureURL != null) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              createChatroom(context, user.uid);
                            },
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
                            subtitle: user.privacySettings['hide_profession']
                                ? Container()
                                : Text(user.profession),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
          },
        ),
      ),
    );
  }

  createChatroom(BuildContext context, String userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var otherUser = await userProvider.getUserByID(userId);

    NavigationService.instance.navigate(k_ROUTE_CHATROOM_PAGE,
        args: [userProvider.currentUser.uid, otherUser]);
  }
}
