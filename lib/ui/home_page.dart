import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/ui/creation/creation_page.dart';
import 'package:dodact_v1/ui/discover/discover_page.dart';
import 'package:dodact_v1/ui/general/general_page.dart';
import 'package:dodact_v1/ui/profile/screens/profile_page.dart';
import 'package:dodact_v1/ui/search/search_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
    CreationPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // messaging = FirebaseMessaging.instance;

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });

    // messaging.getToken().then((value) {
    //   updateToken(value);
    // });
    checkUserSearchKeywords();
    userProvider.getCurrentUserFavoritePosts();
  }

  // void updateToken(String value) async {
  //   await tokensRef.doc(authProvider.currentUser.uid).set({
  //     'token': value,
  //     'lastTokenUpdate': FieldValue.serverTimestamp(),
  //   });
  // }

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
          height: 60,
          items: [
            Icon(
              FontAwesome5Solid.home,
              color: Colors.white,
              size: 22,
            ),
            Icon(
              FontAwesome5Solid.globe,
              color: Colors.white,
              size: 22,
            ),
            Icon(
              FontAwesome5Solid.plus,
              color: Colors.white,
              size: 22,
            ),
            Icon(
              FontAwesome5Solid.search,
              color: Colors.white,
              size: 22,
            ),
            Icon(
              FontAwesome5Solid.user,
              color: Colors.white,
              size: 22,
            ),
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
      await userProvider.updateUserSearchKeywords();
      print("keywords guncellendi");
    }
  }
}
