import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/fake_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_user_service.dart';

enum AppMode { DEBUG, RELEASE }

class AuthRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirebaseUserService _firebaseUserService = locator<FirebaseUserService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserObject> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserObject _user = await _firebaseAuthService.currentUser();
      return await _firebaseUserService.readUser(_user.uid);
    }
  }

  @override
  Future<UserObject> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserObject> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      UserObject _user = await _firebaseAuthService.signInWithGoogle();
      bool _result = await _firebaseUserService.save(_user);
      if (_result) {
        return await _firebaseUserService.readUser(_user.uid);
      } else {
        return null;
      }
    }
  }
  //
  // @override
  // Future<UserObject> signInWithFacebook() async {
  //   if (appMode == AppMode.DEBUG) {
  //     return await _fakeAuthService.signInWithFacebook();
  //   } else {
  //     UserObject _user = await _firebaseAuthService.signInWithFacebook();
  //     bool _result = await _firebaseUserService.save(_user);
  //     if (_result) {
  //       return await _firebaseUserService.readUser(_user.uid);
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  @override
  Future<UserObject> createAccountWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createAccountWithEmailAndPassword(
          email, password);
    } else {
      UserObject _user = await _firebaseAuthService
          .createAccountWithEmailAndPassword(email, password);
      bool result = await _firebaseUserService.save(_user);
      if (result) {
        return await _firebaseUserService.readUser(_user.uid);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserObject> signInWithEmail(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email, password);
    } else {
      UserObject _user =
          await _firebaseAuthService.signInWithEmail(email, password);
      return _firebaseUserService.readUser(_user.uid);
    }
  }

  Future<void> forgotPassword(String email) async {
    if (appMode == AppMode.DEBUG) {
      return true;
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

  @override
  Future<void> changeEmail(String newEmail) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      var result = await _firebaseAuthService.changeEmail(newEmail);
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

  Future<void> updateCurrentUser(
      Map<String, dynamic> newData, String uid) async {
    await _firebaseAuthService.updateCurrentUser(newData, uid);
  }
}
