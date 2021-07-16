import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';

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
    List<String> postIDs = user.postIDs;
    List<PostModel> allUserPosts = [];

    print("Post IDs from object:" + postIDs.toString());
    await Future.forEach(postIDs, (post) async {
      DocumentSnapshot documentSnapshot = await postsRef.doc(post).get();
      PostModel singlePost = PostModel.fromJson(documentSnapshot.data());
      allUserPosts.add(singlePost);
    });
    // for (String post in postIDs) {
    //   DocumentSnapshot documentSnapshot =
    //       await postsRef.doc(post).get();
    //   PostModel singlePost = PostModel.fromJson(documentSnapshot.data());
    //   allUserPosts.add(singlePost);
    // }
    return allUserPosts;
  }

  Future<List<PostModel>> getGroupPosts(GroupModel group) async {
    //Get post IDs from user object
    List<dynamic> postIDs = group.groupPostIDs;
    List<PostModel> allGroupPosts = [];

    print("Group Post IDs from  group object:" + postIDs.toString());
    for (dynamic post in postIDs) {
      DocumentSnapshot documentSnapshot =
          await postsRef.doc(post.toString()).get();
      PostModel singlePost = PostModel.fromJson(documentSnapshot.data());
      allGroupPosts.add(singlePost);
    }
    return allGroupPosts;
  }

  //fetch events by query
  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<void> save(PostModel model) async {
    if (model.postId == null || model.postId.isEmpty) {
      return await postsRef.add(model.toJson()).then((value) async =>
          await postsRef.doc(value.id).update({'postID': value.id}));
    }
    return await postsRef.doc(model.postId).set(model.toJson());
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
        await postsRef.orderBy('claps', descending: true).limit(10).get();
    for (DocumentSnapshot post in querySnapshot.docs) {
      PostModel _convertedPost = PostModel.fromJson(post.data());
      topPosts.add(_convertedPost);
    }

    return topPosts;
  }
}
