import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:dodact_v1/ui/interest/interest_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage> {
  FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: spinkit);
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Text("patladı"),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            User user = snapshot.data;
            if (user == null) {
              // return WelcomePage();
              Get.offNamed(k_ROUTE_WELCOME);
            }
            updateToken();
            return checkCurrentUser();
        }
      },
    );
  }

  checkCurrentUser() {
    print("chechCurrentUser çalıştı");
    return FutureBuilder(
      // ignore: missing_return
      builder: (context, AsyncSnapshot<UserObject> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: spinkit);
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Text("bilmiyorum"),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("Bir hata oluştu."),
                ),
              );
            }

            UserObject user = snapshot.data;
            if (user.newUser) Get.toNamed(k_ROUTE_REGISTER_DETAIL);
            if (user.selectedInterests == null ||
                user.selectedInterests.isEmpty)
              Get.offNamed(k_ROUTE_INTEREST_REGISTRATION);
            // return InterestRegistrationPage();
            else
              Get.offNamed(k_ROUTE_HOME);
          // return HomePage();
        }
      },
      future: userProvider.getCurrentUser(),
    );
  }

  void updateToken() async {
    messaging.getToken().then((value) async {
      await tokensRef.doc(authProvider.currentUser.uid).set({
        'token': value,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });

      print("token güncellendi: $value");
    });
  }

  bool isNewUser(UserObject user) {
    if (user.username == null || user.profilePictureURL == null) {
      return true;
    } else {
      return false;
    }
  }
}
