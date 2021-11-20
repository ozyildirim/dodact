import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class UserProfileInfoTab extends StatefulWidget {
  @override
  State<UserProfileInfoTab> createState() => _UserProfileInfoTabState();
}

class _UserProfileInfoTabState extends BaseState<UserProfileInfoTab> {
  @override
  Widget build(BuildContext context) {
    var user = userProvider.currentUser;
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: size.width * 0.5,
              height: size.height * 0.1,
              child: ListTile(
                title: Text("Ad-Soyad",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                subtitle: Text(
                  user.nameSurname,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: size.width * 0.5,
              height: size.height * 0.1,
              child: ListTile(
                title: Text("Öğrenim Durumu",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                subtitle: Text(
                  user.education,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: size.width * 0.5,
              height: size.height * 0.1,
              child: ListTile(
                title: Text("Meslek",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                subtitle: Text(
                  user.profession,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: size.width * 0.4,
              height: size.height * 0.1,
              child: ListTile(
                title: Text("Lokasyon",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                subtitle: Text(
                  user.location,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
            width: size.width * 0.8,
            child: Divider(thickness: 0.3, color: Colors.grey)),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: size.width * 0.5,
            // height: size.height * 0.1,
            child: ListTile(
              title: Text("Profil Açıklaması",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              subtitle: Text(
                user.userDescription,
                maxLines: null,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: size.width * 0.6,
          height: size.height * 0.1,
          child: buildSocialIcons(user),
        ),
      ],
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
