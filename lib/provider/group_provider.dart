import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/group_repository.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class GroupProvider extends ChangeNotifier {
  GroupRepository _groupRepository = locator<GroupRepository>();

  GroupModel group;

  List<PostModel> groupPosts;
  List<UserObject> groupMembers;

  List<GroupModel> groupList;
  bool isLoading = false;

  final groupsSnapshot = <DocumentSnapshot>[];
  final filteredGroupsSnapshot = <DocumentSnapshot>[];
  String errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _hasNextFiltered = true;
  bool _isFetchingGroups = false;
  bool _isFetchingFilteredGroups = false;

  bool get hasNext => _hasNext;

  bool get hasNextFiltered => _hasNextFiltered;

  List<GroupModel> get groups =>
      groupsSnapshot.map((e) => GroupModel.fromJson(e.data())).toList();

  List<GroupModel> get filteredGroups =>
      filteredGroupsSnapshot.map((e) => GroupModel.fromJson(e.data())).toList();

  var logger = new Logger();

  changeState(bool _isLoading, {bool isNotify}) {
    isLoading = _isLoading;
    if (isNotify != null) {
      if (isNotify) {
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

  clear() {
    group = null;
    groupList.clear();
  }

  setGroup(GroupModel group) {
    this.group = group;
  }

  Future addGroup({GroupModel model, bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await _groupRepository.save(model);
    } catch (e) {
      print("GroupProvider addGroup error: " + e.toString());
    } finally {
      changeState(false);
    }
  } //add group

  Future<bool> deleteGroup(String groupId, {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await _groupRepository.delete(groupId).then((value) => true);
    } catch (e) {
      print("GroupProvider deleteGroup error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future updateGroup(String groupId, Map<String, dynamic> changes) async {
    try {
      await _groupRepository.update(groupId, changes);
      var updatedGroupModel = await getGroupDetail(groupId);
      group = updatedGroupModel;
      notifyListeners();
    } catch (e) {
      print("GroupProvider updateGroup error: " + e.toString());
      return false;
    }
  }

  Future getGroupList() async {
    if (_isFetchingGroups) return;
    errorMessage = '';
    _isFetchingGroups = true;
    try {
      var snap = await _groupRepository.getGroupList(
          limit: documentLimit,
          startAfter: groupsSnapshot.isNotEmpty ? groupsSnapshot.last : null);

      groupsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (e) {
      logger.e("GroupProvider getGroupList error: " + e.toString());
      notifyListeners();
      return null;
    }
    _isFetchingGroups = false;
  }

  Future getFilteredGroupList({
    bool reset,
    String category,
    String city,
  }) async {
    if (reset) {
      print("reset");
      filteredGroupsSnapshot.clear();
      _hasNextFiltered = true;
    }

    if (_isFetchingFilteredGroups) return;
    errorMessage = '';
    _isFetchingFilteredGroups = true;

    try {
      print("reset yok");
      var snap = await _groupRepository.getFilteredGroupList(
        category: category,
        city: city,
        limit: documentLimit,
        startAfter: filteredGroupsSnapshot.isNotEmpty
            ? filteredGroupsSnapshot.last
            : null,
      );

      filteredGroupsSnapshot.addAll(snap.docs);
      print(snap.docs);
      if (snap.docs.length < documentLimit) _hasNextFiltered = false;
      notifyListeners();
    } catch (e) {
      logger.e("GroupProvider getFilteredGroupList error: " + e.toString());
      notifyListeners();
      return null;
    }
    _isFetchingFilteredGroups = false;
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      return await _groupRepository.getUserGroups(userId);
    } catch (e) {
      logger.e("GroupProvider getUserGroups error: " + e.toString());
      return null;
    }
  }

  Future<GroupModel> getGroupDetail(String groupId, {bool isNotify}) async {
    try {
      var fetchedGroup = await _groupRepository.getDetail(groupId);
      group = fetchedGroup;
      //TODO: grup güncellemelerini düzenle
      notifyListeners();
      return fetchedGroup;
    } catch (e) {
      print("GroupProvider getDetail error: " + e.toString());
      notifyListeners();
      return null;
    }
  }

  Future<List<PostModel>> getGroupPosts(String groupId) async {
    try {
      return await _groupRepository.getGroupPosts(groupId);
    } catch (e) {
      logger.e("GroupProvider getGroupPosts error: " + e.toString());
      return null;
    }
  }

  Future<List<EventModel>> getGroupEvents(String groupId) async {
    try {
      return await _groupRepository.getGroupEvents(groupId);
      // notifyListeners();

    } catch (e) {
      logger.e("GroupProvider getGroupEvents error: " + e.toString());
      return null;
    }
  }

  Future<void> getGroupMembers(String groupId) async {
    try {
      return await _groupRepository.getGroupMembers(groupId);
    } catch (e) {
      logger.e("GroupProvider getGroupMembers error: " + e.toString());
      return null;
    }
  }

  Future<bool> addGroupMember(
    String userID,
    String groupID,
  ) async {
    try {
      if (group.groupMemberList.contains(userID)) {
        return false;
      } else {
        await _groupRepository.addGroupMember(userID, groupID);
        group.groupMemberList.add(userID);
        notifyListeners();
        return true;
      }
    } catch (e) {
      logger.e("GroupProvider addGroupMember error: " + e.toString());
      return false;
    }
  }

  Future<void> removeGroupMember(String userID, String groupID) async {
    try {
      await _groupRepository.removeGroupMember(userID, groupID);
    } catch (e) {
      logger.e("GroupProvider removeGroupMember error: " + e.toString());
    }
  }

  Future<void> deleteGroupPost(String postId) async {
    try {
      await _groupRepository.deleteGroupPost(postId);
      groupPosts.removeWhere((post) => post.postId == postId);
      notifyListeners();
    } catch (e) {
      logger.e("GroupProvider deleteGroupPost error: " + e.toString());
    }
  }

  Future<void> deleteGroupEvent(String eventId) async {
    try {
      await _groupRepository.deleteGroupEvent(eventId);
    } catch (e) {
      logger.e("GroupProvider deleteGroupPost error: " + e.toString());
    }
  }

  Future setGroupManager(String userId, String groupId) {
    try {
      return _groupRepository.setGroupManager(userId, groupId);
    } catch (e) {
      logger.e("GroupProvider setGroupManager error: " + e.toString());
      return null;
    }
  }

  Future removeGroupMedia(String url, String groupId) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteGroupMedia');
      HttpsCallableResult result =
          await callable.call(<String, dynamic>{'url': url});

      if (result.data['result'] == true) {
        await updateGroup(groupId, {
          'groupMedia': FieldValue.arrayRemove([url]),
        });
        group.groupMedia.remove(url);
      } else {
        logger.e("GroupProvider removeGroupMedia error: " + result.toString());
      }
    } catch (e) {
      logger.e("GroupProvider removeGroupMedia error: " + e.toString());
    }
  }

  Future addGroupMedia(PickedFile file, String groupId) async {
    try {
      var url = await UploadService()
          .uploadGroupMedia(groupId: groupId, fileToUpload: File(file.path));
      await updateGroup(groupId, {
        'groupMedia': FieldValue.arrayUnion([url]),
      });
    } catch (e) {
      logger.e("GroupProvider addGroupMedia error: " + e.toString());
    }
  }
}
