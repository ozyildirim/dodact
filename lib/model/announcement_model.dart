import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  String announcementID;
  String announcementTitle;
  String announcementDescription;
  String announcementImage;
  DateTime creationDate;
  DateTime expirationDate;
  bool visible;
  bool isReference;
  String referenceURL;

  AnnouncementModel({
    this.announcementID,
    this.announcementTitle,
    this.announcementDescription,
    this.creationDate,
    this.expirationDate,
    this.visible,
    this.isReference,
    this.referenceURL,
  });

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    announcementID = json['announcementID'];
    announcementTitle = json['announcementTitle'];
    announcementDescription = json['announcementDescription'];
    announcementImage = json['announcementImage'];
    creationDate = (json['creationDate'] as Timestamp).toDate();
    expirationDate = (json['expirationDate'] as Timestamp).toDate();
    visible = json['visible'];
    isReference = json['isReference'] ?? false;
    referenceURL = json['referenceURL'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['announcementID'] = this.announcementID;
    data['announcementTitle'] = this.announcementTitle;
    data['announcementDescription'] = this.announcementDescription;
    data['announcementImage'] = this.announcementImage;
    data['creationDate'] = this.creationDate ?? FieldValue.serverTimestamp();
    data['expirationDate'] =
        this.expirationDate ?? FieldValue.serverTimestamp();
    data['visible'] = this.visible;
    data['isReference'] = this.isReference;
    data['referenceURL'] = this.referenceURL;
    return data;
  }
}
