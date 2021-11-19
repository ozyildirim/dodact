import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/application_model.dart';
import 'package:dodact_v1/services/concrete/firebase_application_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ApplicationProvider extends ChangeNotifier {
  var logger = new Logger();

  List<ApplicationModel> userApplications;

  FirebaseApplicationService firebaseApplicationService =
      locator<FirebaseApplicationService>();

  Future getUserApplications(String userId) async {
    try {
      userApplications =
          await firebaseApplicationService.checkUserApplications(userId);
      notifyListeners();
      return userApplications;
    } catch (e) {
      logger.e(e);
    }
  }

  Future createApplication(
      String type, String userId, Map<String, dynamic> answers) async {
    try {
      return await firebaseApplicationService.createApplication(
          type, userId, answers);
    } catch (e) {
      logger.e(e);
    }
  }

  Future cancelApplication(String userId, String applicationId) async {
    try {
      return await firebaseApplicationService.cancelApplication(
          userId, applicationId);
    } catch (e) {
      logger.e(e);
    }
  }
}
