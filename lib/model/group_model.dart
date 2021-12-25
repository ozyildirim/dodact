import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/model/invitation_model.dart';

class GroupModel {
  String groupId;
  String groupName;

  String groupSubtitle;
  String managerId;
  String groupDescription;
  String groupProfilePicture;
  List<String> groupMedia;
  List<String> groupMemberList;
  DateTime creationDate;
  String groupLocation;
  InvitationModel invitations;
  List<String> selectedInterests;
  String mainInterest;
  bool visible;

  GroupModel({
    this.groupId,
    this.groupName,
    this.groupSubtitle,
    this.managerId,
    this.groupDescription,
    this.groupProfilePicture,
    this.groupMedia,
    this.groupMemberList,
    this.selectedInterests,
    this.mainInterest,
    this.creationDate,
    this.groupLocation,
    this.visible,
  });

  GroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];

    groupSubtitle = json['groupSubtitle'];
    managerId = json['managerId'];
    groupDescription = json['groupDescription'];
    groupProfilePicture = json['groupProfilePicture'];
    groupMedia = json['groupMedia']?.cast<String>();
    groupMemberList = json['groupMemberList']?.cast<String>();

    selectedInterests = json['selectedInterests']?.cast<String>() ?? [];
    mainInterest = json['mainInterest'] ?? "";
    creationDate = (json['creationDate'] as Timestamp).toDate();
    groupLocation = json['groupLocation'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['groupName'] = this.groupName;

    data['groupSubtitle'] = this.groupSubtitle;
    data['managerId'] = this.managerId;
    data['groupDescription'] = this.groupDescription;
    data['groupProfilePicture'] = this.groupProfilePicture;
    data['groupMedia'] = this.groupMedia;
    data['groupMemberList'] = this.groupMemberList;

    data['selectedInterests'] = this.selectedInterests;
    data['mainInterest'] = this.mainInterest;
    data['creationDate'] = FieldValue.serverTimestamp();
    data['groupLocation'] = this.groupLocation;
    data['visible'] = this.visible;

    return data;
  }

  @override
  String toString() {
    return 'GroupModel{groupId: $groupId, groupName: $groupName,selectedInterests: $selectedInterests, groupLocation: $groupLocation, founderId: $managerId, groupDescription: $groupDescription, groupProfilePicture: $groupProfilePicture, groupMedia: $groupMedia, groupMemberList: $groupMemberList, creationDate: $creationDate}';
  }
}
