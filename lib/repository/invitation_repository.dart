import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:dodact_v1/services/concrete/firebase_invitations_service.dart';

enum AppMode { DEBUG, RELEASE }

class InvitationRepository {
  FirebaseInvitationService firebaseInvitationService =
      locator<FirebaseInvitationService>();

  AppMode appMode = AppMode.RELEASE;

  Future<List<InvitationModel>> getSentGroupInvitations(String groupId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await firebaseInvitationService.getSentInvitations(groupId);
    }
  }

  Future<List<InvitationModel>> getUsersInvitations(String userId,
      {String type}) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await firebaseInvitationService.getReceivedInvitations(userId,
          type: type);
    }
  }

  Future<void> inviteUserToGroup(
      String senderId, String receiverId, String type) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await firebaseInvitationService.inviteUserToGroup(
          senderId, receiverId, type);
    }
  }

  Future<void> acceptGroupInvitation(
      String userId, String groupId, String invitationId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await firebaseInvitationService.acceptGroupInvitation(
          userId, groupId, invitationId);
    }
  }

  Future<List<InvitationModel>> getInvitations() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await firebaseInvitationService.getInvitations();
    }
  }

  Future<void> rollbackGroupInvitation(String userId, String groupId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      await firebaseInvitationService.rollbackGroupInvitation(userId, groupId);
    }
  }
}
