import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/request_model.dart';

class FirebaseRequestService {
  Future<void> addRequest(RequestModel request) async {
    var requestMapObject = request.toMap();
    await requestsRef.add(requestMapObject).then((requestResponse) async {
      await requestsRef
          .doc(requestResponse.id)
          .update({'requestId': requestResponse.id});
    });
  }

  Future<List<RequestModel>> getUserRequests(String ownerId) async {
    List<RequestModel> userRequests = [];

    QuerySnapshot querySnapshot =
        await requestsRef.where('requestOwnerId', isEqualTo: ownerId).get();

    for (DocumentSnapshot request in querySnapshot.docs) {
      RequestModel convertedRequest = RequestModel.fromMap(request.data());
      userRequests.add(convertedRequest);
    }
    return userRequests;
  }

  Future<void> deleteRequest(String postId) async {
    var querySnapshot =
        await requestsRef.where('subjectId', isEqualTo: postId).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
