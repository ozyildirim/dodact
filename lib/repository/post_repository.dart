import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/dodder_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/concrete/fake_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_post_service.dart';

enum AppMode { DEBUG, RELEASE }

// class that make us decide for which service provider we want to use

class PostRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();

  FirebasePostService _firebasePostService = locator<FirebasePostService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<void> delete(String id) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebasePostService.delete(id).then((value) => true);
    }
  }

  @override
  Future<PostModel> getDetail(String id) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebasePostService.getDetail(id);
    }
  }

  Future<List<PostModel>> getList() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<PostModel>.empty());
    } else {
      return await _firebasePostService.getList();
    }
  }

  @override
  Future<QuerySnapshot> getListQuery(
      int documentLimit, DocumentSnapshot startAfter) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firebasePostService.getListQuery(documentLimit, startAfter);
    }
  }

  @override
  Future<String> save(model) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebasePostService.save(model);
    }
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _firebasePostService.update(id, changes);
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(UserObject user) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firebasePostService.getUserPosts(user);
    }
  }

  Future<List<PostModel>> getAllPostsWithCategory(String category) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var allCategorizedPosts =
          await _firebasePostService.getAllPostsWithCategory(category);
      return allCategorizedPosts;
    }
  }

  // Future<bool> canUserCreatePostInCurrentDay(String userId) async {
  //   if (appMode == AppMode.DEBUG) {
  //     return true;
  //   } else {
  //     return await _firebasePostService.canUserCreatePostInCurrentDay(userId);
  //   }
  // }

  @override
  Future<List<PostModel>> getTopPosts() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<PostModel>.empty());
    } else {
      return await _firebasePostService.getTopPosts();
    }
  }

  Future<List<DodderModel>> getDodders(String postId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<DodderModel>.empty());
    } else {
      return await _firebasePostService.getDodders(postId);
    }
  }

  Future<void> dodPost(String postId, String userId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await _firebasePostService.dodPost(postId, userId);
    }
  }

  Future<void> undodPost(String postId, String userId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await _firebasePostService.undodPost(postId, userId);
    }
  }
}
