import 'dart:io';

import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/repository/post_repository.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:flutter/cupertino.dart';

class PostProvider extends ChangeNotifier {
  PostRepository postRepository = locator<PostRepository>();
  AuthProvider authProvider = AuthProvider();
  GroupProvider groupProvider = GroupProvider();

  PostModel post;
  PostModel newPost = new PostModel();
  List<PostModel> postList;
  List<PostModel> userPosts;
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
  Future addPost({File postFile}) async {
    try {
      //İÇERİK VİDEO İÇERİYOR İSE
      if (newPost.isVideo) {
        //Post modeli firestore ye ekleniyor ve Post ID geri döndürülüyor(İçerik URL olmadan).
        await postRepository.save(newPost).then((id) {
          newPost.postId = id;
        });

        //ve post sahibinin post listesine ekleniyor.

        if (newPost.ownerType == "User") {
          await authProvider.editUserPostDetail(
              newPost.postId, newPost.ownerId, true);
        } else if (newPost.ownerType == "Group") {
          await groupProvider.editGroupPostList(
              newPost.postId, newPost.ownerId, true);
        } else {
          print("User type sıkıntısı");
        }
        //İÇERİK VİDEO İÇERMİYOR İSE
      } else {
        //Post modeli firestore ye ekleniyor ve Post ID geri döndürülüyor(İçerik URL olmadan).
        var postId = await postRepository.save(newPost);
        newPost.postId = postId;

        //Post upload ediliyor.
        var uploadedContent = await UploadService().uploadPostMedia(
            postId: postId,
            fileNameAndExtension: postFile.path.split('/').last,
            fileToUpload: postFile);

        newPost.postContentURL = uploadedContent;

        //Post URL, post modele ekleniyor.
        await postRepository.save(newPost);

        //ve post sahibinin post listesine ekleniyor.
        if (newPost.ownerType == "User") {
          await authProvider.editUserPostDetail(postId, newPost.ownerId, true);
        } else if (newPost.ownerType == "Group") {
          await groupProvider.editGroupPostList(postId, newPost.ownerId, true);
        }
        //FIXME: 2 kere post ekleniyor, sebebini bul.
      }
    } catch (e) {
      print("PostProvider add error: " + e.toString());
    }
  }

  Future<bool> deletePost(String postId, {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      //TODO: Storage için de silme fonk. eklemek lazım
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
      userPosts = await postRepository.getUserPosts(user);
      notifyListeners();
      return userPosts;
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
