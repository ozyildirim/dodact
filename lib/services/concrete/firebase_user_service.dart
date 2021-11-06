import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserService {
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  Future<UserObject> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await usersRef.doc(id).get();
    if (documentSnapshot.exists) {
      return UserObject.fromDoc(documentSnapshot);
    }
  }

  Future<List<UserObject>> getList() async {
    List<UserObject> models = await usersRef.get().then((value) =>
        value.docs.map((e) => UserObject.fromDoc(e.data())).toList());
    return models;
  }

  Query getListQuery() {
    throw UnimplementedError();
  }

  Future<bool> save(User user) async {
    DocumentSnapshot fetchedUser = await usersRef.doc(user.uid).get();

    if (fetchedUser.exists) {
      //do nothing..
      return true;
    } else {
      //Creates new user in DB if there is not
      UserObject userObject = UserObject(uid: user.uid, email: user.email);
      await usersRef.doc(user.uid).set(userObject.toMap());
      return true;
    }
  }

  Future<UserObject> getUserFromDb(String userID) async {
    DocumentSnapshot fetchedUser = await usersRef.doc(userID).get();
    UserObject user = UserObject.fromDoc(fetchedUser);

    return user;
  }

  Future<List<UserObject>> getGroupMembers(String groupId) async {
    //Get post IDs from user object
    var snapshot = await groupsRef.doc(groupId).get();
    GroupModel group = GroupModel.fromJson(snapshot.data());

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

  Future<void> updateCurrentUser(
      Map<String, dynamic> newData, String uid) async {
    await usersRef.doc(uid).update(newData);
  }
}
