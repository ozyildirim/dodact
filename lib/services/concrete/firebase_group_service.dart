import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';

class FirebaseGroupService extends BaseService<GroupModel> {
  FirebaseUserService _firebaseUserService = locator<FirebaseUserService>();

  @override
  Future<void> delete(String id) async {
    return await groupsRef.doc(id).delete();
  }

  @override
  Future<GroupModel> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await groupsRef.doc(id).get();
    GroupModel group = GroupModel.fromJson(documentSnapshot.data());
    return group;
  }

  @override
  Future<List<GroupModel>> getList() async {
    List<GroupModel> allGroups = [];

    QuerySnapshot querySnapshot = await groupsRef.orderBy('creationDate').get();
    for (DocumentSnapshot group in querySnapshot.docs) {
      GroupModel _group = GroupModel.fromJson(group.data());
      allGroups.add(_group);
    }
    return allGroups;
  }

  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<void> save(GroupModel model) async {
    if (model.groupId == null || model.groupId.isEmpty) {
      return await groupsRef.add(model.toJson()).then((value) async =>
          await groupsRef.doc(value.id).update({'groupID': value.id}));
    }
    return await groupsRef.doc(model.groupId).set(model.toJson());
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    return await groupsRef.doc(id).update(changes);
  }

  // // TODO: addGroupMember fonksiyonunun doğruluğunu sor.
  // Future<bool> addGroupMember(String userID, String groupID) async {
  //   QuerySnapshot check = await groupsRef
  //       .where('groupMemberList', arrayContains: userID) //?
  //       .where('groupId', isEqualTo: groupID)
  //       .get();

  //   if (check.docs.isEmpty) {
  //     GroupModel group = await getDetail(groupID);
  //     group.groupMemberList.add(userID);
  //     await update(groupID, group.toJson());

  //     UserObject user = await _firebaseUserService.readUser(userID);
  //     user.groupIDs.add(groupID);
  //     await usersRef.doc(userID).update(user.toMap());

  //     return true;
  //     //User added to group
  //   } else {
  //     return false;
  //     //Same user exists in same group
  //   }
  // }

  Future<bool> removeGroupMember(String userID, String groupID) async {
    GroupModel group = await getDetail(groupID);
    group.groupMemberList.remove(userID);
    await update(groupID, group.toJson());

    return true;
  }

  Future<List<GroupModel>> getGroupsByCategory(String category) async {
    List<GroupModel> categorizedGroups = [];

    QuerySnapshot querySnapshot =
        await groupsRef.where("groupCategory", isEqualTo: category).get();
    for (DocumentSnapshot group in querySnapshot.docs) {
      GroupModel _group = GroupModel.fromJson(group.data());
      categorizedGroups.add(_group);
    }
    return categorizedGroups;
  }

  Future<List<GroupModel>> getFilteredGroupList(
      {String category = "Müzik",
      String city = "İstanbul",
      bool showAllCategories = false,
      bool wholeCountry = false}) async {
    List<GroupModel> filteredGroups = [];
    QuerySnapshot querySnapshot;

    if (showAllCategories && wholeCountry) {
      querySnapshot = await groupsRef.get();
    } else if (showAllCategories && wholeCountry == false) {
      querySnapshot =
          await groupsRef.where("groupLocation", isEqualTo: city).get();
    } else if (showAllCategories == false && wholeCountry) {
      querySnapshot =
          await groupsRef.where("groupCategory", isEqualTo: category).get();
    } else {
      querySnapshot = await groupsRef
          .where("groupCategory", isEqualTo: category)
          .where("groupLocation", isEqualTo: city)
          .get();
    }

    for (DocumentSnapshot group in querySnapshot.docs) {
      GroupModel _group = GroupModel.fromJson(group.data());
      filteredGroups.add(_group);
    }
    return filteredGroups;
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    List<GroupModel> userGroups = [];

    QuerySnapshot querySnapshot =
        await groupsRef.where("groupMemberList", arrayContains: userId).get();
    for (DocumentSnapshot group in querySnapshot.docs) {
      GroupModel groupObject = GroupModel.fromJson(group.data());

      userGroups.add(groupObject);
    }
    return userGroups;
  }
}
