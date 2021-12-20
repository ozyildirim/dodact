import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:readmore/readmore.dart';

class UserProfileInfoTab extends StatefulWidget {
  @override
  State<UserProfileInfoTab> createState() => _UserProfileInfoTabState();
}

class _UserProfileInfoTabState extends BaseState<UserProfileInfoTab> {
  @override
  Widget build(BuildContext context) {
    var user = userProvider.currentUser;
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: buildTiles(),
    );
  }

  buildTiles() {
    const double avatarRadius = 16.0;
    const double iconSize = 18.0;
    var user = userProvider.currentUser;
    var size = MediaQuery.of(context).size;
    if (userProvider.currentUser.education.isEmpty &&
        userProvider.currentUser.profession.isEmpty &&
        userProvider.currentUser.userDescription.isEmpty) {
      return Center(
          child: Column(
        children: [
          Container(
            width: size.width * 0.8,
            child: Image.asset(
              'assets/images/app/empty_profile.png',
              fit: BoxFit.contain,
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigationService.instance
                  .navigate(k_ROUTE_USER_PERSONAL_PROFILE_SETTINGS);
            },
            child: Text("Profiline detayları eklemek için tıkla",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
        ],
      ));
    } else {
      return Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              foregroundColor: Colors.greenAccent,
              radius: avatarRadius,
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            title: Text("Öğrenim Durumu",
                maxLines: null,
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            subtitle: Text(
              user.education,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              foregroundColor: Colors.greenAccent,
              radius: avatarRadius,
              child: Icon(
                Icons.work,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            title: Text("Meslek",
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            subtitle: Text(
              user.profession,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              foregroundColor: Colors.greenAccent,
              radius: avatarRadius,
              child: Icon(
                Icons.info,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            title: Text("Detaylı Bilgi",
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            subtitle: ReadMoreText(
              user.userDescription,
              style: TextStyle(color: Colors.black, fontSize: 16),
              trimLines: 2,
              colorClickableText: Colors.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Daha fazla detay',
              trimExpandedText: 'Küçült',
              lessStyle: TextStyle(fontWeight: FontWeight.bold),
              moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(height: 20),
          Container(
            // width: size.width * 0.6,
            height: size.height * 0.1,
            child: buildSocialIcons(context, user),
          )
        ],
      );
    }
  }

  buildSocialIcons(BuildContext context, UserObject user) {
    var linkedin = user.socialMediaLinks['linkedin'];
    var youtube = user.socialMediaLinks['youtube'];
    var instagram = user.socialMediaLinks['instagram'];
    var pinterest = user.socialMediaLinks['pinterest'];
    var dribbble = user.socialMediaLinks['dribbbleLink'];
    var soundcloud = user.socialMediaLinks['soundcloud'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        linkedin != null && linkedin.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(context, linkedin);
                },
                icon: Icon(FontAwesome5Brands.linkedin, size: 25),
              )
            : Container(),
        instagram != null && instagram.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(
                      context, "https://www.instagram.com/$instagram/");
                },
                icon: Icon(FontAwesome5Brands.instagram, size: 25),
              )
            : Container(),
        dribbble != null && dribbble.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(context, dribbble);
                },
                icon: Icon(FontAwesome5Brands.dribbble, size: 25),
              )
            : Container(),
        soundcloud != null && soundcloud.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(context, soundcloud);
                },
                icon: Icon(FontAwesome5Brands.soundcloud, size: 25),
              )
            : Container(),
        youtube != null && youtube.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(context, youtube);
                },
                icon: Icon(FontAwesome5Brands.youtube, size: 25),
              )
            : Container(),
        pinterest != null && pinterest.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(context, pinterest);
                },
                icon: Icon(FontAwesome5Brands.pinterest, size: 25),
              )
            : Container(),
      ],
    );
  }
}
