import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/chatroom_model.dart';
import 'package:dodact_v1/model/message_model.dart';

class FirebaseChatroomService {
  Future<String> createChatRoom(String firstUserId, String secondUserId) async {
    String roomId;
    int result = firstUserId.compareTo(secondUserId);

    if (result < 0) {
      roomId = firstUserId + "_" + secondUserId;
    } else {
      roomId = secondUserId + "_" + firstUserId;
    }

    var room = await chatroomsRef.doc(roomId).get();

    if (!room.exists) {
      var chatroom = ChatroomModel(
        roomId: roomId,
        users: [firstUserId, secondUserId],
        roomCreationDate: DateTime.now(),
      );

      await chatroomsRef.doc(roomId).set(chatroom.toJson());
      return roomId;
    } else {
      print("Chatroom already exists. Navigate to chatroom");
      return roomId;
    }
  }

  Future<List<ChatroomModel>> getUserChatrooms(String userId) async {
    var querySnapshot =
        await chatroomsRef.where("users", arrayContains: userId).get();

    List<ChatroomModel> chatrooms = [];

    querySnapshot.docs.forEach((doc) {
      chatrooms.add(ChatroomModel.fromJson(doc.data()));
    });

    return chatrooms;
  }

  Future<List<MessageModel>> getChatroomMessages(String chatroomId) async {
    var querySnapshot = await chatroomsRef
        .doc(chatroomId)
        .collection("messages")
        .orderBy('messageCreationDate', descending: false)
        .get();

    List<MessageModel> messages = [];
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        messages.add(MessageModel.fromJson(doc.data()));
      });
      return messages;
    } else {
      return messages;
    }
  }

  Future<MessageModel> getLastMessage(String chatroomId) async {
    var querySnapshot = await chatroomsRef
        .doc(chatroomId)
        .collection("messages")
        .orderBy('messageCreationDate', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return MessageModel.fromJson(querySnapshot.docs.first.data());
    } else {
      return null;
    }
  }

  Future<DocumentReference> sendMessage(
      String chatroomId, String userId, String message) async {
    MessageModel messageModel = MessageModel(
        message: message,
        senderId: userId,
        messageCreationDate: DateTime.now(),
        isRead: false);

    return await chatroomsRef
        .doc(chatroomId)
        .collection("messages")
        .add(messageModel.toJson())
        .then((value) async {
      await chatroomsRef
          .doc(chatroomId)
          .collection("messages")
          .doc(value.id)
          .update({
        "messageId": value.id,
      });
      return value;
    });
  }

  Future deleteChatroom(String chatroomId) async {
    await chatroomsRef.doc(chatroomId).delete();
  }

  Future deleteMessage(String chatroomId, String messageId) async {
    await chatroomsRef
        .doc(chatroomId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  Future<bool> checkChatroom(String firstUserId, String secondUserId) async {
    String roomId;
    int result = firstUserId.compareTo(secondUserId);

    if (result < 0) {
      roomId = firstUserId + "_" + secondUserId;
    } else {
      roomId = secondUserId + "_" + firstUserId;
    }

    print(roomId);

    return await chatroomsRef.doc(roomId).get().then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
  }
}
