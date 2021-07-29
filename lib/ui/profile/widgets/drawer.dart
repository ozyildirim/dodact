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
                image: AssetImage("assets/images/drawerBg.jpg"),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(authProvider.currentUser.profilePictureURL),
                  radius: 30,
                ),
                title: Text(
                  authProvider.currentUser.nameSurname,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                subtitle: Text(authProvider.currentUser.email,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Takvimim", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Favorilerim", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.request_page),
            title: Text("İsteklerim", style: TextStyle(fontSize: 18)),
            onTap: () {
              NavigationService.instance.navigate(k_ROUTE_USER_REQUESTS);
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
            leading: Icon(Icons.report),
            title:
                Text("Şikayet/Bildiri/Öneri", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Dodact Hakkında", style: TextStyle(fontSize: 18)),
            onTap: () {},
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
}
