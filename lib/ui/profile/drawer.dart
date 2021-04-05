import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDrawer extends StatefulWidget {
  final UserObject sentUser;

  ProfileDrawer({this.sentUser});

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends BaseState<ProfileDrawer> {
  UserObject user;
  AuthProvider _authProvider;

  @override
  void initState() {
    user = widget.sentUser;
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kBackgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              color: kBackgroundColor,
              child: DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            authProvider.currentUser.profilePictureURL == null
                                ? NetworkImage(
                                    "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png")
                                : NetworkImage(
                                    authProvider.currentUser.profilePictureURL),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.username,
                        style: TextStyle(
                            fontFamily: kFontFamily,
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                            fontFamily: kFontFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/drawerBg.jpg')),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      topRight: Radius.circular(80)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Seçenekler', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pushNamed(context, "/profile_options");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.calendar_today_outlined),
                title: Text('Katıldığım Etkinlikler',
                    style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pushNamed(context, "/");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.group),
                title: Text('Topluluklar', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pushNamed(context, "/hizmetler");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('Dodact Hakkında', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pushNamed(context, "/galeri");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                onTap: () {
                  signOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> signOut(BuildContext context) async {
    bool result = await _authProvider.signOut();
    return result;
  }
}
