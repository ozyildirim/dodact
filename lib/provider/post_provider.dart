import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/request_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/repository/post_repository.dart';
import 'package:dodact_v1/services/concrete/firebase_request_service.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class PostProvider extends ChangeNotifier {
  PostRepository postRepository = locator<PostRepository>();
  AuthProvider _authProvider = AuthProvider();
  GroupProvider _groupProvider = GroupProvider();
  FirebaseRequestService requestService = FirebaseRequestService();

  var logger = new Logger();

  PostModel post;

  List<PostModel> postList;
  List<PostModel> userPosts;
  List<PostModel> otherUsersPosts;

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

        //ve post sahibinin post listesine ekleniyor.

        if (newPost.ownerType == "User") {
          await _authProvider.editUserPostIDs(
              newPost.postId, newPost.ownerId, true);
        } else if (newPost.ownerType == "Group") {
          await _groupProvider.editGroupPostList(
              newPost.postId, newPost.ownerId, true);
        } else {
          debugPrint("User type sıkıntısı");
        }

        await createPostRequest(newPost);
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

        //Post isteği oluşturuluyor.
        await createPostRequest(newPost);

        //ve post sahibinin post listesine ekleniyor.
        if (newPost.ownerType == "User") {
          await _authProvider.editUserPostIDs(postId, newPost.ownerId, true);
        } else if (newPost.ownerType == "Group") {
          await _groupProvider.editGroupPostList(postId, newPost.ownerId, true);
        }
      }
    } catch (e) {
      debugPrint("PostProvider add post error: " + e.toString());
    }
  }

  Future<void> createPostRequest(PostModel post) async {
    try {
      var requestModel = new RequestModel();
      requestModel.requestOwnerId = post.ownerId;
      requestModel.requestDate = DateTime.now();
      requestModel.subjectId = post.postId;
      requestModel.requestFor = "Post";
      requestModel.isExamined = false;
      requestModel.isApproved = false;
      requestModel.rejectionMessage = "";

      await requestService.addRequest(requestModel);
    } catch (e) {
      print("PostProvider createPostRequestModel error: $e ");
    }
  }

  Future<void> deletePost(String postId, bool isInStorage) async {
    try {
      await postRepository.delete(postId).then((_) async {
        if (isInStorage) {
          await UploadService().deletePostMedia(postId);
        }
      });
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

  Future<void> changePostDoddedStatus(
      String postId, String userId, bool dodOrUndod) async {
    try {
      if (dodOrUndod) {
        await postRepository.update(postId, {
          'supportersId': FieldValue.arrayUnion([userId]),
          'dodCounter': FieldValue.increment(1)
        }).then((_) {
          post.supportersId.add(userId);
          notifyListeners();
        });
      } else {
        await postRepository.update(postId, {
          'supportersId': FieldValue.arrayRemove([userId]),
          'dodCounter': FieldValue.increment(-1)
        }).then((_) {
          post.supportersId.remove(userId);
          notifyListeners();
        });
      }
    } catch (e) {
      print("PostProvider changePostDoddedStatus error: " + e.toString());
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
