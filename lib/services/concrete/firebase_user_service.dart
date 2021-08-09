import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
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
    await usersRef.doc(user.uid).set(user.toMap());

    DocumentSnapshot _fetchedUser =
        await FirebaseFirestore.instance.doc('users/${user.uid}').get();

    Map _fetchedUserMap = _fetchedUser.data();
    UserObject _fetchedUserObject = UserObject.fromMap(_fetchedUserMap);

    print("User data fetched after save: " + _fetchedUserObject.toString());

    return true;
  }

  @override
  Future<UserObject> readUser(String userID) async {
    DocumentSnapshot _fetchedUser = await usersRef.doc(userID).get();

    UserObject _fetchedUserObject = UserObject.fromDoc(_fetchedUser);
    print(_fetchedUserObject.toString());
    return _fetchedUserObject;
  }
}
