import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_remote_config_service.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage> {
  bool isLoading = true;
  RemoteConfigService _remoteConfigService;
  PackageInfo packageInfo;
  FirebaseMessaging messaging;

  initializeRemoteConfig() async {
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> checkEnforcedVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = packageInfo.version;
    var enforcedVersion = _remoteConfigService.getEnforcedVersionValue;

    final List<int> currentVersionInt = currentVersion
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    final List<int> enforcedVersionInt = enforcedVersion
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    for (int i = 0; i < 3; i++) {
      if (enforcedVersionInt[i] > currentVersionInt[i]) return true;
    }
    return false;
  }

  @override
  void initState() {
    initializeRemoteConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      // ignore: missing_return
      builder: (_, model, child) {
        if (model.currentUser == null) {
          return WelcomePage();
        } else {
          print("çalıştı");
          userProvider.getCurrentUser();

          return Consumer<UserProvider>(
            builder: (_, model, child) {
              if (model.currentUser != null) {
                if (model.currentUser.newUser) {
                  return SignUpDetail();
                }
                return HomePage();
              } else {
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: spinkit,
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  navigateSignupDetail() {
    NavigationService.instance.navigateReplacement(k_ROUTE_REGISTER_DETAIL);
  }

  navigateHomePage() {
    NavigationService.instance.navigateReplacement(k_ROUTE_HOME);
  }

  navigateWelcomePage() {
    NavigationService.instance.navigateReplacement(k_ROUTE_WELCOME);
  }

  bool isNewUser(UserObject user) {
    if (user.username == null || user.profilePictureURL == null) {
      return true;
    } else {
      return false;
    }
  }
}
