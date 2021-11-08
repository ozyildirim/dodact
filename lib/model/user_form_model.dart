// To parse this JSON data, do
//
//     final userFormModel = userFormModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserFormModel userFormModelFromJson(String str) =>
    UserFormModel.fromJson(json.decode(str));

String userFormModelToJson(UserFormModel data) => json.encode(data.toJson());

class UserFormModel {
  UserFormModel({
    this.formId,
    this.userId,
    this.type,
    this.message,
    this.creationDate,
  });

  String formId;
  String userId;
  String type;
  String message;
  DateTime creationDate;

  factory UserFormModel.fromJson(Map<String, dynamic> json) => UserFormModel(
        formId: json["formId"],
        userId: json["userId"],
        type: json["type"],
        message: json["message"],
        creationDate: (json['creationDate'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "formId": formId,
        "userId": userId,
        "type": type,
        "message": message,
        "creationDate": creationDate ?? FieldValue.serverTimestamp(),
      };
}
