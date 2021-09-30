import 'dart:io';

import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/dodder_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/post_repository.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class PostProvider extends ChangeNotifier {
  PostRepository postRepository = locator<PostRepository>();

  var logger = new Logger();

  PostModel post;

  List<PostModel> postList;
  List<PostModel> userPosts;
  List<PostModel> otherUsersPosts;
  List<DodderModel> postDodders;

  List<PostModel> topPosts;

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

  setPost(PostModel post) {
    this.post = post;
  }

  // If the content is not video, provider will upload it to firestorage,
  // Otherwise youtube link will be added to firestore.
  Future addPost({File postFile, PostModel post}) async {
    try {
      var newPost = post;

      //İÇERİK VİDEO İÇERİYOR İSE
      if (newPost.isVideo) {
        //Post modeli firestore ye ekleniyor ve Post ID geri döndürülüyor(İçerik URL olmadan).
        await postRepository.save(newPost).then((id) {
          newPost.postId = id;
        });

        //İÇERİK VİDEO İÇERMİYOR İSE
      } else {
        //Post modeli firestore ye ekleniyor ve Post ID geri döndürülüyor(İçerik URL olmadan).
        var postId = await postRepository.save(newPost);
        newPost.postId = postId;

        bool isImage = newPost.postContentType == "Görüntü";

        //Post upload ediliyor.
        var uploadedContent = await UploadService().uploadPostMedia(
            postId: postId,
            fileNameAndExtension: postFile.path.split('/').last,
            fileToUpload: postFile,
            isImage: isImage);

        newPost.postContentURL = uploadedContent;

        //Post URL, post modele ekleniyor.
        await postRepository.save(newPost);
      }
    } catch (e) {
      debugPrint("PostProvider add post error: " + e.toString());
    }
  }

  Future<void> deletePost(String postId, bool isInStorage) async {
    try {
      await postRepository.delete(postId).then((_) async {
        if (isInStorage) {
          await UploadService().deletePostMedia(postId);
        }
      });

      await postRepository.delete(postId);
      PostModel selectedPost =
          postList.firstWhere((element) => element.postId == postId);
      postList.remove(selectedPost);
      notifyListeners();
    } catch (e) {
      print("PostProvider delete error:  " + e.toString());
      return null;
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
      topPosts = fetchedList;
      notifyListeners();
    } catch (e) {
      print("PostProvider getList error: " + e.toString());
      return null;
    }
  }

  Future<bool> update(String postId, Map<String, dynamic> changes,
      {bool isNotify}) async {
    try {
      return await postRepository.update(postId, changes).then((value) async {
        await getDetail(postId);
        return true;
      });
    } catch (e) {
      print("PostProvider update error: " + e.toString());
      return false;
    }
  }

  Future<List<DodderModel>> getDodders(String postId) async {
    try {
      postDodders = await postRepository.getDodders(postId);
      post.dodders = postDodders;
      notifyListeners();
      return postDodders;
    } catch (e) {
      logger.e("PostProvider getDodders error: " + e.toString());
      return null;
    }
  }

  Future<void> dodPost(String postId, String userId) async {
    try {
      await postRepository.dodPost(postId, userId);
      post.dodders.add(
        DodderModel(date: DateTime.now(), dodderId: userId),
      );
      notifyListeners();
    } catch (e) {
      logger.e("PostProvider dodPost error: " + e.toString());
    }
  }

  Future<void> undodPost(String postId, String userId) async {
    try {
      await postRepository.undodPost(postId, userId);
      var dodder =
          post.dodders.firstWhere((element) => element.dodderId == userId);
      post.dodders.remove(dodder);
      notifyListeners();
    } catch (e) {
      logger.e("PostProvider undodPost error: " + e.toString());
    }
  }

  Future<List<PostModel>> getUserPosts(UserObject user) async {
    try {
      userPosts = await postRepository.getUserPosts(user);
      notifyListeners();
      return userPosts;
    } catch (e) {
      print("PostProvider getUserPosts error: " + e.toString());
      return null;
    }
  }

  Future<List<PostModel>> getOtherUserPosts(UserObject user) async {
    try {
      otherUsersPosts = await postRepository.getUserPosts(user);
      notifyListeners();
      return otherUsersPosts;
    } catch (e) {
      print("PostProvider getOtherUserPosts error: " + e.toString());
      return null;
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

  Future<void> getContributedPosts(String organizationName) async {
    try {
      postList = await postRepository.getContributedPosts(organizationName);
      notifyListeners();
    } catch (e) {
      logger.e("PostProvider getContributedPosts error: $e");
    }
  }
}
