import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:dodact_v1/ui/interest/interest_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage> {
  FirebaseMessaging messaging;
  FirebaseAuth instance;
  bool isLoading = true;

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;

    // FirebaseAuth.instance.authStateChanges().listen((user) {
    //   if (user == null) {
    //     Get.offNamed(k_ROUTE_WELCOME);
    //   } else {
    //     updateToken();
    //     setState(() {
    //       isLoading = false;
    //     });
    //     return checkCurrentUser();
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser.emailVerified) {
      return FutureBuilder(
        // ignore: missing_return
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
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

              print(snapshot.data);
              UserObject user = snapshot.data;
              if (user.newUser)
                // Get.toNamed(k_ROUTE_REGISTER_DETAIL);
                return SignUpDetail();
              if (user.selectedInterests == null ||
                  user.selectedInterests.isEmpty)
                // Get.toNamed(k_ROUTE_INTEREST_REGISTRATION);
                return InterestRegistrationPage();
              else
                // Get.toNamed(k_ROUTE_HOME);
                return HomePage();
          }
        },
        future: userProvider.getCurrentUser(),
      );
    } else {
      return WelcomePage();
    }

    // if (isLoading) {
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(
    //         color: Colors.green,
    //       ),
    //     ),
    //   );
    // } else {
    //   return FutureBuilder(
    //     // ignore: missing_return
    //     builder: (context, AsyncSnapshot snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //         case ConnectionState.active:
    //         case ConnectionState.waiting:
    //           return Scaffold(
    //             body: Center(
    //               child: CircularProgressIndicator(
    //                 color: Colors.green,
    //               ),
    //             ),
    //           );
    //         case ConnectionState.done:
    //           if (snapshot.hasError) {
    //             return Container(
    //               child: Center(
    //                 child: Text("Bir hata oluştu."),
    //               ),
    //             );
    //           }

    //           print(snapshot.data);
    //           UserObject user = snapshot.data;
    //           if (user.newUser)
    //             // Get.toNamed(k_ROUTE_REGISTER_DETAIL);
    //             return SignUpDetail();
    //           if (user.selectedInterests == null ||
    //               user.selectedInterests.isEmpty)
    //             // Get.toNamed(k_ROUTE_INTEREST_REGISTRATION);
    //             return InterestRegistrationPage();
    //           else
    //             // Get.toNamed(k_ROUTE_HOME);
    //             return HomePage();
    //       }
    //     },
    //     future: userProvider.getCurrentUser(),
    //   );
    // }
  }

  checkCurrentUser() {
    print("chechCurrentUser çalıştı");
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
