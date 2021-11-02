import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/group_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class GroupProvider extends ChangeNotifier {
  GroupRepository _groupRepository = locator<GroupRepository>();

  GroupModel group;

  List<PostModel> groupPosts;
  List<UserObject> groupMembers;

  List<GroupModel> groupList;
  bool isLoading = false;

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
      groupList[groupList.indexOf(group)] = updatedGroupModel;
    } catch (e) {
      print("GroupProvider updateGroup error: " + e.toString());
      return false;
    }
  }

  Future<List<GroupModel>> getGroupList({bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      var fetchedList = await _groupRepository.getList();
      groupList = fetchedList;
      return groupList;
    } catch (e) {
      print("GroupProvider getList error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<List<GroupModel>> getGroupListByCategory(
    String category,
  ) async {
    try {
      var fetchedGroup = await _groupRepository.getGroupsByCategory(category);
      groupList = fetchedGroup;
      notifyListeners();
      return groupList;
    } catch (e) {
      print("GroupProvider getGroupsByCategory error: " + e.toString());
      notifyListeners();
      return null;
    }
  }

  Future<List<GroupModel>> getFilteredGroupList(
      {String category, String city}) async {
    try {
      var fetchedGroup = await _groupRepository.getFilteredGroupList(
          category: category, city: city);
      groupList = fetchedGroup;
      notifyListeners();
      return groupList;
    } catch (e) {
      print("GroupProvider getGroupsByCategory error: " + e.toString());
      notifyListeners();
      return null;
    }
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

  Future<void> setGroupProfilePicture(
      {PlatformFile file, GroupModel group, bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      // var pictureDownloadURL = await UploadService.uploadImage(
      //     category: 'profile_picture',
      //     file: file,
      //     name: '${group.groupName}_profilePicture');
      // await _groupRepository
      //     .update(group.groupId, {'groupProfilePicture': pictureDownloadURL});
    } catch (e) {
      logger.e("GroupProvider setGroupProfilePicture error: " + e.toString());
    } finally {
      changeState(false);
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
}
