import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String groupId;
  String groupName;
  String groupCategory;
  String founderId;
  int numOfMembers;
  String groupDescription;
  String groupProfilePicture;
  List<String> groupPhotos;
  List<String> groupPostIDs;
  List<String> groupMemberList;
  DateTime creationDate;
  List<String> eventIDs;
  String groupLocation;
  List<String> groupPosts;

  GroupModel(
      {this.groupId,
      this.groupName,
      this.groupCategory,
      this.founderId,
      this.numOfMembers,
      this.groupDescription,
      this.groupProfilePicture,
      this.groupPhotos,
      this.groupPostIDs,
      this.groupMemberList,
      this.creationDate,
      this.eventIDs,
      this.groupLocation,
      this.groupPosts});

  GroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupCategory = json['groupCategory'];
    founderId = json['founderId'];
    numOfMembers = json['numOfMembers'];
    groupDescription = json['groupDescription'];
    groupProfilePicture = json['groupProfilePicture'];
    groupPhotos = json['groupPhotos']?.cast<String>();
    groupPostIDs = json['groupPostIDs']?.cast<String>();
    groupMemberList = json['groupMemberList']?.cast<String>();
    creationDate = (json['creationDate'] as Timestamp).toDate();
    eventIDs = json['eventIDs'];
    groupLocation = json['groupLocation'];
    groupPosts = json['groupPosts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['groupName'] = this.groupName;
    data['groupCategory'] = this.groupCategory;
    data['founderId'] = this.founderId;
    data['numOfMembers'] = this.numOfMembers;
    data['groupDescription'] = this.groupDescription;
    data['groupProfilePicture'] = this.groupProfilePicture;
    data['groupPhotos'] = this.groupPhotos;
    data['groupPostIDs'] = this.groupPostIDs;
    data['groupMemberList'] = this.groupMemberList;
    data['creationDate'] = FieldValue.serverTimestamp();
    data['eventIDs'] = this.eventIDs;
    data['groupLocation'] = this.groupLocation;
    data['groupPosts'] = this.groupPosts;
    return data;
  }

  @override
  String toString() {
    return 'GroupModel{groupId: $groupId, groupName: $groupName, groupCategory: $groupCategory, groupPosts: $groupPosts, founderId: $founderId, numOfMembers: $numOfMembers, groupDescription: $groupDescription, groupProfilePicture: $groupProfilePicture, groupPhotos: $groupPhotos, groupPostIDs: $groupPostIDs, groupMemberList: $groupMemberList, creationDate: $creationDate, eventIDs: $eventIDs}';
  }
}
