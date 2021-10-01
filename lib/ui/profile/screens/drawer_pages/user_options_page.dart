import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class UserOptionsPage extends StatelessWidget {
  final double tileTitleSize = 20;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ayarlar",
        ),
        centerTitle: true,
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
                enabled: false,
                leading: CircleAvatar(
                  child: Icon(Icons.notifications),
                ),
                title: Text(
                  "Bildirimler",
                  style: TextStyle(fontSize: tileTitleSize),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_USER_NOTIFICATON_SETTINGS);
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
                  "Profil",
                  style: TextStyle(fontSize: tileTitleSize),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_USER_PROFILE_SETTINGS);
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
                  "Gizlilik",
                  style: TextStyle(fontSize: tileTitleSize),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_USER_PRIVACY_SETTINGS);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.security),
                ),
                title: Text(
                  "Güvenlik",
                  style: TextStyle(fontSize: tileTitleSize),
                ),
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_USER_SECURITY_SETTINGS);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                        child: Text("Gizlilik Sözleşmesi",
                            style: TextStyle(fontSize: 18))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text("İletişim", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
