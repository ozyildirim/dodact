import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/fake_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';

enum AppMode { DEBUG, RELEASE }

// class that make us decide for which service provider we want to use

class UserRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirebaseUserService _firestoreUserService = locator<FirebaseUserService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserObject> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserObject _user = await _firebaseAuthService.currentUser();
      return await _firestoreUserService.readUser(_user.uid);
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

  Future<UserObject> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      UserObject _user = await _firebaseAuthService.signInWithGoogle();
      bool _result = await _firestoreUserService.save(_user);
      if (_result) {
        return await _firestoreUserService.readUser(_user.uid);
      } else {
        return null;
      }
    }
  }

  // @override
  // Future<UserObject> signInWithFacebook() async {
  //   if (appMode == AppMode.DEBUG) {
  //     return await _fakeAuthService.signInWithFacebook();
  //   } else {
  //     UserObject _user = await _firebaseAuthService.signInWithFacebook();
  //     bool _result = await _firestoreUserService.save(_user);
  //     if (_result) {
  //       return await _firestoreUserService.readUser(_user.uid);
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  Future<UserObject> getUserByID(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      var result = await _firebaseAuthService.getUserByID(userId);
      return result;
    }
  }

  @override
  Future<void> updatePassword(String pass) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.updatePassword(pass);
    } else {
      var result = await _firebaseAuthService.updatePassword(pass);
      return result;
    }
  }

  Future<List<UserObject>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var list = await _firestoreUserService.getList();
      return list;
    }
  }
}
