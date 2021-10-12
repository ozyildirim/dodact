import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/chatroom_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';

class OthersProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    if (provider.otherUser == null) {
      return Center(child: spinkit);
    }
    return Column(
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: provider.otherUser.profilePictureURL,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                backgroundColor: Colors.black,
                radius: mediaQuery.size.width * 0.2,
                child: CircleAvatar(
                  radius: mediaQuery.size.width * 0.19,
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "@" + provider.otherUser.username,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 5,
            ),
            provider.otherUser.isVerified == true
                ? Icon(
                    Icons.verified,
                    color: Colors.deepOrangeAccent,
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        GFButton(
          onPressed: () async {
            createChatroom(context, provider.otherUser.uid);
          },
          child: Icon(Icons.message),
          shape: GFButtonShape.pills,
          color: Colors.deepOrangeAccent,
        )
      ],
    );
  }

  createChatroom(BuildContext context, String userId) async {
    var chatroomProvider =
        Provider.of<ChatroomProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var chatroomId = await chatroomProvider.createChatRoom(
        authProvider.currentUser.uid, userId);
    NavigationService.instance
        .navigate(k_ROUTE_CHATROOM_PAGE, args: chatroomId);
  }

  showProfilePictureContainer(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 350,
          width: 350,
          child: PinchZoom(
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
