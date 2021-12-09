import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/application_model.dart';

class FirebaseApplicationService {
  Future<List<ApplicationModel>> checkUserApplications(String userId) async {
    List<ApplicationModel> applications = [];

    QuerySnapshot snapshot =
        await applicationsRef.where('applicantId', isEqualTo: userId).get();

    if (snapshot.docs.length > 0) {
      for (DocumentSnapshot application in snapshot.docs) {
        ApplicationModel applicationModel =
            ApplicationModel.fromJson(application.data());
        applications.add(applicationModel);
      }
    }

    return applications;
  }

  Future createApplication(
      String type, String applicantId, Map<String, dynamic> answers) async {
    var application = ApplicationModel(
      applicationType: type,
      applicantId: applicantId,
      answers: answers,
      status: "PENDING",
      applicationDate: DateTime.now(),
    );

    await applicationsRef.add(application.toJson()).then((value) {
      applicationsRef.doc(value.id).update({'applicationId': value.id});
    });
  }

  Future cancelApplication(String userId, String applicationId) async {
    await applicationsRef.doc(applicationId).delete();
  }
}
