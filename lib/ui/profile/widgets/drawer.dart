import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends BaseState<ProfileDrawer> {
  UserObject user;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = authProvider.currentUser;
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
                image: AssetImage("assets/images/drawerBg.jpg"),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePictureURL),
                  radius: 30,
                ),
                title: Text(
                  user.nameSurname,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                subtitle: Text(user.email,
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
            leading: Icon(Icons.info),
            title: Text("Dodact Hakkında", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Ayarlarım", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.report),
            title:
                Text("Şikayet/Bildiri/Öneri", style: TextStyle(fontSize: 18)),
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
    await userProvider.removeUser();
  }
}

/**
   * 
   * Expanded(
            flex: 3,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Seçenekler', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pushNamed(context, "/profile_options");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today_outlined),
                  title: Text('Katıldığım Etkinlikler',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pushNamed(context, "/");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Topluluklar', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pushNamed(context, "/hizmetler");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title:
                      Text('Dodact Hakkında', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pushNamed(context, "/galeri");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    signOut(context);
                  },
                ),
              ],
            ),
          )
 * 
 * 
 * */
