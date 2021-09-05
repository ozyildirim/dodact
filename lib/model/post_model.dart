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

  bool isUsedForHelp;
  String chosenCompany;

  int dodCounter;
  bool isVideo;
  bool isLocatedInYoutube;

  List<dynamic> supportersId;
  String postContentType;

  bool approved;

  List<String> searchKeywords;

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
    this.isUsedForHelp,
    this.chosenCompany,
    this.supportersId,
    this.isLocatedInYoutube,
    this.postContentType,
    this.approved,
    this.searchKeywords,
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
        isUsedForHelp = json['isUsedForHelp'] ?? false,
        chosenCompany = json['chosenCompany'] ?? "",
        isLocatedInYoutube = json['isLocatedInYoutube'],
        supportersId = json['supportersId'],
        postContentType = json['postContentType'],
        approved = json['approved'],
        searchKeywords = json['searchKeywords']?.cast<String>() ?? [];

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

    data['isUsedForHelp'] = this.isUsedForHelp ?? false;
    data['chosenCompany'] = this.chosenCompany ?? "";
    data['dodCounter'] = this.dodCounter ?? 0;
    data['supportersId'] = this.supportersId;
    data['isLocatedInYoutube'] = this.isLocatedInYoutube;
    data['postContentType'] = this.postContentType;
    data['approved'] = this.approved;
    data['searchKeywords'] = this.searchKeywords;
    return data;
  }

  @override
  String toString() {
    return 'PostModel{postId: $postId, ownerType: $ownerType,approved: $approved , ownerId: $ownerId, postCategory: $postCategory, isLocatedInYoutube: $isLocatedInYoutube,postContentType: $postContentType, postTitle: $postTitle, postDescription: $postDescription, postContentURL: $postContentURL, postDate: $postDate, isVideo: $isVideo,searchKeywords: $searchKeywords}';
  }
}
