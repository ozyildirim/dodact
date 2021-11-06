import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/chatroom_model.dart';
import 'package:dodact_v1/model/message_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/chatroom_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
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
        title: Text('Sohbetler'),
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
    return FutureBuilder(
      future: provider.getUserChatrooms(authProvider.currentUser.uid),
      builder: (context, AsyncSnapshot<List<ChatroomModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var chatroom = snapshot.data[index];

              return ChatroomListElement(
                  chatroom, authProvider.currentUser.uid);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ChatroomListElement extends StatefulWidget {
  final ChatroomModel chatroom;
  final String currentUserId;

  ChatroomListElement(this.chatroom, this.currentUserId);

  @override
  State<ChatroomListElement> createState() => _ChatroomListElementState();
}

class _ChatroomListElementState extends BaseState<ChatroomListElement> {
  UserObject user;
  MessageModel lastMessage;
  String otherUserId;

  getUserProfile() async {
    otherUserId = widget.chatroom.users
        .firstWhere((element) => element != widget.currentUserId);

    user = await Provider.of<UserProvider>(context, listen: false)
        .getUserByID(otherUserId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
    getLastMessage();
  }

  getLastMessage() async {
    var message = await Provider.of<ChatroomProvider>(context, listen: false)
        .getLastMessage(widget.chatroom.roomId);

    if (message != null) {
      setState(() {
        lastMessage = message;
      });
    }
  }

  buildSubtitle(MessageModel message) {
    if (message.senderId == widget.currentUserId) {
      return RichText(
          maxLines: 2,
          text: TextSpan(children: [
            TextSpan(
                text: 'Sen:',
                style: TextStyle(
                    color: Colors.black54,
                    // color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            TextSpan(text: ': '),
            TextSpan(
              text: message.message,
              style: TextStyle(color: Colors.black),
            ),
          ]));
    } else {
      return Text('${user.nameSurname}: ${message.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user != null && lastMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          onTap: () {
            NavigationService.instance.navigate(k_ROUTE_CHATROOM_PAGE,
                args: [userProvider.currentUser.uid, user]);
          },
          leading: Hero(
            tag: "avatar",
            child: CircleAvatar(
              radius: 40,
              backgroundImage:
                  CachedNetworkImageProvider(user.profilePictureURL),
            ),
          ),
          title: Text(
            user.nameSurname,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: buildSubtitle(lastMessage),
        ),
      );
    } else {
      return Container();
    }
  }
}