import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/auth_repository.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum VerifyState { WAITING_FOR_VERIFY, VERIFIED }

class AuthProvider extends ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();

  AuthProvider() {
    getUser();
  }

  AuthResultStatus authStatus;
  AuthResultStatus accountAuthStatus;
  VerifyState verifyState = VerifyState.WAITING_FOR_VERIFY;

  UserObject currentUser;
  bool isLoading = false;

  setUser(UserObject _user) {
    currentUser = _user;
    notifyListeners();
  }

  changeState(bool _isLoading) {
    isLoading = _isLoading;
    notifyListeners();
  }

  Future<UserObject> getUser() async {
    try {
      changeState(true);
      currentUser = await _authRepository.currentUser();
      return currentUser;
    } catch (e) {
      debugPrint("AuthProvider getUser function error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  getCurrentUser() async {
    if (currentUser == null) {
      setUser(await FirebaseAuthService().currentUser());
    }
  }


  Future<UserObject> getUserByID(String userId) async {
    try {
      changeState(true);
      return await _authRepository.getUserByID(userId);
    } catch (e) {
      debugPrint("AuthProvider getUserByID function error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<UserObject> signInAnonymously() async {
    try {
      changeState(true);
      var user = await _authRepository.signInAnonymously();
      if (user != null) {
        currentUser = user;
        return currentUser;
      }
    } catch (e) {
      debugPrint(
          "AuthProvider signInAnonymously function error: " + e.toString());
      return null;
    } finally {
      changeState(true);
    }
  }


  Future<bool> signOut() async {
    try {
      currentUser = null;
      bool result = await _authRepository.signOut();
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint("AuthProvider signOut error: " + e.toString());
      return false;
    }
  }

  Future<UserObject> signInWithGoogle() async {
    try {
      changeState(true);
      var user = await _authRepository.signInWithGoogle();
      if (user != null) {
        currentUser = user;
        return currentUser;
      }
    } catch (e) {
      debugPrint("AuthProvider signInWithGoogle error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<UserObject> createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      changeState(true);
      var user = await _authRepository.createAccountWithEmailAndPassword(
          email, password);
      if (user != null) {
        debugPrint("AuthProvider user signed up: " + user.uid + user.email);
        currentUser = user;
        return currentUser;
      }
    } on FirebaseAuthException catch (e) {
      print("AuthProvider login create account error: $e");
    } finally {
      changeState(false);
    }
  }

  Future<UserObject> signInWithEmail(String email, String password) async {
    try {
      changeState(true);
      var user = await _authRepository.signInWithEmail(email, password);
      currentUser = user;
      return currentUser;
    } catch (e) {
      debugPrint("AuthProvider signInWithEmail error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<UserObject> signInWithFacebook() async {
    try {
      changeState(true);
      var user = await _authRepository.signInWithFacebook();
      if (user != null) {
        currentUser = user;
        return currentUser;
      }
    } catch (e) {
      debugPrint("AuthProvider facebook login error: $e");
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      changeState(true);
      var result = await _authRepository.forgotPassword(email);
      return result;
    } catch (e) {
      debugPrint("AuthProvider ViewModel error." + e.toString());
    } finally {
      changeState(false);
    }
  }
}
