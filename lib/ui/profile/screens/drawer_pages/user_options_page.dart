import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class UserOptionsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Kullanıcı Ayarları",
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.notifications),
                ),
                title: Text("Bildirim Hesapları"),
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
                title: Text("Profil Ayarları"),
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
                title: Text("Gizlilik Ayarları"),
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
                title: Text("Güvenlik"),
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
                    child: Container(
                      height: 30,
                      child: Center(child: Text("Gizlilik Sözleşmesi")),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      child: Center(child: Text("İletişim")),
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
