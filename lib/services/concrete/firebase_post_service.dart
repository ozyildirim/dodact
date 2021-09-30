import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/dodder_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:logger/logger.dart';

class FirebasePostService extends BaseService<PostModel> {
  @override
  Future<void> delete(String id) async {
    return await postsRef.doc(id).delete();
  }

  @override
  Future<PostModel> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await postsRef.doc(id).get();
    PostModel postModel = PostModel.fromJson(documentSnapshot.data());
    return postModel;
  }

  // Get all posts
  @override
  Future<List<PostModel>> getList() async {
    List<PostModel> allposts = [];

    QuerySnapshot querySnapshot = await postsRef.get();
    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      allposts.add(_convertedPost);
    }
    return allposts;
  }

  Future<List<PostModel>> getUserPosts(UserObject user) async {
    //Get post IDs from user object
    // List<String> postIDs = user.postIDs;
    List<PostModel> userPosts = [];

    QuerySnapshot querySnapshot =
        await postsRef.where('ownerId', isEqualTo: user.uid).get();

    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      userPosts.add(_convertedPost);
    }

    // print("Post IDs from object:" + postIDs.toString());
    // await Future.forEach(postIDs, (post) async {
    //   DocumentSnapshot documentSnapshot = await postsRef.doc(post).get();
    //   PostModel singlePost = PostModel.fromJson(documentSnapshot.data());
    //   userPosts.add(singlePost);
    // });
    // for (String post in postIDs) {
    //   DocumentSnapshot documentSnapshot =
    //       await postsRef.doc(post).get();
    //   PostModel singlePost = PostModel.fromJson(documentSnapshot.data());
    //   allUserPosts.add(singlePost);
    // }
    return userPosts;
  }

  Future<List<PostModel>> getGroupPosts(String groupId) async {
    try {
      List<PostModel> allGroupPosts = [];

      QuerySnapshot querySnapshot =
          await postsRef.where('ownerId', isEqualTo: groupId).get();

      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        PostModel singlePost = PostModel.fromJson(documentSnapshot.data());
        allGroupPosts.add(singlePost);
      }

      return allGroupPosts;
    } catch (e) {
      Logger().e(e);
    }
  }

  //fetch events by query
  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  Future<void> addPost() async {}

  @override
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

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    return await postsRef.doc(id).update(changes);
  }

  Future<List<PostModel>> getAllPostsWithCategory(String category) async {
    QuerySnapshot querySnapshot =
        await postsRef.where('postCategory', isEqualTo: category).get();
    List<PostModel> allFilteredPosts = [];

    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      allFilteredPosts.add(_convertedPost);
    }
    return allFilteredPosts;
  }

  Future<List<PostModel>> getTopPosts() async {
    List<PostModel> topPosts = [];

    QuerySnapshot querySnapshot =
        await postsRef.orderBy('dodCounter', descending: true).limit(3).get();

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
