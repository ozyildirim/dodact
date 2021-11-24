import 'package:dodact_v1/config/base/base_state.dart';
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
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              foregroundColor: Colors.greenAccent,
              radius: 16,
              child: Icon(
                Icons.school,
                color: Colors.white,
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
              radius: 16,
              child: Icon(
                Icons.work,
                color: Colors.white,
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
              radius: 16,
              child: Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
            title: Text("Detaylı Bilgi",
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ReadMoreText(
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
          ),
          SizedBox(height: 20),
          Container(
            // width: size.width * 0.6,
            height: size.height * 0.1,
            child: buildSocialIcons(user),
          ),
        ],
      ),
    );
  }

  buildSocialIcons(UserObject user) {
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
                  CommonMethods.launchURL(linkedin);
                },
                icon: Icon(FontAwesome5Brands.linkedin, size: 25),
              )
            : Container(),
        instagram != null && instagram.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL("www.instagram.com/$instagram");
                },
                icon: Icon(FontAwesome5Brands.instagram, size: 25),
              )
            : Container(),
        dribbble != null && dribbble.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(dribbble);
                },
                icon: Icon(FontAwesome5Brands.dribbble, size: 25),
              )
            : Container(),
        soundcloud != null && soundcloud.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(soundcloud);
                },
                icon: Icon(FontAwesome5Brands.soundcloud, size: 25),
              )
            : Container(),
        youtube != null && youtube.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(youtube);
                },
                icon: Icon(FontAwesome5Brands.youtube, size: 25),
              )
            : Container(),
        pinterest != null && pinterest.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(pinterest);
                },
                icon: Icon(FontAwesome5Brands.pinterest, size: 25),
              )
            : Container(),
      ],
    );
  }
}
