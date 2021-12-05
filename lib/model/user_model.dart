import 'package:cloud_firestore/cloud_firestore.dart';

class UserObject {
  String uid;
  String nameSurname;
  String email;
  String username;
  DateTime userRegistrationDate;
  String telephoneNumber;
  String profilePictureURL;
  int experiencePoint;
  bool newUser;
  String location;
  List<dynamic> rosettes;
  String mainInterest;
  String userDescription;
  String education;
  String profession;
  bool isVerified;
  List<String> blockedUserList;

  List<String> favoritedPosts = [];
  List<Map<String, dynamic>> interests;
  List<String> followers = [];
  List<String> following = [];

  //Permissions
  Map<String, dynamic> permissions = {
    'create_post': false,
    'create_event': false,
    'create_group': false,
    'create_room': false,
    'create_stream': false,
    'create_comment': true,
  };

  //Privacy Settings
  Map<String, dynamic> privacySettings = {
    'hide_mail': false,
    'hide_phone': false,
    'hide_location': false,
    'hide_education': false,
    'hide_profession': false,
  };

  //Social Media Links
  Map<String, dynamic> socialMediaLinks = {
    'instagram': '',
    'youtube': '',
    'dribbble': '',
    'linkedin': '',
    'soundcloud': '',
    'pinterest': '',
    'opensea': '',
  };

  //Notification Settings
  Map<String, dynamic> notificationSettings = {
    'allow_comment_notifications': true,
    'allow_post_like_notifications': true,
    'allow_group_comment_notifications': true,
    'allow_group_invitation_notifications': true,
    'allow_group_announcement_notifications': true,
    'allow_group_post_notifications': true,
    'allow_private_message_notifications': true,
  };

  List<String> searchKeywords;

  UserObject({
    this.uid,
    this.email,
    this.username,
    this.nameSurname,
    this.userRegistrationDate,
    this.telephoneNumber,
    this.profilePictureURL,
    this.experiencePoint,
    this.location,
    this.rosettes,
    this.mainInterest,
    this.newUser,
    this.userDescription,
    this.interests,
    this.permissions,
    this.privacySettings,
    this.socialMediaLinks,
    this.notificationSettings,
    this.education,
    this.blockedUserList,
    this.profession,
    this.searchKeywords,
    this.isVerified,
  });

  Map<String, dynamic> defaultPermissions = {
    'create_post': false,
    'create_event': false,
    'create_group': false,
    'create_room': false,
    'create_stream': false,
    'create_comment': true,
  };

  Map<String, dynamic> defaultPrivacySettings = {
    'hide_mail': false,
    'hide_phone': false,
    'hide_location': false,
    'hide_education': false,
    'hide_profession': false,
  };

  Map<String, dynamic> defaultSocialMediaLinks = {
    'instagram': '',
    'youtube': '',
    'dribbble': '',
    'linkedin': '',
    'soundcloud': '',
    'pinterest': '',
    'opensea': '',
  };

  Map<String, dynamic> defaultNotificationSettings = {
    'allow_comment_notifications': true,
    'allow_post_like_notifications': false,
    'allow_group_comment_notifications': true,
    'allow_group_invitation_notifications': true,
    'allow_group_announcement_notifications': true,
    'allow_group_post_notifications': true,
    'allow_private_message_notifications': true,
  };

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> userData = new Map<String, dynamic>();
    userData['uid'] = this.uid;
    userData['email'] = this.email;
    userData['username'] = this.username;
    userData['nameSurname'] = this.nameSurname;
    userData['userRegistrationDate'] = FieldValue.serverTimestamp();
    userData['telephoneNumber'] = this.telephoneNumber ?? '';
    userData['profilePictureURL'] = this.profilePictureURL;
    userData['experiencePoint'] = this.experiencePoint ?? 0;

    userData['location'] = this.location;
    userData['mainInterest'] = this.mainInterest;
    userData['rosettes'] = this.rosettes;

    userData['interests'] = this.interests;
    userData['permissions'] = defaultPermissions;
    userData['privacySettings'] = defaultPrivacySettings;
    userData['socialMediaLinks'] = defaultSocialMediaLinks;
    userData['notificationSettings'] = defaultNotificationSettings;
    userData['newUser'] = this.newUser ?? true;
    userData['userDescription'] = this.userDescription ?? '';
    userData['blockedUserList'] = this.blockedUserList ?? [];
    userData['education'] = this.education ?? '';
    userData['profession'] = this.profession ?? '';
    userData['searchKeywords'] = this.searchKeywords ?? [];
    userData['isVerified'] = this.isVerified ?? false;

    return userData;
  }

  UserObject.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    uid = doc.data()['uid'] ?? '';
    email = doc.data()['email'] ?? '';
    username = doc.data()['username'] ?? '';
    nameSurname = doc.data()['nameSurname'] ?? '';
    userRegistrationDate =
        (doc.data()['userRegistrationDate'] as Timestamp).toDate() ?? '';
    telephoneNumber = doc.data()['telephoneNumber'] ?? '';
    profilePictureURL = doc.data()['profilePictureURL'];
    experiencePoint = doc.data()['experiencePoint'] ?? '';
    location = doc.data()['location'];
    rosettes = doc.data()['rosettes'];
    mainInterest = doc.data()['mainInterest'] ?? "";
    interests = doc.data()['interests']?.cast<Map<String, dynamic>>();
    blockedUserList = doc.data()['blockedUserList']?.cast<String>() ?? [];

    permissions = doc.data()['permissions'] ?? this.permissions;

    privacySettings = doc.data()['privacySettings'] ?? this.privacySettings;

    socialMediaLinks = doc.data()['socialMediaLinks'] ?? this.socialMediaLinks;

    notificationSettings =
        doc.data()['notificationSettings'] ?? this.notificationSettings;

    userDescription = doc.data()['userDescription'] ?? '';
    newUser = doc.data()['newUser'] ?? true;
    education = doc.data()['education'] ?? '';
    profession = doc.data()['profession'] ?? '';
    searchKeywords = doc.data()['searchKeywords']?.cast<String>() ?? [];
    isVerified = doc.data()['isVerified'] ?? false;
  }

  String toString() {
    return 'UserObject{uid: $uid,permissions: $permissions, email: $email, newUser: $newUser, mainInterest: $mainInterest, verified: $isVerified, username: $username, userDescription: $userDescription, nameSurname: $nameSurname,location:$location,userRegistrationDate: $userRegistrationDate, telephoneNumber: $telephoneNumber, profilePictureURL: $profilePictureURL, experiencePoint: $experiencePoint,searchKeywords: $searchKeywords},';
  }
}
