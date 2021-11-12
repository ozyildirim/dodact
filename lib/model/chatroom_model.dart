import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomModel {
  String roomId;
  List<String> users;
  Map<String, dynamic> lastMessage;
  DateTime roomCreationDate;
  String type;

  ChatroomModel(
      {this.roomId,
      this.users,
      this.lastMessage,
      this.type,
      this.roomCreationDate});

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        users = json['users']?.cast<String>(),
        lastMessage = json['lastMessage'],
        type = json['type'],
        roomCreationDate = (json['roomCreationDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['users'] = this.users;
    data['lastMessage'] = this.lastMessage;
    data['roomCreationDate'] =
        this.roomCreationDate ?? FieldValue.serverTimestamp();
    data['type'] = this.type;
    return data;
  }
}
