import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/contribution_model.dart';

class FirebaseContributionService {
  Future createContribution(ContributionModel contribution) async {
    await contributionsRef.add(contribution.toJson()).then((value) async {
      await contributionsRef.doc(value.id).update(
        {'contributionId': value.id},
      );
    });
  }

  Future<List<ContributionModel>> getUserContributions(String userId) async {
    List<ContributionModel> contributions = [];

    QuerySnapshot querySnapshot = await contributionsRef
        .where('contributorAccountType', isEqualTo: "User")
        .where('contributorId', isEqualTo: userId)
        .get();

    for (DocumentSnapshot contribution in querySnapshot.docs) {
      ContributionModel contributionModel =
          ContributionModel.fromJson(contribution.data());
      contributions.add(contributionModel);
    }
    return contributions;
  }

  Future<List<ContributionModel>> getGroupContributions() async {}
}
