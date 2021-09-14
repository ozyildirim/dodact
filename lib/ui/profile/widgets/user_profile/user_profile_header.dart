import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class UserProfileHeader extends StatefulWidget {
  @override
  _UserProfileHeaderState createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends BaseState<UserProfileHeader> {
  final _items = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
  ];

  final _currentPageNotifier = ValueNotifier<int>(0);
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return Center(
      child: Column(
        children: [
          Container(
            height: mediaQuery.size.height * 0.3,
            width: mediaQuery.size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: PageView(
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
                scrollDirection: Axis.horizontal,
                controller: _controller,
                children: [
                  _picturePage(authProvider.currentUser.profilePictureURL),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: _firstPage(),
                    ),
                  ),
                  _secondPage(),
                  Center(
                    child: _thirdPage(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: _buildCircleIndicator(),
          )
        ],
      ),
    );
  }

  Widget _picturePage(String imageUrl) {
    return Container(
      child: InkWell(
        onTap: () => showProfilePictureContainer(context, imageUrl),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            radius: 20,
          ),
        ),
      ),
    );
    // return Padding(
    //     padding: const EdgeInsets.all(16.0), child: Image.network(imageUrl));
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
              authProvider.currentUser.nameSurname != null &&
                      authProvider.currentUser.nameSurname != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              authProvider.currentUser.nameSurname,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
              authProvider.currentUser.education != null &&
                      authProvider.currentUser.education != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.school),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            authProvider.currentUser.education,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )
                  : Container(),
              authProvider.currentUser.profession != null &&
                      authProvider.currentUser.profession != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.work),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            authProvider.currentUser.profession,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )
                  : Container(),
              authProvider.currentUser.location != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(FontAwesome5Solid.map_marker_alt),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(authProvider.currentUser.location,
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
      child: Text(
        authProvider.currentUser.userDescription,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _thirdPage() {
    return Container(
      color: Colors.white60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          authProvider.currentUser.linkedInLink != null &&
                  authProvider.currentUser.linkedInLink != ''
              ? IconButton(
                  icon: Icon(
                    FontAwesome5Brands.linkedin,
                    size: 30,
                  ),
                  onPressed: () {
                    CommonMethods.launchURL(
                        authProvider.currentUser.linkedInLink);
                  },
                )
              : Container(),
          authProvider.currentUser.dribbbleLink != null &&
                  authProvider.currentUser.dribbbleLink != ''
              ? IconButton(
                  icon: Icon(
                    FontAwesome5Brands.dribbble,
                    size: 30,
                  ),
                  onPressed: () {
                    CommonMethods.launchURL(
                        authProvider.currentUser.dribbbleLink);
                  },
                )
              : Container(),
          authProvider.currentUser.soundcloudLink != null &&
                  authProvider.currentUser.soundcloudLink != ''
              ? IconButton(
                  icon: Icon(FontAwesome5Brands.soundcloud, size: 30),
                  onPressed: () {
                    CommonMethods.launchURL(
                        authProvider.currentUser.soundcloudLink);
                  },
                )
              : Container(),
          authProvider.currentUser.instagramUsername != null &&
                  authProvider.currentUser.instagramUsername != ''
              ? IconButton(
                  icon: Icon(FontAwesome5Brands.instagram, size: 30),
                  onPressed: () {
                    CommonMethods.launchURL("https://www.instagram.com/" +
                        authProvider.currentUser.instagramUsername);
                  },
                )
              : Container(),
          IconButton(
            icon: Icon(FontAwesome5Solid.envelope, size: 30),
            // ignore: todo

            onPressed: () {
              CommonMethods.launchEmail(
                  authProvider.currentUser.email, "Konu", "Mesaj");
            },
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

  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CirclePageIndicator(
        size: 6,
        selectedDotColor: Colors.cyan,
        dotColor: Colors.grey,
        itemCount: _items.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
