import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:readmore/readmore.dart';

class OthersProfileInfoTab extends StatelessWidget {
  final UserObject user;

  const OthersProfileInfoTab({this.user});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (user == null) {
      return Center(child: spinkit);
    }

    buildTiles() {
      if (user.education.isEmpty &&
          user.profession.isEmpty &&
          user.userDescription.isEmpty) {
        return Center(
          child: Container(
            width: size.width * 0.8,
            child: Image.asset(
              'assets/images/app/empty_profile.png',
              fit: BoxFit.contain,
            ),
          ),
        );
      } else {
        return Column(
          children: [
            !user.privacySettings['hide_education'] && user.education.isNotEmpty
                ? ListTile(
                    leading: CircleAvatar(
                      foregroundColor: Colors.greenAccent,
                      radius: 16,
                      child: Icon(
                        Icons.school,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("Öğrenim Durumu",
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600])),
                    subtitle: Text(
                      user.education,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 10),
            !user.privacySettings['hide_profession'] &&
                    user.profession.isNotEmpty
                ? ListTile(
                    leading: CircleAvatar(
                      foregroundColor: Colors.greenAccent,
                      radius: 16,
                      child: Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("Meslek",
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600])),
                    subtitle: Text(
                      user.profession,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 10),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Container(
              // width: size.width * 0.6,
              height: size.height * 0.1,
              child: buildSocialIcons(user),
            ),
          ],
        );
      }
    }

    return SingleChildScrollView(
      child: buildTiles(),
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
                  CustomMethods.launchURL(linkedin);
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
                  CustomMethods.launchURL("www.instagram.com/$instagram");
                },
                icon: Icon(FontAwesome5Brands.instagram, size: 30),
              )
            : Container(),
        dribbble != null && dribbble.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(dribbble);
                },
                icon: Icon(FontAwesome5Brands.dribbble, size: 30),
              )
            : Container(),
        soundcloud != null && soundcloud.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(soundcloud);
                },
                icon: Icon(FontAwesome5Brands.soundcloud, size: 30),
              )
            : Container(),
        youtube != null && youtube.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(youtube);
                },
                icon: Icon(FontAwesome5Brands.youtube, size: 30),
              )
            : Container(),
        pinterest != null && pinterest.isNotEmpty
            ? IconButton(
                onPressed: () {
                  CustomMethods.launchURL(pinterest);
                },
                icon: Icon(FontAwesome5Brands.pinterest, size: 30),
              )
            : Container(),
      ],
    );
  }
}
