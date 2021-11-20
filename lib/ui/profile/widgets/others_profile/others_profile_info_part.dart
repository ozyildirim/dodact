import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class OthersProfileInfoTab extends StatelessWidget {
  final UserObject user;

  const OthersProfileInfoTab({this.user});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (user == null) {
      return Center(child: spinkit);
    }
    // return ListView(
    //   children: [
    //     ListTile(
    //       leading: Icon(Icons.person),
    //       title: Text(user.nameSurname),
    //     ),
    //     !user.privacySettings['hide_education'] &&
    //             user.education != null &&
    //             user.education.isNotEmpty
    //         ? ListTile(
    //             leading: Icon(Icons.school),
    //             title: Text(user.education),
    //           )
    //         : Container(),
    //     !user.privacySettings['hide_profession'] &&
    //             user.profession != null &&
    //             user.profession.isNotEmpty
    //         ? ListTile(
    //             leading: Icon(Icons.work),
    //             title: Text(user.profession),
    //           )
    //         : Container(),
    //     user.location != null && user.location.isNotEmpty
    //         ? ListTile(
    //             leading: Icon(Icons.location_city),
    //             title: Text(user.location),
    //           )
    //         : Container(),
    //     Divider(
    //       thickness: 1,
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(top: 12, left: 12),
    //       child: Text("Açıklama", style: TextStyle(fontSize: 16)),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(12.0),
    //       child: Text(
    //         user.userDescription,
    //         style: TextStyle(fontSize: 16),
    //       ),
    //     ),
    //     buildSocialIcons(user)
    //   ],
    // );

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: size.width * 0.5,
                height: size.height * 0.1,
                child: ListTile(
                  title: Text("Ad-Soyad",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  subtitle: Text(
                    user.nameSurname,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              !user.privacySettings['hide_education'] &&
                      user.education.isNotEmpty
                  ? Container(
                      width: size.width * 0.5,
                      height: size.height * 0.1,
                      child: ListTile(
                        title: Text("Öğrenim Durumu",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                        subtitle: Text(
                          user.education,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              !user.privacySettings['hide_profession'] &&
                      user.profession.isNotEmpty
                  ? Container(
                      width: size.width * 0.5,
                      height: size.height * 0.1,
                      child: ListTile(
                        title: Text("Meslek",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                        subtitle: Text(
                          user.profession,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              !user.privacySettings['hide_location'] && user.location.isNotEmpty
                  ? Container(
                      width: size.width * 0.5,
                      height: size.height * 0.1,
                      child: ListTile(
                        title: Text("Lokasyon",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                        subtitle: Text(
                          user.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: size.width,
              // height: size.height * 0.1,
              child: ListTile(
                title: Text("Detaylı Bilgi",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    user.userDescription,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
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
