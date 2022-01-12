import 'package:dodact_v1/config/base/base_model.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/auth_repository.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  getCurrentUser() {
    setUser(authRepository.currentUser());
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

  Future logout() async {
    try {
      var userId = currentUser.uid;
      await removeUserToken(userId);
      await authRepository.logout();
      setUser(null);
      // Get.offAllNamed(k_ROUTE_WELCOME);
      Get.offNamedUntil(k_ROUTE_LANDING, (route) => false);
    } catch (e) {
      // Get.showSnackbar(GetSnackBar());
      debugPrint("AuthProvider signOut error: " + e.toString());
      return false;
    }
  }

  removeUserToken(String userId) async {
    await tokensRef.doc(userId).delete();
    print("token silindi");
  }

  Future signInWithGoogle(BuildContext context) async {
    try {
      var user = await authRepository.signInWithGoogle(context);
      if (user != null) {
        setUser(user);
        Get.offNamedUntil(k_ROUTE_LANDING, (route) => false);
      } else {
        Get.back();
      }
    } catch (e) {
      Get.back();
      logger.e("AuthProvider signInWithGoogle error: " + e.toString());
      CustomMethods.showSnackbar(context, "Bir hata oluştu.");
    }
  }

  Future signInWithApple(BuildContext context) async {
    try {
      var user = await authRepository.signInWithApple(context);
      if (user != null) {
        setUser(user);
      } else {
        Get.back();
      }
    } catch (e) {
      Get.back();
      logger.e("AuthProvider signInWithApple error:" + e.toString());
      Get.back();
      CustomMethods.showSnackbar(context, "Bir hata oluştu.");
    }
  }

  Future<AuthResultStatus> signup(String email, String password) async {
    try {
      authStatus = null;

      var user = await authRepository.signup(email, password);
      if (user == true) {
        authStatus = AuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      logger.e("AuthProvider signup error: $e");
      authStatus = AuthExceptionHandler.handleException(e);
    }
    notifyListeners();

    return authStatus;
  }

  Future<AuthResultStatus> signin(String email, String password) async {
    authStatus = null;
    try {
      var user = await authRepository.signin(email, password);
      if (user != null) {
        logger.i("User ${user.email} logged in.");
        authStatus = AuthResultStatus.successful;
        setUser(user);
        Get.back();
        Get.offNamedUntil(k_ROUTE_LANDING, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      logger.e("AuthProvider login error: " + e.toString());
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
