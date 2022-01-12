import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

const String UNDER_CONSTRUCTION_VALUE = 'under_construction';
const String _INT_VALUE = 'sample_int_value';
const String ENFORCED_VERSION_VALUE_IOS = 'enforced_version_ios';
const String ENFORCED_VERSION_VALUE_ANDROID = 'enforced_version_android';
const String UNIQUE_CODE = 'unique_access_code';

class RemoteConfigService {
  final RemoteConfig _remoteConfig;
  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  final defaults = <String, dynamic>{
    UNDER_CONSTRUCTION_VALUE: true,
    _INT_VALUE: 01,
    ENFORCED_VERSION_VALUE_IOS: "0.0.4",
    ENFORCED_VERSION_VALUE_ANDROID: "0.0.4",
    UNIQUE_CODE: "Flutter Firebase",
  };

  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: await RemoteConfig.instance,
      );
    }
    return _instance;
  }

  bool get getUnderConstructionValue =>
      _remoteConfig.getBool(UNDER_CONSTRUCTION_VALUE);
  int get getIntValue => _remoteConfig.getInt(_INT_VALUE);
  String get getEnforcedVersionValue {
    if (Platform.isIOS) {
      return _remoteConfig.getString(ENFORCED_VERSION_VALUE_IOS);
    } else {
      return _remoteConfig.getString(ENFORCED_VERSION_VALUE_ANDROID);
    }
  }

  String get getUniqueCode => _remoteConfig.getString(UNIQUE_CODE);

  Future initialize() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FirebaseException catch (e) {
      print("Rmeote Config fetch throttled: $e");
    } catch (e) {
      print("Unable to fetch remote config. Default value will be used");
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 0),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.fetchAndActivate();
    // print("boolean::: $getUnderConstructionValue");
    // print("int::: $getIntValue");
    // print("string::: $getEnforcedVersionValue");
  }
}
