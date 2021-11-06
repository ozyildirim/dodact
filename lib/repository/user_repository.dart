import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/fake_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AppMode { DEBUG, RELEASE }

// class that make us decide for which service provider we want to use

class UserRepository {
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirebaseUserService firebaseUserService = locator<FirebaseUserService>();

  AppMode appMode = AppMode.RELEASE;

  Future<UserObject> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      User user = await firebaseAuthService.currentUser();
      return await firebaseUserService.getUserFromDb(user.uid);
    }
  }

  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await firebaseAuthService.signOut();
    }
  }

  Future<UserObject> getUserByID(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      var result = await firebaseAuthService.getUserByID(userId);
      return result;
    }
  }

  Future<void> updatePassword(String pass) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.updatePassword(pass);
    } else {
      var result = await firebaseAuthService.updatePassword(pass);
      return result;
    }
  }

  Future<List<UserObject>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var list = await firebaseUserService.getList();
      return list;
    }
  }

  Future<void> updateCurrentUser(
      Map<String, dynamic> newData, String uid) async {
    await firebaseUserService.updateCurrentUser(newData, uid);
  }
}
