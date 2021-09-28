import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

const String UNDER_CONSTRUCTION_VALUE = 'under_construction';
const String _INT_VALUE = 'sample_int_value';
const String ENFORCED_VERSION_VALUE = 'enforced_version';

class RemoteConfigService {
  final RemoteConfig _remoteConfig;
  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  final defaults = <String, dynamic>{
    UNDER_CONSTRUCTION_VALUE: true,
    _INT_VALUE: 01,
    ENFORCED_VERSION_VALUE: "Flutter Firebase",
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
  String get getEnforcedVersionValue =>
      _remoteConfig.getString(ENFORCED_VERSION_VALUE);

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
    print("boolean::: $getUnderConstructionValue");
    print("int::: $getIntValue");
    print("string::: $getEnforcedVersionValue");
  }
}
