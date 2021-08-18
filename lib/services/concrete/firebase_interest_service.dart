import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/interest_model.dart';

class FirebaseInterestService {
  Future<List<InterestModel>> getUserInterests(String userId) async {
    List<InterestModel> interests = [];

    QuerySnapshot querySnapshot =
        await usersRef.doc(userId).collection('interests').get();

    for (var interestSnapshot in querySnapshot.docs) {
      interests.add(InterestModel.fromJson(interestSnapshot.data()));
    }
    return interests;
  }

  Future<void> updateUserInterests(
      //tiyatro 0, dans 1, müzik 2, resim 3

      String userId,
      List<InterestModel> interests) async {
    interests.forEach((interest) async {
      await usersRef
          .doc(userId)
          .collection('interests')
          .doc(interest.interestId)
          .set(interest.toMap());
    });
  }
}
