import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String messageId;
  String senderId;
  String message;
  DateTime messageCreationDate;
  bool isRead;

  MessageModel(
      {this.messageId,
      this.senderId,
      this.message,
      this.messageCreationDate,
      this.isRead});

  MessageModel.fromJson(Map<String, dynamic> json)
      : messageId = json['messageId'],
        senderId = json['senderId'],
        message = json['message'],
        messageCreationDate =
            (json['messageCreationDate'] as Timestamp).toDate(),
        isRead = json['isRead'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageId'] = this.messageId;
    data['senderId'] = this.senderId;
    data['message'] = this.message;
    data['messageCreationDate'] =
        this.messageCreationDate ?? FieldValue.serverTimestamp();
    data['isRead'] = this.isRead;
    return data;
  }
}
