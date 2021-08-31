import 'dart:io';

import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/interest_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/auth_repository.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_interest_service.dart';
import 'package:dodact_v1/services/concrete/firebase_user_favorites_service.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum VerifyState { WAITING_TO_VERIFY, VERIFIED }

class AuthProvider extends ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();
  Logger logger = Logger();

  AuthProvider() {
    getUser();
    notifyListeners();
  }

  AuthResultStatus authStatus;
  AuthResultStatus accountAuthStatus;
  VerifyState verifyState = VerifyState.WAITING_TO_VERIFY;

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
      currentUser = await _authRepository.currentUser();
      getUserFavoritePosts();
      getUserInterests();
      notifyListeners();

      return currentUser;
    } catch (e) {
      debugPrint("AuthProvider getUser function error: " + e.toString());
      notifyListeners();
      return null;
    }
  }

  getCurrentUser() async {
    if (currentUser == null) {
      setUser(await FirebaseAuthService().currentUser());
      notifyListeners();
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

  Future<AuthResultStatus> signInWithGoogle() async {
    try {
      authStatus = null;
      var user = await _authRepository.signInWithGoogle();
      if (user != null) {
        print("AuthProvider user logged with google");
        authStatus = AuthResultStatus.successful;
        currentUser = user;
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

      var user = await _authRepository.createAccountWithEmailAndPassword(
          email, password);
      if (user == true) {
        logger.i("AuthProvider user signed up: ");
        authStatus = AuthResultStatus.successful;
      } else {
        logger.i('AuthProvider signUp user null');
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      logger.e("AuthProvider login create account error: $e");
      authStatus = AuthExceptionHandler.handleException(e);
      notifyListeners();
    }
    changeState(false);
    return authStatus;
  }

  Future<AuthResultStatus> signInWithEmail(
      String email, String password) async {
    authStatus = null;
    try {
      var user = await _authRepository.signInWithEmail(email, password);
      if (user != null) {
        logger.i("User ${user.email} logged in.");
        authStatus = AuthResultStatus.successful;
        currentUser = user;
        notifyListeners();
      } else {
        logger.e("E-posta onayı gerekmekte.");
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      logger.e("AuthProvider signInWithEmail error: " + e.toString());
      authStatus = AuthExceptionHandler.handleException(e);
      changeState(false);
    }
    return authStatus;
  }

  Future<bool> forgotPassword(String email) async {
    try {
      changeState(true);
      await _authRepository.forgotPassword(email);
      return true;
    } catch (e) {
      logger.e("AuthProvider forgotPassword error." + e.toString());
      return false;
    } finally {
      changeState(false);
    }
  }

  Future<dynamic> updatePassword(String password) async {
    try {
      await _authRepository.updatePassword(password);
      return true;
    } catch (e) {
      logger.e("AuthProvider updatePassword error." + e.toString());
      return e;
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await _authRepository.updateEmail(email);
    } catch (e) {
      logger.e("AuthProvider updateEmail error." + e.toString());
    }
  }

  Future<void> updateCurrentUser(Map<String, dynamic> newData) async {
    try {
      await _authRepository.updateCurrentUser(newData, currentUser.uid);
      getUser();
    } catch (e) {
      logger.e("authProvider updateCurrentUser error: $e");
    }
  }

  Future<void> editUserPostIDs(
      String postId, String userId, bool addOrRemove) async {
    try {
      await _authRepository.editUserPostIDs(postId, userId, addOrRemove);
      if (addOrRemove) {
        currentUser.postIDs.add(postId);
      } else {
        currentUser.postIDs.remove(postId);
      }
      notifyListeners();
    } catch (e) {
      logger.e("authProvider editUserPostDetail error: $e");
    }
  }

  Future<void> editUserEventIDs(
      String eventId, String userId, bool addOrRemove) async {
    try {
      await _authRepository.editUserEventIDs(eventId, userId, addOrRemove);
      if (addOrRemove) {
        currentUser.eventIDs.add(eventId);
      } else {
        currentUser.eventIDs.remove(eventId);
      }
      notifyListeners();
    } catch (e) {
      logger.e("authProvider editUserPostDetail error: $e");
    }
  }

  Future<String> updateCurrentUserProfilePicture(File image) async {
    //First: upload users photo to firestorage
    try {
      var url = await UploadService().uploadUserProfilePhoto(
          userID: currentUser.uid,
          fileType: 'profile_picture',
          fileToUpload: image);
      await updateCurrentUser({'profilePictureURL': url});
      return url;
    } catch (e) {
      logger.e("AuthProvider updateCurrentUserProfilePicture error. " +
          e.toString());
      notifyListeners();
    }
  }

  Future<void> getUserFavoritePosts() async {
    try {
      currentUser.favoritedPosts = await FirebaseUserFavoritesService()
          .getUserFavoritePosts(currentUser.uid);
      notifyListeners();
    } catch (e) {
      logger.e("AuthProvider getUserFavoritePosts error: " + e.toString());
    }
  }

  Future<void> getUserInterests() async {
    try {
      currentUser.interests =
          await FirebaseInterestService().getUserInterests(currentUser.uid);
      notifyListeners();
    } catch (e) {
      logger.e("AuthProvider getUserInterests error: " + e.toString());
    }
  }

  Future<void> updateUserInterests(List<InterestModel> interests) async {
    try {
      await FirebaseInterestService()
          .updateUserInterests(currentUser.uid, interests);
      currentUser.interests = interests;
      notifyListeners();
    } catch (e) {
      logger.e("AuthProvider updateUserInterests error: " + e.toString());
    }
  }

  Future<void> addFavoritePost(String postId) async {
    try {
      await FirebaseUserFavoritesService()
          .addFavoritePost(currentUser.uid, postId);
      currentUser.favoritedPosts.add(postId);
      notifyListeners();
    } catch (e) {
      logger.e("AuthProvider addFavoritePost error: " + e.toString());
    }
  }

  Future<void> removeFavoritePost(String postId) async {
    try {
      await FirebaseUserFavoritesService()
          .removeFavoritePost(currentUser.uid, postId);
      currentUser.favoritedPosts.remove(postId);
      notifyListeners();
    } catch (e) {
      logger.e("AuthProvider removeFavoritePost error: " + e.toString());
    }
  }
}
