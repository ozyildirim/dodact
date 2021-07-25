// To parse this JSON data, do
//
//     final requestModel = requestModelFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

RequestModel requestModelFromMap(String str) =>
    RequestModel.fromMap(json.decode(str));

String requestModelToMap(RequestModel data) => json.encode(data.toMap());

class RequestModel {
  RequestModel({
    this.requestId,
    this.requestFor,
    this.requestOwnerId,
    this.requestDate,
    this.subjectId,
    this.isExamined,
    this.isApproved,
    this.rejectionMessage,
  });

  String requestId;
  String requestFor;
  String requestOwnerId;
  DateTime requestDate;
  String subjectId;
  bool isExamined;
  bool isApproved;
  String rejectionMessage;

  factory RequestModel.fromMap(Map<String, dynamic> json) => RequestModel(
        requestId: json["requestId"],
        requestFor: json["requestFor"],
        requestOwnerId: json["requestOwnerId"],
        requestDate: (json["requestDate"] as Timestamp).toDate(),
        subjectId: json["subjectId"],
        isExamined: json["isExamined"],
        isApproved: json["isApproved"],
        rejectionMessage: json["rejectionMessage"],
      );

  Map<String, dynamic> toMap() => {
        "requestId": requestId,
        "requestFor": requestFor,
        "requestOwnerId": requestOwnerId,
        "requestDate": requestDate,
        "subjectId": subjectId,
        "isExamined": isExamined,
        "isApproved": isApproved,
        "rejectionMessage": rejectionMessage,
      };
}
