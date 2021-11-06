import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/dodcoin_model.dart';

class FirebaseDodcoinService {
  Future<DodcoinModel> getUserDodcoinData(String userId) async {
    var result = await dodcoinsRef.doc(userId).get();
    return DodcoinModel.fromJson(result.data());
  }

  Future getUserDodcoinHistory(String userId) async {
    var result = await dodcoinsRef.doc(userId).collection('history').get();
    return result.docs;
  }
}
