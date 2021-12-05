import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            CommonMethods.showImagePreviewDialog(context,
                url: user.profilePictureURL);
          },
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: dynamicWidth(0.2),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: dynamicWidth(0.19),
                  backgroundImage:
                      CachedNetworkImageProvider(user.profilePictureURL),
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: InkWell(
                    onTap: navigateUserProfileSettings,
                    child: CircleAvatar(
                      child: Icon(Icons.edit, color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "@" + user.username,
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            Text(
              user.nameSurname,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
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
            SizedBox(height: 10),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.grey[600]),
            Text(
              provider.currentUser.location,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        )
      ],
    );
  }

  void navigateUserProfileSettings() {
    NavigationService.instance.navigate(k_ROUTE_USER_PERSONAL_PROFILE_SETTINGS);
  }
}
