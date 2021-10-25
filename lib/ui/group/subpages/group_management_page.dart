import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class GroupManagementPage extends StatelessWidget {
  final double tileTitleSize = 20;
  AppBar appBar = new AppBar(
    title: Text("Topluluk Yönetim"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
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
                  child: Icon(Icons.privacy_tip),
                ),
                title: Text(
                  "Profil Yönetimi",
                  style: TextStyle(fontSize: tileTitleSize),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_GROUP_PROFILE_MANAGEMENT_PAGE);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  "Topluluk İlgi Alanları",
                  style: TextStyle(fontSize: tileTitleSize),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_GROUP_INTEREST_MANAGEMENT_PAGE);
                },
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
