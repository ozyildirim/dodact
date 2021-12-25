import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';
import 'package:logger/logger.dart';

class FirebaseGroupService {
  FirebaseUserService _firebaseUserService = locator<FirebaseUserService>();

  Future<void> delete(String id) async {
    return await groupsRef.doc(id).delete();
  }

  Future<GroupModel> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await groupsRef.doc(id).get();
    GroupModel group = GroupModel.fromJson(documentSnapshot.data());
    return group;
  }

  Future getGroupList({int limit, DocumentSnapshot startAfter}) async {
    Query query = groupsRef.limit(limit);

    if (startAfter == null) {
      return query.where('visible', isEqualTo: true).get();
    }
    return query.startAfterDocument(startAfter).get();
  }

  Query getListQuery() {
    throw UnimplementedError();
  }

  Future<void> save(GroupModel model) async {
    if (model.groupId == null || model.groupId.isEmpty) {
      return await groupsRef.add(model.toJson()).then((value) async =>
          await groupsRef.doc(value.id).update({'groupID': value.id}));
    }
    return await groupsRef.doc(model.groupId).set(model.toJson());
  }

  Future<void> update(String id, Map<String, dynamic> changes) async {
    return await groupsRef.doc(id).update(changes);
  }

  // TODO: addGroupMember fonksiyonunun doğruluğunu sor.
  Future<bool> addGroupMember(String userID, String groupID) async {
    GroupModel group = await getDetail(groupID);
    group.groupMemberList.add(userID);
    await update(groupID, group.toJson()).then((value) {
      return true;
    });
    return false;
    //User added to group
  }

  Future<void> removeGroupMember(String userID, String groupID) async {
    await groupsRef.doc(groupID).update({
      'groupMemberList': FieldValue.arrayRemove([userID])
    });
    Logger().d("Topluluk üyesi silindi");
  }

  Future getFilteredGroupList(
      {List<String> category,
      String city,
      int limit,
      DocumentSnapshot startAfter}) async {
    Query query;

    if (category != null && city != null) {
      query = groupsRef
          .where("selectedInterests", arrayContainsAny: category)
          .where("groupLocation", isEqualTo: city);
    } else if (category != null) {
      query = groupsRef.where("selectedInterests", arrayContainsAny: category);
    } else if (city != null) {
      query = groupsRef.where("groupLocation", isEqualTo: city);
    } else {
      query = groupsRef;
    }

    if (startAfter == null) {
      return query.where('visible', isEqualTo: true).limit(limit).get();
    } else {
      return query
          .where('visible', isEqualTo: true)
          .limit(limit)
          .startAfterDocument(startAfter)
          .get();
    }
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    List<GroupModel> userGroups = [];

    QuerySnapshot querySnapshot = await groupsRef
        .where("groupMemberList", arrayContains: userId)
        .where('visible', isEqualTo: true)
        .get();
    for (DocumentSnapshot group in querySnapshot.docs) {
      GroupModel groupObject = GroupModel.fromJson(group.data());

      userGroups.add(groupObject);
    }
    return userGroups;
  }

  Future setGroupManager(String userId, String groupId) {
    return groupsRef.doc(groupId).update({
      'managerId': userId,
    });
  }
}
