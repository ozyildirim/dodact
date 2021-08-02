import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class OthersProfileInfoPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    var user = provider.otherUser;

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
                      context, user.profilePictureURL),
                  child: CircleAvatar(
                    maxRadius: 80,
                    backgroundImage: NetworkImage(user.profilePictureURL),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(user.nameSurname,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Text("@${user.username}")
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
              child: OthersProfileInfoPV(fetchedUser: user),
            ),
          )
        ],
      ),
    );
  }

  showProfilePictureContainer(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
            ),
          ),
        ),
      ),
    );
  }
}

class OthersProfileInfoPV extends StatefulWidget {
  UserObject fetchedUser;

  OthersProfileInfoPV({this.fetchedUser});

  @override
  _OthersProfileInfoPVState createState() => _OthersProfileInfoPVState();
}

class _OthersProfileInfoPVState extends State<OthersProfileInfoPV> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  UserObject user;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = widget.fetchedUser;
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
        user.linkedInLink != null
            ? IconButton(
                icon: Icon(
                  FontAwesome5Brands.linkedin,
                  size: 30,
                ),
                onPressed: () {
                  CommonMethods.launchURL(user.linkedInLink);
                },
              )
            : null,
        user.dribbbleLink != null
            ? IconButton(
                icon: Icon(
                  FontAwesome5Brands.dribbble,
                  size: 30,
                ),
                onPressed: () {
                  CommonMethods.launchURL(user.dribbbleLink);
                },
              )
            : null,
        user.soundcloudLink != null
            ? IconButton(
                icon: Icon(FontAwesome5Brands.soundcloud, size: 30),
                onPressed: () {
                  CommonMethods.launchURL(user.soundcloudLink);
                },
              )
            : null,
        user.hiddenMail == false
            ? IconButton(
                icon: Icon(FontAwesome5Solid.envelope, size: 30),
                //TODO: Mail atma özelliği ekle
                // onPressed: () {
                //   CommonMethods.launchEmail(authProvider, subject, message)
                // },
              )
            : null,
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
                    Text(user.location)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesome5Solid.map_marker_alt),
                    Text(user.userRegistrationDate.toString())
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
