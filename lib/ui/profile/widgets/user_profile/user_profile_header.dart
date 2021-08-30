import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

class UserProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

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
                      context, provider.currentUser.profilePictureURL),
                  child: CachedNetworkImage(
                    imageUrl: provider.currentUser.profilePictureURL,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      maxRadius: 80,
                      backgroundImage:
                          NetworkImage(provider.currentUser.profilePictureURL),
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

class _ProfileInfoCardState extends BaseState<ProfileInfoCard> {
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
    return Container(
      decoration: BoxDecoration(
        gradient: FlutterGradients.winterNeva(
          tileMode: TileMode.clamp,
        ),
      ),
      // color: Colors.white10),
      child: PageView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        children: [
          Center(
            child: _firstPage(),
          ),
          Center(
            child: _secondPage(),
          ),
          Center(
            child: _thirdPage(),
          ),
        ],
      ),
    );
  }

  Widget _thirdPage() {
    return Row(
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
        IconButton(
          icon: Icon(FontAwesome5Solid.envelope, size: 30),
          // ignore: todo

          onPressed: () {
            CommonMethods.launchEmail(
                authProvider.currentUser.email, "Konu", "Mesaj");
          },
        ),
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
              authProvider.currentUser.nameSurname != null
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
                  : Container,
            ],
          ),
        ),
      ],
    );
  }

  Widget _secondPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(authProvider.currentUser.userDescription),
    );
  }
}
