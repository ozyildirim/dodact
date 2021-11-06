import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/chatroom_model.dart';
import 'package:dodact_v1/model/message_model.dart';
import 'package:dodact_v1/services/concrete/firebase_chatroom_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class ChatroomProvider extends ChangeNotifier {
  var logger = new Logger();
  FirebaseChatroomService chatroomService = locator<FirebaseChatroomService>();

  List<ChatroomModel> userChatrooms = [];
  ChatroomModel selectedChatroom;

  List<MessageModel> chatroomMessages = [];

  Future<String> createChatRoom(String firstUserId, String secondUserId) async {
    try {
      String chatroomId =
          await chatroomService.createChatRoom(firstUserId, secondUserId);
      logger.i("Chat odası oluşturuldu");
      print(chatroomId);
      return chatroomId;
    } catch (e) {
      logger.e("CreateChatRoom error: $e");
      return null;
    }
  }

  Future<bool> checkChatroom(String firstUserId, String secondUserId) async {
    try {
      bool result =
          await chatroomService.checkChatroom(firstUserId, secondUserId);
      return result;
    } catch (e) {
      logger.e("CheckChatroom error: $e");
      return null;
    }
  }

  Future<List<ChatroomModel>> getUserChatrooms(String userId) async {
    try {
      userChatrooms = await chatroomService.getUserChatrooms(userId);
      notifyListeners();
      return userChatrooms;
    } catch (e) {
      logger.e("GetUserChatrooms error: $e");
      return null;
    }
  }

  Future<List<MessageModel>> getChatroomMessages(String chatroomId) async {
    try {
      return await chatroomService.getChatroomMessages(chatroomId);
    } catch (e) {
      logger.e("GetChatroomMessages error: $e");
      return null;
    }
  }

  Future<void> sendMessage(
      String chatroomId, String userId, String message) async {
    try {
      await chatroomService.sendMessage(chatroomId, userId, message);
      logger.i("Mesaj gönderildi");
    } catch (e) {
      logger.e("SendMessage error: $e");
    }
  }

  Future<void> deleteChatroom(String chatroomId) async {
    try {
      await chatroomService.deleteChatroom(chatroomId);
      notifyListeners();
      logger.i("Chat odası silindi");
    } catch (e) {
      logger.e("DeleteChatroom error: $e");
    }
  }

  Future<void> deleteMessage(String chatroomId, String messageId) async {
    try {
      await chatroomService.deleteMessage(chatroomId, messageId);
      logger.i("Mesaj silindi");
    } catch (e) {
      logger.e("DeleteMessage error: $e");
    }
  }
}
