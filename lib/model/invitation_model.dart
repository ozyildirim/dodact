// To parse this JSON data, do
//
//     final invitationModel = invitationModelFromJson(jsonString);

import 'dart:convert';

InvitationModel invitationModelFromJson(String str) =>
    InvitationModel.fromJson(json.decode(str));

String invitationModelToJson(InvitationModel data) =>
    json.encode(data.toJson());

class InvitationModel {
  InvitationModel({
    this.invitationId,
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
        invitationId: json["invitationId"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        type: json["type"],
        // invitationDate: (json["invitationDate"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "invitationId": invitationId,
        "senderId": senderId,
        "receiverId": receiverId,
        "type": type,
        // "invitationDate": invitationDate ?? FieldValue.serverTimestamp(),
      };
}
