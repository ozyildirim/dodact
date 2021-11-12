import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
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
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text(user.nameSurname),
        ),
        user.education != null && user.education.isNotEmpty
            ? ListTile(
                leading: Icon(Icons.school),
                title: Text(user.education),
              )
            : Container(),

        user.profession != null && user.profession.isNotEmpty
            ? ListTile(
                leading: Icon(Icons.work),
                title: Text(user.profession),
              )
            : Container(),
        user.location != null && user.location.isNotEmpty
            ? ListTile(
                leading: Icon(Icons.location_city),
                title: Text(user.location),
              )
            : Container(),
        buildSocialIcons(user),
        Divider(
          thickness: 1,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 12, left: 12),
        //   child: Text("Açıklama", style: TextStyle(fontSize: 16)),
        // ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            user.userDescription,
            style: TextStyle(fontSize: 16),
          ),
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
                icon: Icon(
                  FontAwesome5Brands.linkedin,
                  size: 30,
                ),
              )
            : Container(),
        instagram != null && instagram.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL("www.instagram.com/$instagram");
                },
                icon: Icon(FontAwesome5Brands.instagram, size: 30),
              )
            : Container(),
        dribbble != null && dribbble.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(dribbble);
                },
                icon: Icon(FontAwesome5Brands.dribbble, size: 30),
              )
            : Container(),
        soundcloud != null && soundcloud.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(soundcloud);
                },
                icon: Icon(FontAwesome5Brands.soundcloud, size: 30),
              )
            : Container(),
        youtube != null && youtube.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(youtube);
                },
                icon: Icon(FontAwesome5Brands.youtube, size: 30),
              )
            : Container(),
        pinterest != null && pinterest.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CommonMethods.launchURL(pinterest);
                },
                icon: Icon(FontAwesome5Brands.pinterest, size: 30),
              )
            : Container(),
      ],
    );
  }
}
