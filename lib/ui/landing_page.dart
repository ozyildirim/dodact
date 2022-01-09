import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:dodact_v1/ui/interest/interest_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage> {
  FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    // checkUserStatus();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      updateToken(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return WelcomePage();
          }
          return checkCurrentUser();
        } else {
          return Scaffold(
            body: Center(
              child: spinkit,
            ),
          );
        }
      },
    );
  }

  checkCurrentUser() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<UserObject> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            UserObject user = snapshot.data;
            if (user.newUser) Get.toNamed(k_ROUTE_REGISTER_DETAIL);
            if (user.selectedInterests == null ||
                user.selectedInterests.isEmpty)
              // Get.toNamed(k_ROUTE_INTEREST_REGISTRATION);
              return InterestRegistrationPage();
            else
              // Get.toNamed(k_ROUTE_HOME);
              return HomePage();
          } else {
            return Container(
              child: Center(
                child: Text("Bir hata oluştu."),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: spinkit,
            ),
          );
        }
      },
      future: userProvider.getCurrentUser(),
    );
  }

// getCurrentUser() {
//   CustomMethods().showLoaderDialog(context, 'Yükleniyor');
//   userProvider.getCurrentUser().then((UserObject user) {
//     if (user.newUser) Get.toNamed(k_ROUTE_REGISTER_DETAIL);
//     if (user.selectedInterests == null || user.selectedInterests.isEmpty)
//       Get.toNamed(k_ROUTE_INTEREST_REGISTRATION);
//     else
//       Get.toNamed(k_ROUTE_HOME);
//   });
// }

// return Consumer<AuthProvider>(
//   // ignore: missing_return
//   builder: (_, model, child) {
//     if (model.currentUser == null) {
//       return WelcomePage();
//     }
//     return Consumer<UserProvider>(
//       builder: (_, model, child) {
//         if (model.currentUser != null) {
//           if (model.currentUser.newUser) return SignUpDetail();
//           if (model.currentUser.selectedInterests == null ||
//               model.currentUser.selectedInterests.isEmpty)
//             return InterestRegistrationPage();

//           return HomePage();
//         } else {
//           userProvider.getCurrentUser();
//           return Scaffold(
//             body: Container(
//               child: Center(
//                 child: spinkit,
//               ),
//             ),
//           );
//         }
//       },
//     );
//   },
// );

  void updateToken(String value) async {
    await tokensRef.doc(authProvider.currentUser.uid).set({
      'token': value,
      'lastTokenUpdate': FieldValue.serverTimestamp(),
    });

    print("token güncellendi: $value");
  }

  bool isNewUser(UserObject user) {
    if (user.username == null || user.profilePictureURL == null) {
      return true;
    } else {
      return false;
    }
  }
}
