import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
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
                radius: 100,
                child: CircleAvatar(
                  radius: 95,
                  backgroundImage:
                      NetworkImage(provider.otherUser.profilePictureURL),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "@" + provider.otherUser.username,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
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
