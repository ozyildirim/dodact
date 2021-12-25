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
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';

enum AppMode { DEBUG, RELEASE }

class GroupRepository {
  FirebasePostService _firebasePostService = locator<FirebasePostService>();
  FirebaseGroupService _firebaseGroupService = locator<FirebaseGroupService>();
  FirebaseEventService _firebaseEventService = locator<FirebaseEventService>();
  FirebaseUserService _firebaseUserService = locator<FirebaseUserService>();

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

  Future getGroupList({int limit, DocumentSnapshot startAfter}) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getGroupList(
          limit: limit, startAfter: startAfter);
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

  Future<List<PostModel>> getGroupPosts(String groupId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebasePostService.getGroupPosts(groupId);
    }
  }

  Future<List<EventModel>> getGroupEvents(String groupId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseEventService.getGroupEvents(groupId);
    }
  }

  Future<List<UserObject>> getGroupMembers(String groupId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    }
    return await _firebaseUserService.getGroupMembers(groupId);
  }

  Future<bool> addGroupMember(String userID, String groupID) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.addGroupMember(userID, groupID);
    }
  }

  Future<void> removeGroupMember(String userID, String groupID) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await _firebaseGroupService.removeGroupMember(userID, groupID);
    }
  }

  Future getFilteredGroupList(
      {List<String> category,
      String city,
      int limit,
      DocumentSnapshot startAfter}) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getFilteredGroupList(
          category: category, city: city, limit: limit, startAfter: startAfter);
    }
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebaseGroupService.getUserGroups(userId);
    }
  }

  Future<void> deleteGroupPost(String postId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await _firebasePostService.delete(postId);
    }
  }

  Future<void> deleteGroupEvent(String eventId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await _firebaseEventService.delete(eventId);
    }
  }

  Future setGroupManager(String userId, String groupId) {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return _firebaseGroupService.setGroupManager(userId, groupId);
    }
  }
}
