import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/user_repository.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';

import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserRepository userRepository = locator<UserRepository>();
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  UserObject user;
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
    user = null;
    notifyListeners();
  }

  setOtherUser(UserObject user) {
    otherUser = user;
  }

  Future<UserObject> getUserByID(String userId) async {
    try {
      return await userRepository.getUserByID(userId);
    } catch (e) {
      debugPrint("UserProvider getUserByID function error: " + e.toString());
      return null;
    }
  }

  Future<UserObject> getOtherUser(String userId, {bool isNotify}) async {
    try {
      otherUser = await userRepository.getUserByID(userId);
      notifyListeners();
      return otherUser;
    } catch (e) {
      debugPrint("UserProvider getOtherUser function error: " + e.toString());
      return null;
    }
  }

  Future<UserObject> getCurrentUser() async {
    try {
      UserObject _user = await _firebaseAuthService.currentUser();
      if (_user != null) {
        if (user != null) return user;
        DocumentSnapshot documentSnapshot = await usersRef.doc(_user.uid).get();
        if (documentSnapshot.exists) {
          user = UserObject.fromDoc(documentSnapshot);
          notifyListeners();
          return user;
        }
        return user;
      } else {
        user = null;
        notifyListeners();
        return null;
      }
    } catch (e) {
      print("UserProvider getCurrentUser error: $e");
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
}
