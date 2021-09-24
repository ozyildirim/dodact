// To parse this JSON data, do
//
//     final invitationModel = invitationModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

InvitationModel invitationModelFromJson(String str) =>
    InvitationModel.fromJson(json.decode(str));

String invitationModelToJson(InvitationModel data) =>
    json.encode(data.toJson());

class InvitationModel {
  InvitationModel({
    this.senderId,
    this.receiverId,
    this.type,
    // this.invitationDate,
  });

  String invitationId;
  String senderId;
  String receiverId;
  String type;
  // DateTime invitationDate;

  factory InvitationModel.fromJson(Map<String, dynamic> json) =>
      InvitationModel(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        type: json["type"],
        // invitationDate: (json["invitationDate"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "receiverId": receiverId,
        "type": type,
        // "invitationDate": invitationDate ?? FieldValue.serverTimestamp(),
      };
}
