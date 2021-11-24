import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/services/concrete/firebase_dynamic_link_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DodCardPage extends StatefulWidget {
  @override
  _DodCardPageState createState() => _DodCardPageState();
}

class _DodCardPageState extends BaseState<DodCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("DodCard"),
      ),
      body: pageBody(),
    );
  }

  pageBody() {
    return Container(
      width: dynamicWidth(1),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(kBackgroundImage),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GFAvatar(
            radius: 60,
            backgroundImage:
                NetworkImage(userProvider.currentUser.profilePictureURL),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            userProvider.currentUser.username,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: createQrImage(),
          ),
        ],
      ),
    );
  }

  createQrImage() {
    var params = FirebaseDynamicLinkService.createUserProfileDynamicLink(
        userProvider.currentUser.uid);
    return FutureBuilder(
        future: FirebaseDynamicLinkService.getShortLink(params),
        builder: (_, AsyncSnapshot<Uri> snapshot) {
          if (snapshot.hasData) {
            return QrImage(
              data: snapshot.data.toString(),
              version: QrVersions.auto,
              size: 240,
              gapless: false,
              embeddedImage: AssetImage(kDodactLogo),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(30, 30),
              ),
            );
          } else {
            return CircularProgressIndicator.adaptive();
          }
        });

    // return QrImage(
    //   data: "1234567890",
    //   version: QrVersions.auto,
    //   size: 200.0,
    // );
  }
}
