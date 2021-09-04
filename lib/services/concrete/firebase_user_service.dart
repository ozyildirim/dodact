import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';

class FirebaseUserService {
  @override
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<UserObject> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await usersRef.doc(id).get();
    if (documentSnapshot.exists) {
      return UserObject.fromDoc(documentSnapshot);
    }
  }

  @override
  Future<List<UserObject>> getList() async {
    List<UserObject> models = await usersRef.get().then((value) =>
        value.docs.map((e) => UserObject.fromDoc(e.data())).toList());
    return models;
  }

  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<bool> save(UserObject user) async {
    DocumentSnapshot fetchedUser = await usersRef.doc(user.uid).get();

    if (fetchedUser.exists) {
      //do nothing..
      return true;
    } else {
      await usersRef.doc(user.uid).set(user.toMap());
      return true;
    }
  }

  @override
  Future<UserObject> readUser(String userID) async {
    DocumentSnapshot fetchedUser = await usersRef.doc(userID).get();
    UserObject user = UserObject.fromDoc(fetchedUser);

    return user;
  }

  Future<List<UserObject>> getGroupMembers(GroupModel group) async {
    //Get post IDs from user object
    List<String> memberIDs = group.groupMemberList;
    List<UserObject> allGroupMembers = [];

    print("Member IDs from group object:" + memberIDs.toString());
    for (String memberID in memberIDs) {
      DocumentSnapshot documentSnapshot = await usersRef.doc(memberID).get();
      UserObject singleMember = UserObject.fromDoc(documentSnapshot);
      allGroupMembers.add(singleMember);
    }
    return allGroupMembers;
  }
}
