import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomModel {
  String roomId;
  List<String> users;
  DateTime roomCreationDate;

  ChatroomModel({this.roomId, this.users, this.roomCreationDate});

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        users = json['users']?.cast<String>(),
        roomCreationDate = (json['roomCreationDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['users'] = this.users;
    data['roomCreationDate'] =
        this.roomCreationDate ?? FieldValue.serverTimestamp();
    return data;
  }
}
