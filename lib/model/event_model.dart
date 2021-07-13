import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EventModel {
  String eventId;
  String ownerId;
  String eventTitle;
  String eventDescription;
  String location;
  String eventURL;
  DateTime eventDate;
  String eventCategory;
  List<String> eventImages;
  bool isOnline;
  bool isDone;
  String ownerType;

  EventModel(
      {@required this.eventId,
      @required this.ownerId,
      this.eventTitle,
      this.eventDescription,
      this.location,
      this.eventURL,
      this.eventDate,
      this.eventCategory,
      this.eventImages,
      this.isOnline,
      this.isDone,
      this.ownerType});

  EventModel.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    ownerId = json['ownerId'];
    eventTitle = json['eventTitle'];
    eventDescription = json['eventDescription'];
    location = json['location'];
    eventURL = json['eventURL'];
    eventDate = (json['eventDate'] as Timestamp).toDate();
    eventCategory = json['eventCategory'];
    eventImages = json['eventImages'].cast<String>();
    isOnline = json['isOnline'];
    isDone = json['isDone'];
    ownerType = json['ownerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.eventId;
    data['ownerId'] = this.ownerId;
    data['eventTitle'] = this.eventTitle;
    data['eventDescription'] = this.eventDescription;
    data['location'] = this.location;
    data['eventURL'] = this.eventURL;
    data['eventDate'] = this.eventDate ?? FieldValue.serverTimestamp();
    data['eventCategory'] = this.eventCategory;
    data['eventImages'] = this.eventImages;
    data['isOnline'] = this.isOnline;
    data['isDone'] = this.isDone;
    data['ownerType'] = this.ownerType;
    return data;
  }

  @override
  String toString() {
    return 'EventModel{eventId: $eventId, ownerId: $ownerId, eventTitle: $eventTitle, eventDescription: $eventDescription, location: $location, eventURL: $eventURL, eventDate: $eventDate, eventCategory: $eventCategory, eventImages: $eventImages, isOnline: $isOnline, isDone: $isDone, ownerType: $ownerType}';
  }
}
