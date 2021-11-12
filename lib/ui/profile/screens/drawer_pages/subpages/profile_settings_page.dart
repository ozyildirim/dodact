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
  final double tileTitleSize = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Ayarları"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                title: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Kişisel Bilgiler",
                      style: TextStyle(fontSize: tileTitleSize),
                    ),
                  ),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_USER_PERSONAL_PROFILE_SETTINGS);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.manage_accounts,
                    color: Colors.black,
                  ),
                ),
                title: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Diğer Platform Hesapları",
                      style: TextStyle(fontSize: tileTitleSize),
                    ),
                  ),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_USER_SOCIAL_ACCOUNTS_SETTINGS);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
