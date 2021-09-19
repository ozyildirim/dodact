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
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      updateToken(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification.body);
      //TODO: Awesome notif ekle

      //Bildirim ile diyalog gösterimi
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text("Notification"),
      //         content: Text(event.notification.body),
      //         actions: [
      //           TextButton(
      //             child: Text("Ok"),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           )
      //         ],
      //       );
      //     });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: _children[selectedIndex],
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     NavigationService.instance.navigate(k_ROUTE_CREATION);
        //   },
        //   child: Icon(Icons.add),
        // ),
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 400),
          color: Colors.orange[700],
          backgroundColor: Colors.transparent,
          height: 60,
          items: [
            Icon(FontAwesome5Solid.home),
            Icon(FontAwesome5Solid.globe),
            Icon(FontAwesome5Solid.plus),
            Icon(FontAwesome5Solid.search),
            Icon(FontAwesome5Solid.user),
          ],
          onTap: (value) {
            setState(() {
              this.selectedIndex = value;
            });
          },
        ));
  }

  updateToken(String token) async {
    await tokensRef.doc(authProvider.currentUser.uid).set({
      'token': token,
      'lastTokenUpdate': FieldValue.serverTimestamp(),
    });
  }
}
