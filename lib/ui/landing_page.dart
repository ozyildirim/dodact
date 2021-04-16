import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage> {


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, model, child) {
        if (model.isLoading == false) {
          if (model.currentUser == null) {
            return WelcomePage();
          } else {
            if (checkIfNewUser(model)) {
              return SignUpDetail();
            } else {
              return HomePage();
            }
          }
        } else {
          //If state is "Busy"
          return Scaffold(
            body: Center(
              child: spinkit,
            ),
          );
        }
      },
    );
  }

  bool checkIfNewUser(AuthProvider model) {
    if (model.currentUser.username == null ||
        model.currentUser.profilePictureURL == null) {
      return true;
    } else {
      return false;
    }
  }
}
