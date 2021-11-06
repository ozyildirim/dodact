import 'package:dodact_v1/model/contribution_model.dart';
import 'package:dodact_v1/services/concrete/firebase_contribution_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ContributionProvider extends ChangeNotifier {
  FirebaseContributionService firebaseContributionService =
      FirebaseContributionService();
  Logger logger = Logger();

  List<ContributionModel> allContributions;
  List<ContributionModel> contributions;

  Future createPostContribution(String contributorId, String objectId,
      String contributedCompany, String contributorAccountType) async {
    try {
      var contribution = ContributionModel(
          contributorId: contributorId,
          objectId: objectId,
          contributorAccountType: contributorAccountType,
          objectType: "Post",
          creationDate: DateTime.now(),
          contributedCompany: contributedCompany);

      await firebaseContributionService.createContribution(contribution);
    } catch (e) {
      debugPrint("ContributionProvider error: $e");
    }
  }

  Future createEventContribution(String contributorId, String objectId,
      String contributedCompany, String contributorAccountType) async {
    try {
      var contribution = ContributionModel(
          contributorId: contributorId,
          objectId: objectId,
          objectType: "Event",
          creationDate: DateTime.now(),
          contributorAccountType: contributorAccountType,
          contributedCompany: contributedCompany);

      await firebaseContributionService.createContribution(contribution);
    } catch (e) {
      debugPrint("ContributionProvider error: $e");
    }
  }

  Future<void> getUserContributions(String userId) async {
    try {
      contributions =
          await firebaseContributionService.getUserContributions(userId);
      notifyListeners();
    } catch (e) {
      logger.e("Contribution Provider -> getUserContributions error: $e");
    }
  }

  Future<List<ContributionModel>> getContributions() async {
    try {
      allContributions = await firebaseContributionService.getContributions();
      notifyListeners();
      return allContributions;
    } catch (e) {
      logger.e("Contribution Provider -> getContributions error: $e");
      return null;
    }
  }
}
