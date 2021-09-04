import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String groupId;
  String groupName;
  String groupCategory;
  String founderId;

  String groupDescription;
  String groupProfilePicture;
  List<String> groupPhotos;

  List<String> groupMemberList;
  DateTime creationDate;
  List<String> events;
  String groupLocation;
  List<String> groupPosts;

  GroupModel({
    this.groupId,
    this.groupName,
    this.groupCategory,
    this.founderId,
    this.groupDescription,
    this.groupProfilePicture,
    this.groupPhotos,
    this.groupMemberList,
    this.creationDate,
    this.events,
    this.groupLocation,
  });

  GroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupCategory = json['groupCategory'];
    founderId = json['founderId'];
    groupDescription = json['groupDescription'];
    groupProfilePicture = json['groupProfilePicture'];
    groupPhotos = json['groupPhotos']?.cast<String>();
    groupPosts = json['groupPosts']?.cast<String>();
    groupMemberList = json['groupMemberList']?.cast<String>();
    creationDate = (json['creationDate'] as Timestamp).toDate();
    events = json['events']?.cast<String>();
    groupLocation = json['groupLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['groupName'] = this.groupName;
    data['groupCategory'] = this.groupCategory;
    data['founderId'] = this.founderId;
    data['groupDescription'] = this.groupDescription;
    data['groupProfilePicture'] = this.groupProfilePicture;
    data['groupPhotos'] = this.groupPhotos;
    data['groupPosts'] = this.groupPosts;
    data['groupMemberList'] = this.groupMemberList;
    data['creationDate'] = FieldValue.serverTimestamp();
    data['events'] = this.events;
    data['groupLocation'] = this.groupLocation;

    return data;
  }

  @override
  String toString() {
    return 'GroupModel{groupId: $groupId, groupName: $groupName, groupCategory: $groupCategory, founderId: $founderId, groupDescription: $groupDescription, groupProfilePicture: $groupProfilePicture, groupPhotos: $groupPhotos, groupMemberList: $groupMemberList, creationDate: $creationDate, events: $events}';
  }
}
