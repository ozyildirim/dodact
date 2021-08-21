import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends BaseState<ProfileDrawer> {
  String chosenFieldImage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(chosenFieldImage ??
                    "assets/images/app/interests/resim.jpeg"),
              ),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        authProvider.currentUser.profilePictureURL != null
                            ? NetworkImage(
                                authProvider.currentUser.profilePictureURL)
                            : null,
                    radius: 30,
                  ),
                  title: Text(
                    authProvider.currentUser.nameSurname,
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                  subtitle: Text(authProvider.currentUser.email,
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ),
            ),
          ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.calendar_today),
            title: Text("Takvimim", style: TextStyle(fontSize: 18)),
            onTap: () {
              // NavigationService.instance.navigate(k_ROUTE_USER_CALENDAR_PAGE);
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Favorilerim", style: TextStyle(fontSize: 18)),
            onTap: () {
              NavigationService.instance.navigate(k_ROUTE_USER_FAVORITES);
            },
          ),
          ListTile(
            leading: Icon(Icons.request_page),
            title: Text(
              "İsteklerim",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              NavigationService.instance.navigate(k_ROUTE_USER_REQUESTS);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Yardımlarım", style: TextStyle(fontSize: 18)),
            onTap: () {
              NavigationService.instance
                  .navigate(k_ROUTE_USER_CONTRIBUTIONS_PAGE);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Ayarlarım", style: TextStyle(fontSize: 18)),
            onTap: () {
              NavigationService.instance.navigate(k_ROUTE_USER_OPTIONS);
            },
          ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.settings),
            title: Text("İlgi Alanlarım", style: TextStyle(fontSize: 18)),
            onTap: () {
              NavigationService.instance.navigate(k_ROUTE_INTERESTS_CHOICE);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title:
                Text("Geçici İlgi Alanlarım", style: TextStyle(fontSize: 18)),
            onTap: () {
              NavigationService.instance
                  .navigate(k_ROUTE_TEMPORARY_INTERESTS_CHOICE);
            },
          ),
          ListTile(
            leading: Icon(Icons.report),
            title:
                Text("Şikayet/Bildiri/Öneri", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Dodact Hakkında", style: TextStyle(fontSize: 18)),
            onTap: () {
              NavigationService.instance.navigate(k_ROUTE_ABOUT_DODACT);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Çıkış Yap", style: TextStyle(fontSize: 18)),
            onTap: () => signOut(context),
          ),
        ],
      ),
    );
  }

  void signOut(BuildContext context) async {
    await authProvider.signOut();
    print(
        "AFTER DRAWER SIGNOUT, USER INFO\n: ${authProvider.currentUser.toString()}");
    Provider.of<UserProvider>(context, listen: false).removeUser();
    NavigationService.instance.navigateReplacement(k_ROUTE_LANDING);
    //TODO: Problem var, burayı düzelt.
  }

  setBackgroundImage() {
    switch (authProvider.currentUser.mainInterest) {
      case "Tiyatro":
        chosenFieldImage = "assets/images/app/interests/tiyatro.jpeg";
        break;
      case "Müzik":
        chosenFieldImage = "assets/images/app/interests/muzik.jpeg";
        break;
      case "Dans":
        chosenFieldImage = "assets/images/app/interests/dans.jpeg";
        break;
      case "Görsel Sanatlar":
        chosenFieldImage = "assets/images/app/interests/resim.jpeg";
        break;
      default:
        chosenFieldImage = "assets/images/app/interests/tiyatro.jpeg";
    }
  }
}
