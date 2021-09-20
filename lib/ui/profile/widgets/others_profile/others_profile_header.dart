import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';

class OthersProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: 240,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => showProfilePictureContainer(
                      context, provider.otherUser.profilePictureURL),
                  child: CachedNetworkImage(
                    imageUrl: provider.otherUser.profilePictureURL,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      maxRadius: 80,
                      backgroundImage:
                          NetworkImage(provider.otherUser.profilePictureURL),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ProfileInfoCard(),
              ),
            ),
          ),
        ],
      ),
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

class ProfileInfoCard extends StatefulWidget {
  @override
  _ProfileInfoCardState createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  UserProvider userProvider;

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     gradient: FlutterGradients.winterNeva(
    //       tileMode: TileMode.clamp,
    //     ),
    //   ),
    //   // color: Colors.white10),
    //   child: PageView(
    //     scrollDirection: Axis.horizontal,
    //     controller: _controller,
    //     children: [
    //       Center(
    //         child: _firstPage(),
    //       ),
    //       Center(
    //         child: _secondPage(),
    //       ),
    //       Center(
    //         child: _thirdPage(),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _thirdPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        userProvider.otherUser.linkedInLink != null &&
                userProvider.otherUser.linkedInLink != ''
            ? IconButton(
                icon: Icon(
                  FontAwesome5Brands.linkedin,
                  size: 30,
                ),
                onPressed: () {
                  CommonMethods.launchURL(userProvider.otherUser.linkedInLink);
                },
              )
            : Container(),
        userProvider.otherUser.dribbbleLink != null &&
                userProvider.otherUser.dribbbleLink != ''
            ? IconButton(
                icon: Icon(
                  FontAwesome5Brands.dribbble,
                  size: 30,
                ),
                onPressed: () {
                  CommonMethods.launchURL(userProvider.otherUser.dribbbleLink);
                },
              )
            : Container(),
        userProvider.otherUser.soundcloudLink != null &&
                userProvider.otherUser.soundcloudLink != ''
            ? IconButton(
                icon: Icon(FontAwesome5Brands.soundcloud, size: 30),
                onPressed: () {
                  CommonMethods.launchURL(
                      userProvider.otherUser.soundcloudLink);
                },
              )
            : Container(),
        !userProvider.otherUser.hiddenMail
            ? IconButton(
                icon: Icon(FontAwesome5Solid.envelope, size: 30),
                // ignore: todo

                onPressed: () {
                  CommonMethods.launchEmail(
                      userProvider.otherUser.email, "Konu", "Mesaj");
                },
              )
            : Container(),
      ],
    );
  }

  Widget _firstPage() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userProvider.otherUser.nameSurname != null &&
                      userProvider.otherUser.nameSurname != '' &&
                      !userProvider.otherUser.hiddenNameSurname
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              userProvider.otherUser.nameSurname,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
              userProvider.otherUser.education != null &&
                      userProvider.otherUser.education != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.school),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            userProvider.otherUser.education,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )
                  : Container(),
              userProvider.otherUser.profession != null &&
                      userProvider.otherUser.profession != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.work),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            userProvider.otherUser.profession,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )
                  : Container(),
              userProvider.otherUser.location != null &&
                      !userProvider.otherUser.hiddenLocation
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(FontAwesome5Solid.map_marker_alt),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(userProvider.otherUser.location,
                              style: TextStyle(fontSize: 18)),
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _secondPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(userProvider.otherUser.userDescription),
    );
  }
}
