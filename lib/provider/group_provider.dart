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
  List<GroupModel> userGroupList;

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
      String city = "Belirtilmemiş",
      bool showAllCategories = true,
      bool wholeCountry = true}) async {
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

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      userGroupList = await _groupRepository.getUserGroups(userId);
      notifyListeners();
      Logger().d(userGroupList);
      return userGroupList;
    } catch (e) {
      logger.e("GroupProvider getUserGroups error: " + e.toString());
      return null;
    }
  }

  Future<GroupModel> getGroupDetail(String groupId, {bool isNotify}) async {
    try {
      var fetchedGroup = await _groupRepository.getDetail(groupId);
      group = fetchedGroup;
      notifyListeners();
      return fetchedGroup;
    } catch (e) {
      print("GroupProvider getDetail error: " + e.toString());
      notifyListeners();
      return null;
    }
  }

  Future<void> getGroupPosts(String groupId) async {
    try {
      groupPosts = await _groupRepository.getGroupPosts(groupId);
      notifyListeners();
    } catch (e) {
      logger.e("GroupProvider getGroupPosts error: " + e.toString());
      return null;
    }
  }

  Future<void> getGroupEvents(String groupId) async {
    try {
      groupEvents = await _groupRepository.getGroupEvents(groupId);
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

  // Future<bool> addGroupMember(String userID, String groupID,
  //     {bool isNotify}) async {
  //   try {
  //     changeState(true, isNotify: isNotify);
  //     var result = await _groupRepository.addGroupMember(userID, groupID);
  //     if (result != false) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print("GroupProvider addGroupMember error: " + e.toString());
  //     return false;
  //   } finally {
  //     changeState(false);
  //   }
  // }

}
