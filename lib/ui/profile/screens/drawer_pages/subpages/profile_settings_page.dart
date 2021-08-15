import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends BaseState<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Ayarları"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.vpn_key),
                  ),
                  title: Text(
                    "Kişisel Profil Ayarları",
                    style: TextStyle(fontSize: kDrawerTileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_USER_PERSONAL_PROFILE_SETTINGS);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.mail),
                  ),
                  title: Text(
                    "Sosyal Medya Hesap Ayarları",
                    style: TextStyle(fontSize: kDrawerTileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_USER_SOCIAL_ACCOUNTS_SETTINGS);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
