import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/services/concrete/firebase_remote_config_service.dart';
import 'package:dodact_v1/ui/common/screens/enforce_update_page.dart';
import 'package:dodact_v1/ui/common/screens/under_construction_page.dart';
import 'package:dodact_v1/ui/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppStatusContolService {
  AppStatusContolService() {
    _init();
  }

  RemoteConfigService _remoteConfigService;
  PackageInfo packageInfo;

  _init() async {
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();

    if (_remoteConfigService.getUnderConstructionValue) {
      return Future.microtask(
        () => Get.to(UnderConstructionScreen()),
      );
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
                // Get.to(EnforcedUpdateScreen());
              } else {
                // Get.toNamed(k_ROUTE_LANDING);
                return LandingPage();
              }
            }
          });
    }
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
}
