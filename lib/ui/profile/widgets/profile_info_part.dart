import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';

class ProfileInfoPart extends StatelessWidget {
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
                  child: CircleAvatar(
                    maxRadius: 80,
                    backgroundImage:
                        NetworkImage(provider.currentUser.profilePictureURL),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(provider.currentUser.nameSurname,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Text("@${provider.currentUser.username}")
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
              child: ProfileInfoPV(),
            ),
          )
        ],
      ),
    );
  }
  // AlertDialog(
  //       content: ,
  //     ),

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

class ProfileInfoPV extends StatefulWidget {
  @override
  _ProfileInfoPVState createState() => _ProfileInfoPVState();
}

class _ProfileInfoPVState extends BaseState<ProfileInfoPV> {
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
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: _controller,
      children: [
        Center(
          child: _personalInfoPage(),
        ),
        Center(
          child: Text("asdads"),
        ),
        Center(
          child: _socialInfoPage(),
        ),
      ],
    );
  }

  Widget _socialInfoPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            FontAwesome5Brands.linkedin,
            size: 30,
          ),
          onPressed: () {
            CommonMethods.launchURL(authProvider.currentUser.linkedInLink);
          },
        ),
        IconButton(
          icon: Icon(
            FontAwesome5Brands.dribbble,
            size: 30,
          ),
          onPressed: () {
            CommonMethods.launchURL(authProvider.currentUser.dribbbleLink);
          },
        ),
        IconButton(
          icon: Icon(FontAwesome5Brands.soundcloud, size: 30),
          onPressed: () {
            CommonMethods.launchURL(authProvider.currentUser.soundcloudLink);
          },
        ),
        IconButton(
          icon: Icon(FontAwesome5Solid.envelope, size: 30),
          // ignore: todo
          //TODO: Mail atma özelliği ekle
          // onPressed: () {
          //   CommonMethods.launchEmail(authProvider, subject, message)
          // },
        ),
      ],
    );
  }

  Widget _personalInfoPage() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesome5Solid.map_marker_alt),
                    Text(authProvider.currentUser.location)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesome5Solid.map_marker_alt),
                    Text(authProvider.currentUser.userRegistrationDate
                        .toString())
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
