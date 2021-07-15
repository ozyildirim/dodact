import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends BaseState<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Ayarları"),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Center(
              child: Stack(children: [
                GFImageOverlay(
                  color: Colors.black,
                  width: 200,
                  height: 200,
                  image:
                      NetworkImage(authProvider.currentUser.profilePictureURL),
                ),
                Positioned(
                  top: 160,
                  left: 160,
                  child: GFBadge(
                    size: 60,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.flip_camera_android),
                        onPressed: () {}),
                    shape: GFBadgeShape.circle,
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
