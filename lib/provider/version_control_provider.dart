import 'package:dodact_v1/services/concrete/firebase_remote_config_service.dart';
import 'package:dodact_v1/ui/common/screens/enforce_update_page.dart';
import 'package:dodact_v1/ui/common/screens/under_construction_page.dart';
import 'package:dodact_v1/ui/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionControlProvider with ChangeNotifier {
  RemoteConfigService _remoteConfigService;
  PackageInfo packageInfo;
  bool isLoading;
  bool isRemoteConfigInitialized = false;

  initializeRemoteConfig() async {
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    isRemoteConfigInitialized = true;
    print("remote config initialized");
    print(_remoteConfigService.getEnforcedVersionValue);
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

  Future checkAppStatus() async {
    await initializeRemoteConfig();

    if (isRemoteConfigInitialized) {
      if (_remoteConfigService.getUnderConstructionValue) {
        print("under construction gidiliyor");
        Get.off(() => UnderConstructionScreen());
      } else {
        var versionControlResult = await checkEnforcedVersion();

        if (versionControlResult) {
          Get.off(() => EnforcedUpdateScreen());
        } else {
          Get.off(() => LandingPage());
        }
      }
    }
  }
}
