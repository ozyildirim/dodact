import 'package:dodact_v1/config/base/base_model.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/auth_repository.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum ViewState { Ideal, Busy }
enum AuthState { SignIn, SignUp }

class AuthProvider extends BaseModel {
  AuthRepository authRepository = locator<AuthRepository>();
  Logger logger = Logger();

  AuthProvider() {
    getCurrentUser();
    notifyListeners();
  }

  AuthResultStatus authStatus;
  AuthResultStatus accountAuthStatus;

  User currentUser;
  bool isLoading = false;

  setUser(User _user) {
    currentUser = _user;
  }

  getCurrentUser() async {
    setUser(await authRepository.currentUser());
    notifyListeners();
  }

  Future<UserObject> getUserByID(String userId) async {
    try {
      return await authRepository.getUserByID(userId);
    } catch (e) {
      debugPrint("AuthProvider getUserByID function error: " + e.toString());
      return null;
    }
  }

  Future<bool> signOut() async {
    try {
      setUser(null);

      bool result = await authRepository.signOut();
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint("AuthProvider signOut error: " + e.toString());
      notifyListeners();

      return false;
    }
  }

  Future<AuthResultStatus> signInWithGoogle(BuildContext context) async {
    try {
      authStatus = null;
      var user = await authRepository.signInWithGoogle(context);
      if (user != null) {
        print("AuthProvider user logged with google");
        authStatus = AuthResultStatus.successful;
        setUser(user);
        notifyListeners();
      } else {
        print("AuthProvider google user null");
        authStatus = AuthResultStatus.abortedByUser;
        notifyListeners();
      }
    } catch (e) {
      logger.e("AuthProvider signInWithGoogle error:" + e.toString());
      authStatus = AuthResultStatus.abortedByUser;
      notifyListeners();
    }

    return authStatus;
  }

  Future<AuthResultStatus> createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      authStatus = null;

      var user = await authRepository.createAccountWithEmailAndPassword(
          email, password);
      if (user == true) {
        logger.i("AuthProvider user signed up: ");
        authStatus = AuthResultStatus.successful;
      } else {
        logger.i('AuthProvider signUp user null');
      }
    } on FirebaseAuthException catch (e) {
      logger.e("AuthProvider login create account error: $e");
      authStatus = AuthExceptionHandler.handleException(e);
    }
    notifyListeners();

    return authStatus;
  }

  Future<AuthResultStatus> signInWithEmail(
      String email, String password) async {
    authStatus = null;
    try {
      var user = await authRepository.signInWithEmail(email, password);
      if (user != null) {
        logger.i("User ${user.email} logged in.");
        authStatus = AuthResultStatus.successful;
        setUser(user);
      } else {
        logger.e("E-posta onayı gerekmekte.");
      }
    } on FirebaseAuthException catch (e) {
      logger.e("AuthProvider signInWithEmail error: " + e.toString());
      authStatus = AuthExceptionHandler.handleException(e);
    }
    notifyListeners();

    return authStatus;
  }

  bool isEmailVerified(User user) {
    return user.emailVerified;
  }

  Future<void> forgotPassword(String email) async {
    try {
      await authRepository.forgotPassword(email);
    } catch (e) {
      logger.e("AuthProvider forgotPassword error." + e.toString());
    }
  }

  Future<dynamic> updatePassword(String password) async {
    try {
      await authRepository.updatePassword(password);
      return true;
    } catch (e) {
      logger.e("AuthProvider updatePassword error." + e.toString());
      return e;
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await authRepository.updateEmail(email);
    } catch (e) {
      logger.e("AuthProvider updateEmail error." + e.toString());
    }
  }
}
