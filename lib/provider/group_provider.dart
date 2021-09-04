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
  List<EventModel> groupEvents;

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

  Future<bool> updateGroup(String groupId, Map<String, dynamic> changes,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await _groupRepository
          .update(groupId, changes)
          .then((value) => true);
    } catch (e) {
      print("GroupProvider updateGroup error: " + e.toString());
      return false;
    } finally {
      changeState(false);
    }
  }

  Future editGroupPostList(
      String postId, String groupId, bool addOrRemove) async {
    try {
      await _groupRepository.editGroupPostList(postId, groupId, addOrRemove);
    } catch (e) {
      print("GroupProvider editGroupPostDetail error: " + e.toString());
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
      {String category = "Tümü",
      String city = "İstanbul",
      bool showAllCategories = true,
      bool wholeCountry = false}) async {
    try {
      var fetchedGroup = await _groupRepository.getFilteredGroupList(
          category: category,
          city: city,
          showAllCategories: showAllCategories,
          wholeCountry: wholeCountry);
      groupList = fetchedGroup;
      notifyListeners();
      return groupList;
    } catch (e) {
      print("GroupProvider getGroupsByCategory error: " + e.toString());
      notifyListeners();
      return null;
    }
  }

  Future<GroupModel> getGroupDetail(String groupId, {bool isNotify}) async {
    try {
      var fetchedGroup = await _groupRepository.getDetail(groupId);
      group = fetchedGroup;
      notifyListeners();
      return group;
    } catch (e) {
      print("GroupProvider getDetail error: " + e.toString());
      notifyListeners();
      return null;
    }
  }

  Future<void> getGroupPosts(GroupModel group) async {
    try {
      groupPosts = await _groupRepository.getGroupPosts(group);
      notifyListeners();
    } catch (e) {
      logger.e("GroupProvider getGroupPosts error: " + e.toString());
      return null;
    }
  }

  Future<void> getGroupEvents(GroupModel group) async {
    try {
      groupEvents = await _groupRepository.getGroupEvents(group);
      notifyListeners();
    } catch (e) {
      logger.e("GroupProvider getGroupEvents error: " + e.toString());
      return null;
    }
  }

  Future<void> getGroupMembers(GroupModel group) async {
    try {
      groupMembers = await _groupRepository.getGroupMembers(group);
      notifyListeners();
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
      print("GroupProvider setGroupProfilePicture error: " + e.toString());
    } finally {
      changeState(false);
    }
  }

  Future<bool> addGroupMember(String userID, String groupID,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      var result = await _groupRepository.addGroupMember(userID, groupID);
      if (result != false) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("GroupProvider addGroupMember error: " + e.toString());
      return false;
    } finally {
      changeState(false);
    }
  }

  Future<void> editGroupEventList(
      String eventId, String groupId, bool addOrRemove) async {
    try {
      await _groupRepository.editGroupEventList(eventId, groupId, addOrRemove);
    } catch (e) {}
  }
}
