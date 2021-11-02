import 'package:dodact_v1/config/constants/firebase_constants.dart';

class CustomValidators {
  static Future<bool> isUsernameAvailable(String text) async {
    var result = await usersRef.where('username', isEqualTo: text).get();

    if (result.docs.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
