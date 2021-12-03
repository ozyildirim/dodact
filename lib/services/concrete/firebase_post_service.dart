import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/dodder_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:logger/logger.dart';
import 'package:ntp/ntp.dart';

class FirebasePostService {
  var logger = new Logger();

  Future<void> delete(String id) async {
    return await postsRef.doc(id).delete();
  }

  Future<PostModel> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await postsRef.doc(id).get();
    if (documentSnapshot.exists) {
      PostModel postModel = PostModel.fromJson(documentSnapshot.data());
      return postModel;
    } else
      return null;
  }

  // Get all posts

  Future<List<PostModel>> getList() async {
    List<PostModel> allposts = [];

    QuerySnapshot querySnapshot =
        await postsRef.where('visible', isEqualTo: true).get();

    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      allposts.add(_convertedPost);
    }
    return allposts;
  }

  // Future<bool> canUserCreatePostInCurrentDay(String userId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await postsRef
  //         .where('ownerId', isEqualTo: userId)
  //         .orderBy('postDate', descending: true)
  //         .limit(1)
  //         .get();

  //     if (querySnapshot.docs.length == 0) {
  //       return true;
  //     } else {
  //       PostModel postModel = PostModel.fromJson(querySnapshot.docs[0].data());
  //       DateTime lastPostDate = postModel.postDate;
  //       print(lastPostDate);
  //       DateTime currentDate = await NTP.now();
  //       print(currentDate);
  //       Duration difference = currentDate.difference(lastPostDate);
  //       if (difference.inDays > 0) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //     return false;
  //   }
  // }

  Future<List<PostModel>> getUserPosts(UserObject user) async {
    //Get post IDs from user object
    // List<String> postIDs = user.postIDs;
    List<PostModel> userPosts = [];

    QuerySnapshot querySnapshot = await postsRef
        .where('ownerId', isEqualTo: user.uid)
        .where('visible', isEqualTo: true)
        .get();

    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      userPosts.add(_convertedPost);
    }

    return userPosts;
  }

  Future<List<PostModel>> getGroupPosts(String groupId) async {
    try {
      List<PostModel> allGroupPosts = [];

      QuerySnapshot querySnapshot = await postsRef
          .where('ownerId', isEqualTo: groupId)
          .where('visible', isEqualTo: true)
          .get();

      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        PostModel singlePost = PostModel.fromJson(documentSnapshot.data());
        allGroupPosts.add(singlePost);
      }

      return allGroupPosts;
    } catch (e) {
      logger.e(e);
    }
  }

  //fetch events by query

  Future<QuerySnapshot> getListQuery(
      int documentLimit, DocumentSnapshot startAfter) async {
    final refPosts = postsRef.limit(documentLimit);

    if (startAfter == null) {
      return refPosts.get();
    } else {
      return refPosts.startAfterDocument(startAfter).get();
    }
  }

  Future<void> addPost() async {}

  Future<String> save(PostModel model) async {
    if (model.postId == null || model.postId.isEmpty) {
      String documentID;
      return await postsRef.add(model.toJson()).then((postReference) async {
        return await postsRef
            .doc(postReference.id)
            .update({'postId': postReference.id}).then((_) {
          documentID = postReference.id;
          return documentID;
          //save fonksiyonu eklenen dökümanın ID sini geri döndürür.
        });
      });
    } else {
      //POST EDIT
      await postsRef.doc(model.postId).set(model.toJson());
    }
  }

  Future<void> update(String id, Map<String, dynamic> changes) async {
    return await postsRef.doc(id).update(changes);
  }

  Future<List<PostModel>> getAllPostsWithCategory(String category) async {
    QuerySnapshot querySnapshot = await postsRef
        .where('postCategory', isEqualTo: category)
        .where('visible', isEqualTo: true)
        .get();
    List<PostModel> allFilteredPosts = [];

    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      allFilteredPosts.add(_convertedPost);
    }
    return allFilteredPosts;
  }

  Future<List<PostModel>> getTopPosts() async {
    List<PostModel> topPosts = [];

    QuerySnapshot querySnapshot = await postsRef
        .where("visible", isEqualTo: true)
        .orderBy('dodCounter', descending: true)
        .limit(3)
        .get();

    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      topPosts.add(_convertedPost);
    }

    return topPosts;
  }

  Future<List<PostModel>> getContributedPosts(String organizationName) async {
    List<PostModel> contributedPosts = [];

    // var month = DateTime.now().month;

    QuerySnapshot querySnapshot = await postsRef
        .where('chosenCompany', isEqualTo: organizationName)
        .where('visible', isEqualTo: true)
        .get();

    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel convertedPost = PostModel.fromJson(post.data());
      contributedPosts.add(convertedPost);
    }

    return contributedPosts;
  }

  Future<List<DodderModel>> getDodders(String postId) async {
    List<DodderModel> dodders = [];

    QuerySnapshot querySnapshot =
        await postsRef.doc(postId).collection('dodders').get();

    for (DocumentSnapshot post in querySnapshot.docs) {
      DodderModel _convertedPost = DodderModel.fromMap(post.data());
      dodders.add(_convertedPost);
    }

    return dodders;
  }

  Future<void> dodPost(String postId, String userId) async {
    await postsRef
        .doc(postId)
        .collection('dodders')
        .doc(userId)
        .set(DodderModel(
          date: DateTime.now(),
          dodderId: userId,
        ).toMap());
  }

  Future<void> undodPost(String postId, String userId) async {
    await postsRef.doc(postId).collection('dodders').doc(userId).delete();
  }
}
