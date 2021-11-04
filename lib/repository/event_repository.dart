import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/firebase_event_service.dart';

enum AppMode { DEBUG, RELEASE }

// class that make us decide for which service provider we want to use

class EventRepository {
  FirebaseEventService _firebaseEventService = locator<FirebaseEventService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<void> delete(String id) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseEventService.delete(id).then((value) => true);
    }
  }

  @override
  Future<EventModel> getDetail(String id) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseEventService.getDetail(id);
    }
  }

  Future getList(int limit, DocumentSnapshot startAfter) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<EventModel>.empty());
    } else {
      return await _firebaseEventService.getList(limit, startAfter);
    }
  }

  Future<List<EventModel>> getUserEvents(UserObject user) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<EventModel>.empty());
    } else {
      return await _firebaseEventService.getUserEvents(user);
    }
  }

  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<String> save(model) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseEventService.save(model);
    }
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(true);
    } else {
      return await _firebaseEventService.update(id, changes);
    }
  }

  Future<QuerySnapshot> getEventList(
      {int limit, DocumentSnapshot startAfter}) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseEventService.getEventList(
        limit: limit,
        startAfter: startAfter,
      );
    }
  }

  Future<QuerySnapshot> getFilteredEventList(
      {String category,
      String city,
      String type,
      int limit,
      DocumentSnapshot startAfter}) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      var snapshot = await _firebaseEventService.getFilteredEventList(
        category: category,
        city: city,
        type: type,
        limit: limit,
        startAfter: startAfter,
      );
      print(snapshot);
      return snapshot;
    }
  }

  Future<List<EventModel>> getSpecialEvents() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    }
    return await _firebaseEventService.getSpecialEvents();
  }
}
