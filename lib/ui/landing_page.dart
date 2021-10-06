import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_remote_config_service.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
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

  // Fetching, caching, and activating remote config

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      if (_remoteConfigService.getUnderConstructionValue) {
        return buildUnderConstructionPage(context);
      } else {
        return FutureBuilder(
          future: checkEnforcedVersion(),
          builder: (_, AsyncSnapshot<bool> asyncSnapshot) {
            if (asyncSnapshot.connectionState != ConnectionState.done)
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(kAuthBackgroundImage),
                  )),
                  child: Center(child: spinkit),
                ),
              );
            //
            else {
              // return enforcedUpdateScreen();
              bool data = asyncSnapshot.data;
              if (data) {
                return EnforcedUpdateScreen();
              } else {
                return Consumer<AuthProvider>(
                  // ignore: missing_return
                  builder: (_, model, child) {
                    if (model.isLoading == false) {
                      if (model.currentUser == null) {
                        return WelcomePage();
                      }
                      if (model.currentUser.newUser) {
                        return SignUpDetail();
                      }

                      return HomePage();
                    }
                    //If state is "Busy"
                  },
                );
              }
            }
            // return main screen here
          },
        );
      }
    } else {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(kAuthBackgroundImage),
          )),
          child: Center(child: spinkit),
        ),
      );
    }
  }

  bool isNewUser() {
    if (authProvider.currentUser.username == null ||
        authProvider.currentUser.profilePictureURL == null) {
      return true;
    } else {
      return false;
    }
  }

  buildUnderConstructionPage(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/app/under_construction.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.4,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/app/logo.png'),
              )),
            ),
            Text(
              "Bakımdayız",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 10),
            GFIconButton(
                shape: GFIconButtonShape.circle,
                icon: Icon(FontAwesome5Brands.twitter),
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}

class EnforcedUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(kAuthBackgroundImage),
          ),
        ),
        child: Center(
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Text(
                  "Lütfen uygulamayı güncelleyin.",
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
