import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/fake_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';
import 'package:flutter/material.dart';

enum AppMode { DEBUG, RELEASE }

class AuthRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirebaseUserService _firebaseUserService = locator<FirebaseUserService>();

  AppMode appMode = AppMode.RELEASE;

  Future<UserObject> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserObject _user = await _firebaseAuthService.currentUser();
      return await _firebaseUserService.readUser(_user.uid);
    }
  }

  Future<UserObject> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  Future<UserObject> signInWithGoogle(BuildContext context) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      UserObject _user = await _firebaseAuthService.signInWithGoogle(context);
      bool _result = await _firebaseUserService.save(_user);
      if (_result) {
        return await _firebaseUserService.readUser(_user.uid);
      } else {
        return null;
      }
    }
  }

  Future<bool> createAccountWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      // return true;
    } else {
      var user = await _firebaseAuthService.createAccountWithEmailAndPassword(
          email, password);

      bool result = await _firebaseUserService.save(user);
      if (result) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<UserObject> signInWithEmail(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email, password);
    } else {
      UserObject _user =
          await _firebaseAuthService.signInWithEmail(email, password);

      if (_user != null) {
        return _firebaseUserService.readUser(_user.uid);
      } else {
        return null;
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    if (appMode == AppMode.DEBUG) {
      // return true;
    } else {
      await _firebaseAuthService.forgotPassword(email);
    }
  }

  Future<UserObject> getUserByID(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      var result = await _firebaseAuthService.getUserByID(userId);
      return result;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      var result = await _firebaseAuthService.updateEmail(newEmail);
      return result;
    }
  }

  Future<void> updatePassword(String pass) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.updatePassword(pass);
    } else {
      await _firebaseAuthService.updatePassword(pass);
    }
  }

  Future<void> updateCurrentUser(
      Map<String, dynamic> newData, String uid) async {
    await _firebaseAuthService.updateCurrentUser(newData, uid);
  }
}
