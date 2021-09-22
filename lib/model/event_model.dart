import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  bool approved;
  String eventId;
  String ownerId;
  String eventTitle;
  String eventDescription;
  String eventURL;
  DateTime eventCreationDate;
  DateTime eventStartDate;
  DateTime eventEndDate;
  String eventCategory;
  List<String> eventImages;
  String eventLocationCoordinates;
  String eventAddress;
  String city;
  bool isOnline;
  String eventType;
  bool isDone;
  String ownerType;
  bool isUsedForHelp;
  String chosenCompanyForHelp;

  List<String> searchKeywords;

  EventModel(
      {this.eventId,
      this.ownerId,
      this.approved,
      this.eventTitle,
      this.eventDescription,
      this.city,
      this.eventURL,
      this.eventCreationDate,
      this.eventStartDate,
      this.eventEndDate,
      this.eventCategory,
      this.eventImages,
      this.isOnline,
      this.eventLocationCoordinates,
      this.eventAddress,
      this.eventType,
      this.isDone,
      this.ownerType,
      this.isUsedForHelp,
      this.chosenCompanyForHelp,
      this.searchKeywords});

  EventModel.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    approved = json['approved'];
    ownerId = json['ownerId'];
    eventTitle = json['eventTitle'];
    eventDescription = json['eventDescription'];
    city = json['city'];
    eventURL = json['eventURL'];
    eventCreationDate = (json['eventCreationDate'] as Timestamp).toDate();
    eventStartDate = (json['eventStartDate'] as Timestamp).toDate();
    eventEndDate = (json['eventEndDate'] as Timestamp).toDate();
    eventCategory = json['eventCategory'];
    eventImages = json['eventImages']?.cast<String>() ?? [];
    isOnline = json['isOnline'];
    eventLocationCoordinates = json['eventLocationCoordinates'];
    eventAddress = json['eventAddress'];
    eventType = json['eventType'];
    isDone = json['isDone'];
    ownerType = json['ownerType'];
    isUsedForHelp = json['isUsedForHelp'] ?? false;
    chosenCompanyForHelp = json['chosenCompanyForHelp'] ?? "";
    searchKeywords = json['searchKeywords']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.eventId;
    data['approved'] = this.approved;
    data['ownerId'] = this.ownerId;
    data['eventTitle'] = this.eventTitle;
    data['eventDescription'] = this.eventDescription;
    data['city'] = this.city;
    data['eventURL'] = this.eventURL;
    data['eventCreationDate'] =
        this.eventCreationDate ?? FieldValue.serverTimestamp();
    data['eventStartDate'] =
        this.eventStartDate ?? FieldValue.serverTimestamp();
    data['eventEndDate'] = this.eventEndDate ?? FieldValue.serverTimestamp();
    data['eventCategory'] = this.eventCategory;
    data['eventLocationCoordinates'] = this.eventLocationCoordinates;
    data['eventAddress'] = this.eventAddress ?? "";
    data['eventImages'] = this.eventImages;
    data['isOnline'] = this.isOnline;
    data['eventType'] = this.eventType;
    data['isDone'] = this.isDone;
    data['ownerType'] = this.ownerType;
    data['isUsedForHelp'] = this.isUsedForHelp;
    data['chosenCompanyForHelp'] = this.chosenCompanyForHelp;
    data['searchKeywords'] = this.searchKeywords;
    return data;
  }

  @override
  String toString() {
    return 'EventModel{eventId: $eventId,eventType: $eventType,approved: $approved, eventLocationCoordinates: $eventLocationCoordinates, eventCreationDate: $eventCreationDate, ownerId: $ownerId, eventAddress: $eventAddress, eventTitle: $eventTitle, eventDescription: $eventDescription, city: $city, eventURL: $eventURL,eventStartDate: $eventStartDate, eventEndDate: $eventEndDate, eventCategory: $eventCategory, eventImages: $eventImages, isOnline: $isOnline, isDone: $isDone, ownerType: $ownerType, searchKeywords: $searchKeywords}';
  }
}
