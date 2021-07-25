import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/request_model.dart';
import 'package:dodact_v1/services/concrete/firebase_request_service.dart';
import 'package:flutter/cupertino.dart';

class RequestProvider extends ChangeNotifier {
  FirebaseRequestService firebaseRequestService =
      locator<FirebaseRequestService>();

  RequestModel request;
  List<RequestModel> requests;

  Future<void> addRequest(RequestModel request) async {
    try {
      await firebaseRequestService.addRequest(request);
      requests.add(request);
      notifyListeners();
    } catch (e) {
      print("RequestProvider addRequest error: " + e.toString());
    }
  }

  Future<void> getUserRequests(String ownerId) async {
    try {
      requests = await firebaseRequestService.getUserRequests(ownerId);
      notifyListeners();
    } catch (e) {
      print("RequestProvider getUserRequests error: " + e.toString());
    }
  }
}
