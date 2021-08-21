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
          "Kullanıcı Ayarları",
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
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
                  enabled: false,
                  leading: CircleAvatar(
                    child: Icon(Icons.notifications),
                  ),
                  title: Text(
                    "Bildirim Hesapları",
                    style: TextStyle(fontSize: tileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_USER_NOTIFICATON_SETTINGS);
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
                    "Profil Ayarları",
                    style: TextStyle(fontSize: tileTitleSize),
                  ),
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_USER_PROFILE_SETTINGS);
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
                    "Gizlilik Ayarları",
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
                      color: Colors.white70,
                      child: Center(
                          child: Text("Gizlilik Sözleşmesi",
                              style: TextStyle(fontSize: 18))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      color: Colors.white70,
                      child: Center(
                        child: Text("İletişim", style: TextStyle(fontSize: 18)),
                      ),
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
