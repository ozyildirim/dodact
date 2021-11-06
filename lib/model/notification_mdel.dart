// To parse this JSON data, do
//
//     final notification = notificationFromMap(jsonString);

import 'dart:convert';

NotificationModel notificationFromMap(String str) =>
    NotificationModel.fromMap(json.decode(str));

String notificationToMap(NotificationModel data) => json.encode(data.toMap());

class NotificationModel {
  NotificationModel({
    this.notificationId,
    this.subjectId,
    this.responsibleId,
    this.type,
    this.title,
    this.message,
    this.date,
    this.isRead,
  });

  String notificationId;
  String subjectId;
  String responsibleId;
  String type;
  String title;
  String message;
  DateTime date;
  bool isRead;

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        notificationId: json["notificationId"],
        subjectId: json["subjectId"],
        responsibleId: json["responsibleId"],
        type: json["type"],
        title: json["title"],
        message: json["message"],
        date: json["date"],
        isRead: json["isRead"],
      );

  Map<String, dynamic> toMap() => {
        "notificationId": notificationId,
        "subjectId": subjectId,
        "responsibleId": responsibleId,
        "type": type,
        "title": title,
        "message": message,
        "date": date,
        "isRead": isRead,
      };
}
