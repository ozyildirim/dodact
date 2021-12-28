import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/app_constants.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/chatroom_model.dart';
import 'package:dodact_v1/model/message_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/chatroom_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class UserChatroomsPage extends StatefulWidget {
  @override
  State<UserChatroomsPage> createState() => _UserChatroomsPageState();
}

class _UserChatroomsPageState extends BaseState<UserChatroomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Mesajlar'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              NavigationService.instance.navigate(k_ROUTE_CREATE_CHAT_PAGE);
            },
          )
        ],
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
        child: buildChatRooms(context),
      ),
    );
  }

  buildChatRooms(BuildContext context) {
    var provider = Provider.of<ChatroomProvider>(context, listen: false);

    return PaginateFirestore(
      isLive: true,
      itemsPerPage: 10,
      bottomLoader: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
      itemBuilder: (context, object, index) {
        ChatroomModel model = ChatroomModel.fromJson(object[index].data());
        return FutureBuilder(
            future: getOtherUserProfile(model),
            builder: (context, object) {
              if (object.connectionState == ConnectionState.waiting) {
                // return Center(child: spinkit);
                return Container();
              } else if (object.connectionState == ConnectionState.done) {
                if (object.hasData) {
                  UserObject otherUser = object.data;
                  return buildListTile(model, otherUser);
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            });
      },
      query: chatroomsRef
          .where("users", arrayContains: authProvider.currentUser.uid)
          .orderBy('lastMessage.messageCreationDate', descending: true),
      itemBuilderType: PaginateBuilderType.listView,
      initialLoader: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
      onEmpty: Center(
        child: Text(
          'Mevcut bir sohbet bulunmuyor.',
          style: TextStyle(fontSize: kPageCenteredTextSize),
        ),
      ),
    );
  }

  getOtherUserProfile(ChatroomModel chatroom) async {
    var otherUserId = chatroom.users
        .firstWhere((element) => element != authProvider.currentUser.uid);

    var user = await Provider.of<UserProvider>(context, listen: false)
        .getUserByID(otherUserId)
        .then((value) => value)
        .catchError((error) {
      return UserObject(
          nameSurname: "Dodact Kullanıcısı",
          uid: otherUserId,
          profilePictureURL: AppConstant.kDefaultUserProfilePicture);
    });

    return user ?? null;
  }

  buildListTile(ChatroomModel chatroom, UserObject user) {
    if (chatroom.lastMessage == null) {
    } else {
      var lastMessage = MessageModel.fromJson(chatroom.lastMessage);

      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListTile(
          onTap: () {
            updateMessageRead(chatroom);
            NavigationService.instance.navigate(k_ROUTE_CHATROOM_PAGE,
                args: [userProvider.currentUser.uid, user]);
          },
          leading: Hero(
              tag: user.uid,
              // child: CircleAvatar(
              //   backgroundColor: kNavbarColor,
              //   radius: 50,
              //   child: CircleAvatar(
              //     radius: 30,
              //     backgroundImage:
              //         CachedNetworkImageProvider(user.profilePictureURL),
              //   ),
              // ),

              child: GFAvatar(
                backgroundColor: kNavbarColor,
                radius: 50,
                child: GFAvatar(
                  radius: 25,
                  backgroundImage:
                      CachedNetworkImageProvider(user.profilePictureURL),
                ),
              )),
          title: Text(
            user.nameSurname,
            style: TextStyle(
                fontSize: 20,
                fontWeight: lastMessage.senderId == authProvider.currentUser.uid
                    ? FontWeight.w400
                    : lastMessage.isRead
                        ? FontWeight.w400
                        : FontWeight.w700),
          ),
          subtitle: Text(lastMessage.message,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight:
                      lastMessage.senderId == authProvider.currentUser.uid
                          ? FontWeight.w400
                          : lastMessage.isRead
                              ? FontWeight.w400
                              : FontWeight.w700)),
          trailing: Text(
            DateFormat('dd/MM HH:mm', 'tr_TR')
                .format(lastMessage.messageCreationDate),
            style: TextStyle(
                fontSize: 12,
                fontWeight: lastMessage.senderId == authProvider.currentUser.uid
                    ? FontWeight.w400
                    : lastMessage.isRead
                        ? FontWeight.w400
                        : FontWeight.w700),
          ),
        ),
      );
    }
  }

  void updateMessageRead(ChatroomModel chatroom) {
    if (chatroom.lastMessage['senderId'] != userProvider.currentUser.uid) {
      if (chatroom.lastMessage['isRead'] == false) {
        chatroomsRef.doc(chatroom.roomId).update({
          'lastMessage': {
            'isRead': true,
            'message': chatroom.lastMessage['message'],
            'messageCreationDate': chatroom.lastMessage['messageCreationDate'],
            'senderId': chatroom.lastMessage['senderId'],
            'messageId': chatroom.lastMessage['messageId']
          },
        });
      }
    }
  }
}
