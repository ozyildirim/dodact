import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/abstract/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "1234567";
  String email = "kutay@dodact.com";

  @override
  Future<UserObject> currentUser() async {
    return await Future.value(UserObject(uid: userID, email: email));
  }

  @override
  Future<UserObject> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserObject(uid: userID, email: "kutay@anonim.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserObject> signInWithGoogle() async {
    return await Future.value(
        UserObject(uid: "fakeGoogleSignIn", email: "kutay@google.com"));
  }

  @override
  Future<UserObject> createAccountWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserObject(uid: userID, email: "kutay@email.com"));
  }

  @override
  Future<UserObject> signInWithEmail(String email, String password) async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserObject(uid: userID, email: "kutay@email.com"));
  }

  @override
  Future<UserObject> signInWithFacebook() async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserObject(uid: userID, email: "kutay@facebook.com"));
  }

  @override
  Future<bool> forgotPassword(String email) {
    return Future.value(true);
  }

  @override
  Future<UserObject> getUserByID(String userId) async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserObject(uid: userID, email: "kutay@facebook.com"));
  }

  @override
  Future<void> changeEmail(String newEmail) {
    // TODO: implement changeEmail
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String pass) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }
}
