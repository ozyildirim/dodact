import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
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
    // TODO: implement getListQuery
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

  Future<List<UserObject>> getGroupMembers(GroupModel group) async {
    //Get post IDs from user object
    List<dynamic> memberIDs = group.groupMemberList;
    List<UserObject> allGroupMembers = [];

    print("Member IDs from group object:" + memberIDs.toString());
    for (dynamic member in memberIDs) {
      DocumentSnapshot documentSnapshot =
          await usersRef.doc(member.toString()).get();
      UserObject singleMember = UserObject.fromMap(documentSnapshot.data());
      allGroupMembers.add(singleMember);
    }
    return allGroupMembers;
  }

  // TODO: addGroupMember fonksiyonunun doğruluğunu sor.
  Future<bool> addGroupMember(String userID, String groupID) async {
    QuerySnapshot check = await groupsRef
        .where('groupMemberList', arrayContains: userID) //?
        .where('groupId', isEqualTo: groupID)
        .get();

    if (check.docs.isEmpty) {
      GroupModel group = await getDetail(groupID);
      group.groupMemberList.add(userID);
      await update(groupID, group.toJson());

      UserObject user = await _firebaseUserService.readUser(userID);
      user.groupIDs.add(groupID);
      await usersRef.doc(userID).update(user.toMap());

      return true;
      //User added to group
    } else {
      return false;
      //Same user exists in same group
    }
  }

  Future<bool> removeGroupMember(String userID, String groupID) async {
    GroupModel group = await getDetail(groupID);
    group.groupMemberList.remove(userID);
    await update(groupID, group.toJson());

    UserObject user = await _firebaseUserService.readUser(userID);
    user.groupIDs.remove(groupID);
    await usersRef.doc(userID).update(user.toMap());

    return true;
  }
}
