import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/model/dodder_model.dart';

class PostModel {
  String postId;
  String ownerType;
  String ownerId;
  List<String> postCategories;
  String postTitle;
  String postDescription;
  String postContentURL;
  DateTime postDate;

  int dodCounter;
  int reportCounter;
  List<DodderModel> dodders;
  bool isVideo;
  bool isLocatedInYoutube;
  String postContentType;
  bool visible;
  String blurHash;

  List<String> searchKeywords;

  PostModel(
      {this.postId,
      this.ownerType,
      this.ownerId,
      this.postCategories,
      this.postDate,
      this.postTitle,
      this.postDescription,
      this.postContentURL,
      this.isVideo,
      this.dodCounter,
      this.reportCounter,
      this.isLocatedInYoutube,
      this.postContentType,
      this.searchKeywords,
      this.visible,
      this.blurHash});

  PostModel.fromJson(Map<String, dynamic> json)
      : postId = json['postId'],
        ownerType = json['ownerType'],
        ownerId = json['ownerId'],
        postCategories = json['postCategories']?.cast<String>() ?? [],
        postDate = (json['postDate'] as Timestamp).toDate(),
        postTitle = json['postTitle'],
        postDescription = json['postDescription'],
        postContentURL = json['postContentURL'],
        isVideo = json['isVideo'],
        dodCounter = json['dodCounter'] ?? 0,
        reportCounter = json['reportCounter'] ?? 0,
        isLocatedInYoutube = json['isLocatedInYoutube'],
        postContentType = json['postContentType'],
        visible = json['visible'],
        searchKeywords = json['searchKeywords']?.cast<String>() ?? [],
        blurHash = json['blurHash'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['ownerType'] = this.ownerType;
    data['ownerId'] = this.ownerId;
    data['postCategories'] = this.postCategories ?? [];
    data['postDate'] = this.postDate ?? FieldValue.serverTimestamp();
    data['postTitle'] = this.postTitle;
    data['postDescription'] = this.postDescription;
    data['postContentURL'] = this.postContentURL;
    data['isVideo'] = this.isVideo;

    data['dodCounter'] = this.dodCounter ?? 0;
    data['reportCounter'] = this.reportCounter ?? 0;
    data['isLocatedInYoutube'] = this.isLocatedInYoutube;
    data['postContentType'] = this.postContentType;
    data['visible'] = this.visible;
    data['searchKeywords'] = this.searchKeywords;
    data['blurHash'] = this.blurHash;
    return data;
  }

  @override
  String toString() {
    return 'PostModel{postId: $postId, ownerType: $ownerType, ownerId: $ownerId, isLocatedInYoutube: $isLocatedInYoutube,postContentType: $postContentType, postTitle: $postTitle, postDescription: $postDescription, postContentURL: $postContentURL, postDate: $postDate, isVideo: $isVideo,searchKeywords: $searchKeywords, reportCounter: $reportCounter}';
  }
}
