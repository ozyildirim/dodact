import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/firebase_event_service.dart';
import 'package:dodact_v1/services/concrete/firebase_group_service.dart';
import 'package:dodact_v1/services/concrete/firebase_post_service.dart';

enum AppMode { DEBUG, RELEASE }

class GroupRepository implements BaseService {
  FirebasePostService _firebasePostService = locator<FirebasePostService>();
  FirebaseGroupService _firebaseGroupService = locator<FirebaseGroupService>();
  FirebaseEventService _firebaseEventService = locator<FirebaseEventService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<void> delete(String id) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.delete(id);
    }
  }

  @override
  Future getDetail(String id) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getDetail(id);
    }
  }

  @override
  Future<List> getList() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getList();
    }
  }

  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<void> save(model) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.save(model);
    }
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.update(id, changes);
    }
  }

  Future<List<PostModel>> getGroupPosts(GroupModel group) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebasePostService.getGroupPosts(group);
    }
  }

  Future<List<EventModel>> getGroupEvents(GroupModel group) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseEventService.getGroupEvents(group);
    }
  }

  Future<List<UserObject>> getGroupMembers(GroupModel group) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getGroupMembers(group);
    }
  }

  Future<bool> addGroupMember(String userID, String groupID) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.addGroupMember(userID, groupID);
    }
  }

  Future<List<GroupModel>> getGroupsByCategory(String category) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getGroupsByCategory(category);
    }
  }

  Future<List<GroupModel>> getFilteredGroupList(
      {String category = "Müzik",
      String city = "İstanbul",
      bool showAllCategories = false,
      bool wholeCountry = false}) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getFilteredGroupList(
          category: category,
          city: city,
          showAllCategories: showAllCategories,
          wholeCountry: wholeCountry);
    }
  }
}
