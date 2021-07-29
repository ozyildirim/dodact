import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
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
                CircleAvatar(
                  maxRadius: 80,
                  backgroundImage:
                      NetworkImage(provider.currentUser.profilePictureURL),
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
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            FontAwesome5Brands.dribbble,
            size: 30,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(FontAwesome5Brands.soundcloud, size: 30),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(FontAwesome5Solid.envelope, size: 30),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _personalInfoPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesome5Solid.map_marker_alt),
            Text(authProvider.currentUser.location)
          ],
        ),
      ],
    );
  }
}
