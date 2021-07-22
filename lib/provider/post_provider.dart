import 'dart:io';

import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/post_repository.dart';
import 'package:flutter/cupertino.dart';

class PostProvider extends ChangeNotifier {
  PostRepository postRepository = locator<PostRepository>();

  PostModel post;
  PostModel newPost = new PostModel();
  List<PostModel> postList;
  List<PostModel> usersPosts;
  List<PostModel> otherUsersPosts;
  bool isLoading = false;

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

  clear() {
    post = null;
    postList.clear();
  }

  // If the content is not video, provider will upload it to firestorage,
  // Otherwise youtube link will be added to firestore.
  Future addPost({PostModel post, File postFile}) async {
    try {
      // if (model.isVideo != true) {
      //   if (image != null) {
      //     String imageURL = await UploadService.uploadImage(
      //         category: "post_images", file: image, name: name);
      //     model.postContentURL = imageURL;
      //   }
      //   return await FirebasePostService().save(model);
      // } else {
      //   return await FirebasePostService().save(model);
      // }
    } catch (e) {
      print("PostProvider add error: " + e.toString());
    }
  }

  Future<bool> deletePost(String postId, {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await postRepository.delete(postId).then((value) => true);
    } catch (e) {
      print("PostProvider delete error:  " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<PostModel> getDetail(String postId) async {
    try {
      var fetchedPost = await postRepository.getDetail(postId);
      post = fetchedPost;
      return post;
    } catch (e) {
      print("PostProvider getDetail error: " + e.toString());
      return null;
    }
  }

  Future<List<PostModel>> getList({bool isNotify}) async {
    try {
      var fetchedList = await postRepository.getList();
      postList = fetchedList;
      notifyListeners();
      return postList;
    } catch (e) {
      print("PostProvider getList error: " + e.toString());
      return null;
    }
  }

  Future<List<PostModel>> getTopPosts({bool isNotify}) async {
    try {
      var fetchedList = await postRepository.getTopPosts();
      return fetchedList;
    } catch (e) {
      print("PostProvider getList error: " + e.toString());
      return null;
    }
  }

  Future<bool> update(String postId, Map<String, dynamic> changes,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await postRepository.update(postId, changes).then((value) => true);
    } catch (e) {
      print("PostProvider update error: " + e.toString());
      return false;
    } finally {
      changeState(false);
    }
  }

  Future<List<PostModel>> getUserPosts(UserObject user, {bool isNotify}) async {
    try {
      usersPosts = await postRepository.getUserPosts(user);
      notifyListeners();
      return usersPosts;
    } catch (e) {
      print("PostProvider getUserPosts error: " + e.toString());
      return null;
    }
  }

  Future<List<PostModel>> getOtherUserPosts(UserObject user,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      otherUsersPosts = await postRepository.getUserPosts(user);
      notifyListeners();
      return otherUsersPosts;
    } catch (e) {
      print("PostProvider getUserPosts error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<List<PostModel>> getAllPostsWithCategory(String category,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await postRepository.getAllPostsWithCategory(category);
    } catch (e) {
      print("PostProvider getUserPosts error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  void clearNewPost() {
    newPost = new PostModel();
  }
}
