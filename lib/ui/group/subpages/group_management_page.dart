import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupManagementPage extends StatelessWidget {
  final double tileTitleSize = 20;
  AppBar appBar = new AppBar(
    title: Text("Topluluk Yönetim"),
    iconTheme: IconThemeData(color: Colors.white),
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
            buildListTile("Profil Yönetimi",
                k_ROUTE_GROUP_PROFILE_MANAGEMENT_PAGE, Icons.privacy_tip),
            buildListTile("Üye Yönetimi", k_ROUTE_GROUP_MEMBER_MANAGEMENT_PAGE,
                Icons.person),
            buildListTile("Etkinlik Yönetimi",
                k_ROUTE_GROUP_EVENT_MANAGEMENT_PAGE, Icons.event_available),
            buildListTile("Gönderi Yönetimi",
                k_ROUTE_GROUP_POST_MANAGEMENT_PAGE, Icons.podcasts),
            buildListTile("Topluluk İlgi Alanları",
                k_ROUTE_GROUP_INTEREST_MANAGEMENT_PAGE, Icons.content_copy),
            buildListTile("Topluluk Medya Yönetimi",
                k_ROUTE_GROUP_MEDIA_MANAGEMENT_PAGE, Icons.perm_media),
          ],
        ),
      ),
    );
  }

  buildListTile(String title, String route, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            icon,
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
              title,
              style: TextStyle(fontSize: tileTitleSize),
            ),
          ),
        ),
        onTap: () {
          Get.toNamed(route);
        },
      ),
    );
  }

  pageBody() {
    return Column(
      children: [],
    );
  }
}
