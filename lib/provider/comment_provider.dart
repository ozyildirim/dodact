import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/services/concrete/firebase_comment_service.dart';

import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  FirebaseCommentService firebaseCommentService = FirebaseCommentService();

  CommentModel comment;
  List<CommentModel> comments;
  bool hasComment = false;

  Future<List<CommentModel>> getPostComments(String postId) async {
    try {
      comments = await firebaseCommentService.getPostComments(postId);
      notifyListeners();
      return comments;
    } catch (e) {
      print("CommentProvider getPostComments error: $e");
      return null;
    }
  }

  Future<void> saveComment(CommentModel comment, String postId) async {
    try {
      await firebaseCommentService.saveComment(comment, postId).then((value) {
        comment.commentId = value;
        comments.add(comment);
        notifyListeners();
      });
    } catch (e) {
      print("CommentProvider saveComment error: $e");
      return null;
    }
  }

  Future<void> deleteComment(String commentId, String postId) async {
    try {
      await firebaseCommentService.deleteComment(commentId, postId);
      var comment =
          comments.firstWhere((element) => element.commentId == commentId);
      comments.remove(comment);
      notifyListeners();
    } catch (e) {
      print("CommentProvider deleteComment error: $e");
    }
  }
}
