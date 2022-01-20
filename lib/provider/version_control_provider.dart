import 'package:dodact_v1/config/constants/route_constants.dart';
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
  }

  Future<bool> checkEnforcedVersion() async {
    // return Future.value(false);
    packageInfo = await PackageInfo.fromPlatform();

    double currentVersion =
        double.parse(packageInfo.version.trim().replaceAll(".", ""));

    double enforcedVersion = double.parse(_remoteConfigService
        .getEnforcedVersionValue
        .trim()
        .replaceAll(".", ""));
    print(currentVersion);
    print(enforcedVersion);

    if (enforcedVersion > currentVersion) return true;
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
          // Get.off(() => LandingPage());
          Get.offNamedUntil(k_ROUTE_LANDING, (route) => false);
          // return LandingPage();
        }
      }
    }
  }
}
