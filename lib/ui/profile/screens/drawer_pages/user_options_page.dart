import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserOptionsPage extends StatelessWidget {
  final double tileTitleSize = 20;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.notifications,
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
                      "Bildirimler",
                      style: TextStyle(fontSize: tileTitleSize),
                    ),
                  ),
                ),
                onTap: () {
                  Get.toNamed(k_ROUTE_USER_NOTIFICATON_SETTINGS);
                },
              ),
            ),
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
                      "Hesap",
                      style: TextStyle(fontSize: tileTitleSize),
                    ),
                  ),
                ),
                onTap: () {
                  Get.toNamed(k_ROUTE_USER_PROFILE_SETTINGS);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.privacy_tip,
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
                      "Gizlilik",
                      style: TextStyle(fontSize: tileTitleSize),
                    ),
                  ),
                ),
                onTap: () {
                  Get.toNamed(k_ROUTE_USER_PRIVACY_SETTINGS);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.security,
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
                      "Güvenlik",
                      style: TextStyle(fontSize: tileTitleSize),
                    ),
                  ),
                ),
                onTap: () {
                  Get.toNamed(k_ROUTE_USER_SECURITY_SETTINGS);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PrivacyPolicyPage();
                      }));
                    },
                    child: Center(
                        child: Text("Gizlilik Sözleşmesi",
                            style: TextStyle(fontSize: 18))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => launchURL('https://dodact.com/hakkimizda/'),
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

  static void launchURL(String requestedUrl) async {
    if (requestedUrl != null) {
      if (await canLaunch(requestedUrl)) {
        await launch(requestedUrl);
      } else {
        throw new Exception("Cannot open URL: " + requestedUrl);
      }
    } else {
      print("URL mevcut değil");
    }
  }
}
