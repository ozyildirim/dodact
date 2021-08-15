import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String postId;
  String ownerType;
  String ownerId;
  String postCategory;
  String postTitle;
  String postDescription;
  String postContentURL;
  DateTime postDate;

  int dodCounter;
  bool isVideo;
  bool isLocatedInYoutube;

  List<dynamic> supportersId;
  String postContentType;

  bool approved;

  PostModel({
    this.postId,
    this.ownerType,
    this.ownerId,
    this.postCategory,
    this.postDate,
    this.postTitle,
    this.postDescription,
    this.postContentURL,
    this.isVideo,
    this.dodCounter,
    this.supportersId,
    this.isLocatedInYoutube,
    this.postContentType,
    this.approved,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : postId = json['postId'],
        ownerType = json['ownerType'],
        ownerId = json['ownerId'],
        postCategory = json['postCategory'],
        postDate = (json['postDate'] as Timestamp).toDate(),
        postTitle = json['postTitle'],
        postDescription = json['postDescription'],
        postContentURL = json['postContentURL'],
        isVideo = json['isVideo'],
        dodCounter = json['dodCounter'] ?? 0,
        isLocatedInYoutube = json['isLocatedInYoutube'],
        supportersId = json['supportersId'],
        postContentType = json['postContentType'],
        approved = json['approved'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['ownerType'] = this.ownerType;
    data['ownerId'] = this.ownerId;
    data['postCategory'] = this.postCategory;
    data['postDate'] = this.postDate ?? FieldValue.serverTimestamp();
    data['postTitle'] = this.postTitle;
    data['postDescription'] = this.postDescription;
    data['postContentURL'] = this.postContentURL;
    data['isVideo'] = this.isVideo;

    data['dodCounter'] = this.dodCounter ?? 0;
    data['supportersId'] = this.supportersId;
    data['isLocatedInYoutube'] = this.isLocatedInYoutube;
    data['postContentType'] = this.postContentType;
    data['approved'] = this.approved;
    return data;
  }

  @override
  String toString() {
    return 'PostModel{postId: $postId, ownerType: $ownerType,approved: $approved , ownerId: $ownerId, postCategory: $postCategory, isLocatedInYoutube: $isLocatedInYoutube,postContentType: $postContentType, postTitle: $postTitle, postDescription: $postDescription, postContentURL: $postContentURL, postDate: $postDate, isVideo: $isVideo}';
  }
}
