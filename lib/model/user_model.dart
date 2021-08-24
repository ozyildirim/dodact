import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/model/interest_model.dart';

class UserObject {
  String uid;
  String nameSurname;
  String email;
  String username;
  DateTime userRegistrationDate;
  String telephoneNumber;
  String profilePictureURL;
  int experiencePoint;
  List<String> groupIDs;
  List<String> ownedGroupIDs;
  List<String> postIDs;
  List<String> eventIDs;
  String location;
  List<dynamic> rosettes;
  String mainInterest;

  String twitterUsername;
  String instagramUsername;
  String youtubeLink;
  String dribbbleLink;
  String linkedInLink;
  String soundcloudLink;
  bool newUser;
  String userDescription;
  String education;
  String profession;

  List<String> favoritedPosts = [];
  List<InterestModel> interests;

  //PrivacySettings
  bool hiddenMail;
  bool hiddenLocation;
  bool hiddenNameSurname;

  UserObject({
    this.uid,
    this.email,
    this.username,
    this.nameSurname,
    this.userRegistrationDate,
    this.telephoneNumber,
    this.profilePictureURL,
    this.experiencePoint,
    this.groupIDs,
    this.ownedGroupIDs,
    this.postIDs,
    this.eventIDs,
    this.location,
    this.rosettes,
    this.mainInterest,
    this.twitterUsername,
    this.instagramUsername,
    this.youtubeLink,
    this.dribbbleLink,
    this.linkedInLink,
    this.soundcloudLink,
    this.hiddenMail,
    this.hiddenLocation,
    this.hiddenNameSurname,
    this.newUser,
    this.userDescription,
    this.education,
    this.profession,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> userData = new Map<String, dynamic>();
    userData['uid'] = this.uid;
    userData['email'] = this.email;
    userData['username'] = this.username;
    userData['nameSurname'] = this.nameSurname ?? 'Dodact Sanatçısı';
    userData['userRegistrationDate'] = FieldValue.serverTimestamp();
    userData['telephoneNumber'] = this.telephoneNumber ?? '';
    userData['profilePictureURL'] = this.profilePictureURL;
    userData['experiencePoint'] = this.experiencePoint ?? 0;
    userData['groupIDs'] = this.groupIDs;
    userData['ownedGroupIDs'] = this.ownedGroupIDs;
    userData['postIDs'] = this.postIDs;
    userData['eventIDs'] = this.eventIDs;
    userData['location'] = this.location;
    userData['mainInterest'] = this.mainInterest;
    userData['rosettes'] = this.rosettes;
    userData['twitterUsername'] = this.twitterUsername;
    userData['instagramUsername'] = this.instagramUsername;
    userData['youtubeLink'] = this.youtubeLink;
    userData['dribbbleLink'] = this.dribbbleLink;
    userData['linkedInLink'] = this.linkedInLink;
    userData['soundcloudLink'] = this.soundcloudLink;
    userData['hiddenMail'] = this.hiddenMail;
    userData['hiddenLocation'] = this.hiddenLocation;
    userData['hiddenNameSurname'] = this.hiddenNameSurname;
    userData['newUser'] = this.newUser ?? true;
    userData['userDescription'] = this.userDescription ?? '';
    userData['education'] = this.education ?? '';
    userData['profession'] = this.profession ?? '';

    return userData;
  }

  UserObject.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        email = map['email'],
        username = map['username'],
        nameSurname = map['nameSurname'],
        userRegistrationDate =
            (map['userRegistrationDate'] as Timestamp).toDate(),
        telephoneNumber = map['telephoneNumber'],
        profilePictureURL = map['profilePictureURL'],
        experiencePoint = map['experiencePoint'],
        groupIDs = map['groupIDs'],
        ownedGroupIDs = map['ownedGroupIDs'] ?? [],
        postIDs = map['postIDs'] ?? [],
        eventIDs = map['eventIDs'] ?? [],
        location = map['location'],
        rosettes = map['rosettes'],
        mainInterest = map['mainInterest'] ?? "",
        twitterUsername = map['twitterUsername'],
        instagramUsername = map['instagramUsername'],
        youtubeLink = map['youtubeLink'],
        dribbbleLink = map['dribbbleLink'],
        linkedInLink = map['linkedInLink'],
        soundcloudLink = map['soundcloudLink'],
        hiddenMail = map['hiddenMail'],
        hiddenLocation = map['hiddenLocation'],
        hiddenNameSurname = map['hiddenNameSurname'],
        newUser = map['newUser'] ?? true,
        education = map['education'] ?? '',
        userDescription = map['userDescription'] ?? '',
        profession = map['profession'] ?? '';

  UserObject.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    uid = doc.data()['uid'] ?? '';
    email = doc.data()['email'] ?? '';
    username = doc.data()['username'] ?? '';
    nameSurname = doc.data()['nameSurname'] ?? '';
    userRegistrationDate =
        (doc.data()['userRegistrationDate'] as Timestamp).toDate() ?? '';
    telephoneNumber = doc.data()['telephoneNumber'] ?? '';
    profilePictureURL = doc.data()['profilePictureURL'] ?? '';
    experiencePoint = doc.data()['experiencePoint'] ?? '';
    groupIDs = doc.data()['groupIDs'] ?? [];
    ownedGroupIDs = doc.data()['ownedGroupIDs'] ?? [];
    postIDs = doc.data()['postIDs']?.cast<String>() ?? [];
    eventIDs = doc.data()['eventIDs']?.cast<String>() ?? [];
    location = doc.data()['location'];
    rosettes = doc.data()['rosettes'];
    mainInterest = doc.data()['mainInterest'] ?? "";
    twitterUsername = doc.data()['twitterUsername'];
    instagramUsername = doc.data()['instagramUsername'];
    youtubeLink = doc.data()['youtubeLink'];
    dribbbleLink = doc.data()['dribbbleLink'];
    linkedInLink = doc.data()['linkedInLink'];
    soundcloudLink = doc.data()['soundcloudLink'];
    hiddenMail = doc.data()['hiddenMail'];
    hiddenLocation = doc.data()['hiddenLocation'];
    hiddenNameSurname = doc.data()['hiddenNameSurname'];
    userDescription = doc.data()['userDescription'] ?? '';
    newUser = doc.data()['newUser'] ?? true;
    education = doc.data()['education'] ?? '';
    profession = doc.data()['profession'] ?? '';
  }

  String toString() {
    return 'UserObject{uid: $uid, email: $email,newUser: $newUser,mainInterest: $mainInterest, username: $username,userDescription: $userDescription, nameSurname: $nameSurname,location:$location,hiddenMail: $hiddenMail,hiddenNameSurname: $hiddenNameSurname,hiddenLocation: $hiddenLocation, linkedinLink: $linkedInLink,dribbbleLink: $dribbbleLink,soundcloudLink: $soundcloudLink,twitterUsername: $twitterUsername,instagramUsername: $instagramUsername,youtubeLink: $youtubeLink,userRegistrationDate: $userRegistrationDate, telephoneNumber: $telephoneNumber, profilePictureURL: $profilePictureURL, experiencePoint: $experiencePoint, groupIDs: $groupIDs,  postIDs: $postIDs, eventIDs: $eventIDs},';
  }
}
