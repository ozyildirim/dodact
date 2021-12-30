import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
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
              return InkWell(
                onTap: () {
                  CustomMethods.showImagePreviewDialog(context,
                      imageProvider: imageProvider);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: mediaQuery.size.width * 0.2,
                  child: CircleAvatar(
                    radius: mediaQuery.size.width * 0.19,
                    backgroundImage: imageProvider,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "@" + provider.otherUser.username,
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            Text(
              provider.otherUser.nameSurname,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
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
        !provider.otherUser.privacySettings["hide_location"]
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600]),
                  Text(
                    provider.otherUser.location,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              )
            : Container(),
        provider.otherUser.artistLabel.isNotEmpty
            ? Text(
                provider.otherUser.artistLabel,
                style: TextStyle(color: Colors.grey[600]),
              )
            : Container()
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
