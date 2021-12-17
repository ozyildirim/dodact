import 'dart:io';

import 'package:dodact_v1/config/constants/app_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/services/concrete/firebase_remote_config_service.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionControlPage extends StatefulWidget {
  @override
  _VersionControlPageState createState() => _VersionControlPageState();
}

class _VersionControlPageState extends State<VersionControlPage> {
  RemoteConfigService _remoteConfigService;
  PackageInfo packageInfo;
  bool isLoading = true;

  initializeRemoteConfig() async {
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> checkEnforcedVersion() async {
    // return Future.value(false);
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
  initState() {
    super.initState();
    initializeRemoteConfig();
  }

  @override
  Widget build(BuildContext context) {
    return buildPage();
  }

  buildPage() {
    if (!isLoading) {
      if (_remoteConfigService.getUnderConstructionValue ||
          (_remoteConfigService.getUniqueCode != AppConstant.kAppUniqueCode)) {
        return Future.microtask(() => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UnderConstructionScreen())));
      } else {
        return FutureBuilder(
            future: checkEnforcedVersion(),
            // ignore: missing_return
            builder: (_, AsyncSnapshot<bool> asyncSnapshot) {
              if (asyncSnapshot.connectionState != ConnectionState.done) {
                return Scaffold(
                  body: Container(
                    child: Center(child: spinkit),
                  ),
                );
              } else {
                bool data = asyncSnapshot.data;
                if (data) {
                  return EnforcedUpdateScreen();
                } else {
                  return LandingPage();
                }
              }
            });
      }
    } else {
      return Scaffold(
        body: Container(
          child: Center(
            child: spinkit,
          ),
        ),
      );
    }
  }
}

class UnderConstructionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              "Kısa bir süreliğine bakımdayız",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFIconButton(
                    color: Colors.transparent,
                    shape: GFIconButtonShape.circle,
                    icon: Icon(FontAwesome5Brands.twitter),
                    onPressed: () {
                      CustomMethods.launchURL("https://twitter.com/dodactcom");
                    }),
                GFIconButton(
                    shape: GFIconButtonShape.circle,
                    color: Colors.transparent,
                    icon: Icon(FontAwesome5Brands.instagram),
                    onPressed: () {
                      CustomMethods.launchURL("https://twitter.com/dodactcom");
                    })
              ],
            )
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
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lütfen uygulamayı güncelleyin",
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Platform.isAndroid
                        ? GFIconButton(
                            color: Colors.transparent,
                            icon: Icon(FontAwesome5Brands.google_play,
                                color: Colors.black),
                            onPressed: () {
                              CustomMethods.launchURL(
                                  "https://play.google.com/store/apps/details?id=com.dodact.dodact_v1");
                            })
                        : GFIconButton(
                            color: Colors.transparent,
                            icon: Icon(
                              FontAwesome5Brands.app_store_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              CustomMethods.launchURL(
                                  "https://apps.apple.com/us/app/dodact/id1596151747");
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
