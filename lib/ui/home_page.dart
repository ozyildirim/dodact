import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/ui/creation/creation_landing_page.dart';
import 'package:dodact_v1/ui/discover/discover_page.dart';
import 'package:dodact_v1/ui/general/general_page.dart';
import 'package:dodact_v1/ui/profile/screens/profile_page.dart';
import 'package:dodact_v1/ui/search/search_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';

// Oturum açmış kullanıcıların görmesi gereken sayfa.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> {
  FirebaseMessaging messaging;
  int selectedIndex = 0;

  final List<Widget> _children = [
    GeneralPage(),
    DiscoverPage(),
    CreationLandingPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
    checkNotificationPermissions();
    checkUserSearchKeywords();
  }

  Future checkNotificationPermissions() async {
    await messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: _children[selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 400),
          color: Color(0xff194d25),
          backgroundColor: Colors.transparent,
          height: 50,
          items: [
            Icon(
              FontAwesome5Solid.home,
              color: Colors.white,
              size: 18,
            ),
            Icon(
              FontAwesome5Solid.globe,
              color: Colors.white,
              size: 18,
            ),
            Icon(
              FontAwesome5Solid.plus,
              color: Colors.white,
              size: 18,
            ),
            Icon(
              FontAwesome5Solid.search,
              color: Colors.white,
              size: 18,
            ),
            IconButton(
                padding: EdgeInsets.zero,
                iconSize: 20,
                icon: GFAvatar(
                  size: 24,
                  // radius: 25,
                  backgroundImage:
                      NetworkImage(userProvider.currentUser.profilePictureURL),
                )),
          ],
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ));
  }

  checkUserSearchKeywords() async {
    if (userProvider.currentUser.searchKeywords == null ||
        userProvider.currentUser.searchKeywords.length < 1) {
      userProvider.updateUserSearchKeywords();
      print("keywords guncellendi");
    }
  }
}
