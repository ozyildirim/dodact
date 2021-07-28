import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/comment_model.dart';

class FirebaseCommentService {
  Future<List<CommentModel>> getPostComments(String postId) async {
    List<CommentModel> comments = [];

    QuerySnapshot querySnapshot =
        await postsRef.doc(postId).collection("comments").get();

    for (DocumentSnapshot comment in querySnapshot.docs) {
      CommentModel _convertedComment = CommentModel.fromJson(comment.data());
      comments.add(_convertedComment);
    }
    return comments;
  }

  Future<void> saveComment(CommentModel comment, String postId) async {
    await postsRef
        .doc(postId)
        .collection("comments")
        .add(comment.toJson())
        .then((value) async {
      return await postsRef
          .doc(postId)
          .collection("comments")
          .doc(value.id)
          .update({
        "commentId": value.id,
      });
    });
  }

  Future<void> deleteComment() async {}

  Future<void> likeComment() async {}

  Future<void> unlikeComment() async {}

  Future<void> reportComment() async {}
}
