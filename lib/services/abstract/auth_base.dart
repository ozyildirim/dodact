import 'package:dodact_v1/model/user_model.dart';

abstract class AuthBase {
  Future<UserObject> currentUser();
  Future<UserObject> signInAnonymously();
  Future<bool> signOut();
  Future<UserObject> signInWithGoogle();
  Future<UserObject> signInWithFacebook();
  Future<UserObject> signInWithEmail(String email, String password);
  Future<UserObject> createAccountWithEmailAndPassword(
      String email, String password);
  Future<void> forgotPassword(String email);
  Future<UserObject> getUserByID(String userId);
  Future<void> changeEmail(String newEmail);
  Future<void> updatePassword(String pass);
}
