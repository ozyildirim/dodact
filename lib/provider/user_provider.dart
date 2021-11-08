import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/user_repository.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_user_favorites_service.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UserProvider with ChangeNotifier {
  Logger logger = Logger();
  UserRepository userRepository = locator<UserRepository>();
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  UserObject currentUser;
  UserObject otherUser;

  List<UserObject> userList;
  bool isLoading = false;

  String emailErrorMessage;
  String passwordErrorMessage;

  changeState(bool _isLoading, {bool isNotify}) {
    isLoading = _isLoading;
    if (isNotify != null) {
      if (isNotify) {
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

  void removeUser() {
    currentUser = null;
    notifyListeners();
  }

  setOtherUser(UserObject user) {
    otherUser = user;
  }

  setCurrentUser(UserObject user) {
    currentUser = user;
    notifyListeners();
  }

  Future<UserObject> getUserByID(String userId) async {
    try {
      return await userRepository.getUserByID(userId);
    } catch (e) {
      debugPrint("UserProvider getUserByID function error: " + e.toString());
      return null;
    }
  }

  Future<UserObject> getOtherUser(String userId) async {
    try {
      otherUser = await userRepository.getUserByID(userId);
      notifyListeners();
      return otherUser;
    } catch (e) {
      logger.e("UserProvider getOtherUser function error: " + e.toString());
      return null;
    }
  }

  // ignore: missing_return
  Future<UserObject> getCurrentUser() async {
    try {
      var user = firebaseAuthService.currentUser();
      DocumentSnapshot documentSnapshot = await usersRef.doc(user.uid).get();
      if (documentSnapshot.exists) {
        setCurrentUser(UserObject.fromDoc(documentSnapshot));
        return currentUser;
      }
    } catch (e) {
      print("UserProvider getCurrentUser error: $e");
      currentUser = null;
      return null;
    }
  }

  Future<List<UserObject>> getAllUsers({bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      List<UserObject> list = await userRepository.getAllUsers();
      userList = list;
      return userList;
    } catch (e) {
      print("UserProvider getAllUsers error: $e");
      return null;
    } finally {
      changeState(false);
    }
  }

  bool _emailPasswordCheck(String email, String password) {
    var result = true;

    if (password.length < 6) {
      passwordErrorMessage = "Şifreniz en az 6 karakter olmalı.";
      result = false;
    } else {
      passwordErrorMessage = null;
    }
    if (!email.contains('@')) {
      emailErrorMessage = "Geçersiz e-posta adresi.";
      result = false;
    } else {
      emailErrorMessage = null;
    }
    return result;
  }

  Future<void> updateCurrentUser(Map<String, dynamic> newData) async {
    try {
      await userRepository.updateCurrentUser(newData, currentUser.uid);
      getCurrentUser();
    } catch (e) {
      logger.e("authProvider updateCurrentUser error: $e");
    }
  }

  Future<String> updateCurrentUserProfilePicture(File image) async {
    //First: upload users photo to firestorage
    try {
      var url = await UploadService().uploadUserProfilePhoto(
          userID: currentUser.uid,
          fileType: 'profile_picture',
          fileToUpload: image);
      currentUser.profilePictureURL = url;
      notifyListeners();
      await updateCurrentUser({'profilePictureURL': url});
      return url;
    } catch (e) {
      logger.e("UserProvider updateCurrentUserProfilePicture error. " +
          e.toString());
      notifyListeners();
    }
  }

  Future<void> getCurrentUserFavoritePosts() async {
    try {
      currentUser.favoritedPosts = await FirebaseUserFavoritesService()
          .getUserFavoritePosts(currentUser.uid);
      notifyListeners();
    } catch (e) {
      logger.e("UserProvider getUserFavoritePosts error: " + e.toString());
    }
  }

  Future<void> updateCurrentUserInterests(
      List<Map<String, dynamic>> interests) async {
    try {
      var newData = {'interests': interests};
      await userRepository.updateCurrentUser(newData, currentUser.uid);
      currentUser.interests = interests;
      notifyListeners();
      logger.i("Bilgiler güncellendi");
    } catch (e) {
      logger.e("UserProvider updateUserInterests error: " + e.toString());
    }
  }

  Future<void> addFavoritePost(String postId) async {
    try {
      await FirebaseUserFavoritesService()
          .addFavoritePost(currentUser.uid, postId);
      currentUser.favoritedPosts.add(postId);
      notifyListeners();
    } catch (e) {
      logger.e("UserProvider addFavoritePost error: " + e.toString());
    }
  }

  Future<void> removeFavoritePost(String postId) async {
    try {
      await FirebaseUserFavoritesService()
          .removeFavoritePost(currentUser.uid, postId);
      currentUser.favoritedPosts.remove(postId);
      notifyListeners();
    } catch (e) {
      logger.e("UserProvider removeFavoritePost error: " + e.toString());
    }
  }

  Future<void> updateUserSearchKeywords() async {
    try {
      List<String> searchKeywords = [];

      for (int i = 1; i <= currentUser.username.length; i++) {
        searchKeywords.add(currentUser.username.substring(0, i).toLowerCase());
      }
      await updateCurrentUser({'searchKeywords': searchKeywords});
    } catch (e) {
      logger.e("UserProvider updateUserSearchKeywords error: " + e.toString());
    }
  }
}
