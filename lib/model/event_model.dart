import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String ownerId;
  String title;
  String description;
  String eventURL;
  DateTime creationDate;
  DateTime startDate;
  DateTime endDate;
  String category;
  List<String> eventImages;
  String locationCoordinates;
  String city;
  bool isOnline;
  String eventType;
  bool isDone;
  String ownerType;
  bool visible;

  List<String> searchKeywords;

  EventModel(
      {this.id,
      this.ownerId,
      this.title,
      this.description,
      this.city,
      this.eventURL,
      this.creationDate,
      this.startDate,
      this.endDate,
      this.category,
      this.eventImages,
      this.isOnline,
      this.locationCoordinates,
      this.eventType,
      this.isDone,
      this.ownerType,
      this.searchKeywords,
      this.visible});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['eventId'];
    ownerId = json['ownerId'];
    title = json['title'];
    description = json['description'];
    city = json['city'];
    eventURL = json['eventURL'];
    creationDate = (json['creationDate'] as Timestamp).toDate();
    startDate = (json['startDate'] as Timestamp).toDate();
    endDate = (json['endDate'] as Timestamp).toDate();
    category = json['category'];
    eventImages = json['eventImages']?.cast<String>() ?? [];
    isOnline = json['isOnline'];
    locationCoordinates = json['locationCoordinates'];

    eventType = json['eventType'];
    isDone = json['isDone'];
    ownerType = json['ownerType'];

    searchKeywords = json['searchKeywords']?.cast<String>() ?? [];
    visible = json['visible'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.id;
    data['ownerId'] = this.ownerId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['city'] = this.city;
    data['eventURL'] = this.eventURL;
    data['creationDate'] = this.creationDate ?? FieldValue.serverTimestamp();
    data['startDate'] = this.startDate ?? FieldValue.serverTimestamp();
    data['endDate'] = this.endDate ?? FieldValue.serverTimestamp();
    data['category'] = this.category;
    data['locationCoordinates'] = this.locationCoordinates;

    data['eventImages'] = this.eventImages;
    data['isOnline'] = this.isOnline;
    data['eventType'] = this.eventType;
    data['isDone'] = this.isDone;
    data['ownerType'] = this.ownerType;
    data['searchKeywords'] = this.searchKeywords;
    data['visible'] = this.visible;
    return data;
  }

  @override
  String toString() {
    return 'EventModel{eventId: $id,eventType: $eventType, eventLocationCoordinates: $locationCoordinates, eventCreationDate: $creationDate, ownerId: $ownerId,  eventTitle: $title, eventDescription: $description, city: $city, eventURL: $eventURL,eventStartDate: $startDate, eventEndDate: $endDate, eventCategory: $category, eventImages: $eventImages, isOnline: $isOnline, isDone: $isDone, ownerType: $ownerType, searchKeywords: $searchKeywords}';
  }
}
