import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class GroupManagementPage extends StatelessWidget {
  final double tileTitleSize = 20;
  AppBar appBar = new AppBar(
    title: Text("Grup Yönetim"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.privacy_tip),
                  ),
                  title: Text(
                    "Grup Profil Yönetimi",
                    style: TextStyle(fontSize: tileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_USER_PRIVACY_SETTINGS);
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
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    "Üye Yönetimi",
                    style: TextStyle(fontSize: tileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_GROUP_MEMBER_MANAGEMENT_PAGE);
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
                    child: Icon(Icons.privacy_tip),
                  ),
                  title: Text(
                    "Etkinlik Yönetimi",
                    style: TextStyle(fontSize: tileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_GROUP_EVENT_MANAGEMENT_PAGE);
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
                    child: Icon(Icons.privacy_tip),
                  ),
                  title: Text(
                    "İçerik Yönetimi",
                    style: TextStyle(fontSize: tileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_GROUP_POST_MANAGEMENT_PAGE);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pageBody() {
    return Column(
      children: [],
    );
  }
}
