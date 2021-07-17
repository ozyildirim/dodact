import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/model/comment_model.dart';

class PostModel {
  String postId;
  bool userOrGroup;
  String ownerId;
  String postCategory;
  String postTitle;
  String postDescription;
  String postContentURL;
  DateTime postDate;
  int claps;
  bool isVideo;
  bool isLocatedInYoutube;
  List<CommentModel> comments;
  List<dynamic> supportersId;

  PostModel(
      {this.postId,
      this.userOrGroup,
      this.ownerId,
      this.postCategory,
      this.postDate,
      this.postTitle,
      this.postDescription,
      this.postContentURL,
      this.isVideo,
      this.claps,
      this.comments,
      this.supportersId});

  PostModel.fromJson(Map<String, dynamic> json)
      : postId = json['postId'],
        userOrGroup = json['userOrGroup'],
        ownerId = json['ownerId'],
        postCategory = json['postCategory'],
        postDate = (json['postDate'] as Timestamp).toDate(),
        postTitle = json['postTitle'],
        postDescription = json['postDescription'],
        postContentURL = json['postContentURL'],
        isVideo = json['isVideo'],
        claps = json['claps'],
        comments = json['comments'],
        supportersId = json['supportersId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['userOrGroup'] = this.userOrGroup;
    data['ownerId'] = this.ownerId;
    data['postCategory'] = this.postCategory;
    data['postDate'] = this.postDate ?? FieldValue.serverTimestamp();
    data['postTitle'] = this.postTitle;
    data['postDescription'] = this.postDescription;
    data['postContentURL'] = this.postContentURL;
    data['isVideo'] = this.isVideo;
    data['claps'] = this.claps;
    data['comments'] = this.comments;
    data['supportersId'] = this.supportersId;
    return data;
  }

  @override
  String toString() {
    return 'PostModel{postId: $postId, userOrGroup: $userOrGroup, ownerId: $ownerId, postCategory: $postCategory, postTitle: $postTitle, postDescription: $postDescription, postContentURL: $postContentURL, postDate: $postDate, claps: $claps, isVideo: $isVideo}';
  }
}
