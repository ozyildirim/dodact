import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentId;
  DateTime commentDate;
  String authorId;
  String comment;

  CommentModel({this.commentId, this.commentDate, this.authorId, this.comment});

  CommentModel.fromJson(Map<String, dynamic> json)
      : commentId = json['commentId'],
        commentDate = (json['commentDate'] as Timestamp).toDate(),
        authorId = json['authorId'],
        comment = json['comment'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['commentDate'] = this.commentDate ?? FieldValue.serverTimestamp();
    data['authorId'] = this.authorId;
    data['comment'] = this.comment;
    return data;
  }
}
