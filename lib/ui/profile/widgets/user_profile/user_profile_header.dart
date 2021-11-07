import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';

class UserProfileHeader extends StatefulWidget {
  @override
  _UserProfileHeaderState createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends BaseState<UserProfileHeader> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    var user = provider.currentUser;

    return Column(
      children: [
        Center(
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: spinkit,
            ),
            imageUrl: user.profilePictureURL,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) {
              return InkWell(
                onTap: () {
                  CommonMethods.showImagePreviewDialog(context,
                      imageProvider: imageProvider);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: dynamicWidth(0.2),
                  child: CircleAvatar(
                    radius: dynamicWidth(0.19),
                    backgroundImage: imageProvider,
                  ),
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
              "@" + user.username,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 5,
            ),
            user.isVerified == true
                ? Icon(
                    Icons.verified,
                    color: Colors.deepOrangeAccent,
                  )
                : SizedBox(),
          ],
        )
      ],
    );
  }
}
