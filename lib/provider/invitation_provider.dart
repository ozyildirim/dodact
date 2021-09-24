import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:dodact_v1/repository/invitation_repository.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class InvitationProvider with ChangeNotifier {
  InvitationRepository invitationRepository = locator<InvitationRepository>();
  Logger logger = Logger();

  //Kullanıcının aldığı davetlerin listesi
  List<InvitationModel> usersInvitations = [];

  //Grupların davet ettiklerinin listesi

  List<InvitationModel> sentGroupInvitations = [];

  Future<List<InvitationModel>> getInvitations() async {
    try {
      usersInvitations = await invitationRepository.getInvitations();
      usersInvitations.forEach((element) {
        logger.d(element.toJson());
      });
      return usersInvitations;
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<List<InvitationModel>> getSentGroupInvitations(String groupId) async {
    try {
      sentGroupInvitations =
          await invitationRepository.getSentGroupInvitations(groupId);
      notifyListeners();
      return sentGroupInvitations;
    } catch (e) {
      logger.e("GetGroupsSentInvitations Provider Error: " + e);
      return null;
    }
  }

  // Future<List<InvitationModel>> getGroupMembershipInvitations(
  //     String userId) async {
  //   try {
  //     usersInvitations =
  //         await invitationRepository.getGroupMembershipInvitations(userId);
  //     notifyListeners();
  //     return usersInvitations;
  //   } catch (e) {
  //     logger.e("GetGroupMembershipInvitations Provider Error: " + e);
  //   }
  // }

  Future<void> inviteUserToGroup(
      String userId, String groupId, String type) async {
    try {
      InvitationModel invitation = InvitationModel(
        // invitationDate: DateTime.now(),
        receiverId: userId,
        senderId: groupId,
        type: type,
      );
      await invitationRepository.inviteUserToGroup(groupId, userId, type);
      sentGroupInvitations.add(invitation);
      notifyListeners();
    } catch (e) {
      logger.e("InviteUserToGroup Provider Error: " + e);
    }
  }

  Future<bool> acceptGroupInvitation(String userId, String groupId) async {
    return await invitationRepository.acceptGroupInvitation(userId, groupId);
  }

  Future<void> rollbackGroupMembershipInvitation(
      String userId, String groupId) async {
    try {
      await invitationRepository.rollbackGroupInvitation(userId, groupId);
      sentGroupInvitations.removeWhere((element) {
        return element.receiverId == userId && element.senderId == groupId;
      });
      notifyListeners();
    } catch (e) {
      logger.e("RollbackGroupMembershipInvitation Provider Error: " + e);
    }
  }
}
