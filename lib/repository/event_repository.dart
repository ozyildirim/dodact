import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/firebase_event_service.dart';

enum AppMode { DEBUG, RELEASE }

// class that make us decide for which service provider we want to use

class EventRepository implements BaseService {
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

  @override
  Future<List<EventModel>> getList() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<EventModel>.empty());
    } else {
      return await _firebaseEventService.getList();
    }
  }

  Future<List<EventModel>> getUserEvents(UserObject user) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<EventModel>.empty());
    } else {
      return await _firebaseEventService.getUserEvents(user);
    }
  }

  Future<List<EventModel>> getGroupEvents(GroupModel group) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<EventModel>.empty());
    } else {
      return await _firebaseEventService.getGroupEvents(group);
    }
  }

  @override
  Query getListQuery() {
    // TODO: implement getListQuery
    throw UnimplementedError();
  }

  @override
  Future<void> save(model) async {
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
}
