import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:flutter/material.dart';

class FirebaseInvitationService {
  Future<List<InvitationModel>> getSentInvitations(String senderId) async {
    List<InvitationModel> invitations = [];
    QuerySnapshot snapshot = await invitationsRef
        .where('senderId', isEqualTo: senderId)
        // .where('type', isEqualTo: type)
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      debugPrint(doc.toString());
      InvitationModel element = InvitationModel.fromJson(doc.data());

      invitations.add(element);
    }

    return invitations;
  }

  Future<List<InvitationModel>> getReceivedInvitations(String receiverId,
      {String type}) async {
    List<InvitationModel> invitations = [];
    QuerySnapshot snapshot;
    if (type == null) {
      snapshot =
          await invitationsRef.where('receiverId', isEqualTo: receiverId).get();
    } else {
      snapshot = await invitationsRef
          .where('receiverId', isEqualTo: receiverId)
          .where('type', isEqualTo: type)
          .get();
    }

    for (DocumentSnapshot doc in snapshot.docs) {
      invitations.add(InvitationModel.fromJson(doc.data()));
    }
    return invitations;
  }

  //Invitations tablosunda davet modeli oluşturur.
  Future<void> inviteUserToGroup(
      String senderId, String receiverId, String type) async {
    InvitationModel invitation = InvitationModel(
      senderId: senderId,
      receiverId: receiverId,
      type: type,
      // invitationDate: DateTime.now(),
    );

    await invitationsRef.add(invitation.toJson()).then((value) async {
      await invitationsRef.doc(value.id).update({'invitationId': value.id});
    });
  }

  //Cloud Functions ile kabul işlemi gerçekleştirilir.
  Future<void> acceptGroupInvitation(
      String userId, String groupId, String invitationId) async {
    // //TODO: Cloud Functions ile kabul işlemi gerçekleştirilir.
    // await invitationsRef.doc(invitationId).delete();

    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    HttpsCallable callable = firebaseFunctions.httpsCallable('addUserToGroup');
    try {
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'groupId': groupId,
        'userId': userId,
        'invitationId': invitationId,
      });
      print(result.data);
    } on FirebaseFunctionsException catch (e) {
      print('Firebase Functions Exception');
      print(e.code);
      print(e.message);
    } catch (e) {
      print('Caught Exception');
      print(e);
    }
  }

  Future<List<InvitationModel>> getInvitations() async {
    List<InvitationModel> invitations = [];
    QuerySnapshot snapshot = await invitationsRef.get();

    for (DocumentSnapshot doc in snapshot.docs) {
      invitations.add(InvitationModel.fromJson(doc.data()));
    }
    return invitations;
  }

  Future<void> rollbackGroupInvitation(String userId, String groupId) async {
    QuerySnapshot snapshot = await invitationsRef
        .where('senderId', isEqualTo: groupId)
        .where('receiverId', isEqualTo: userId)
        .get();
    // ignore: missing_return

    for (DocumentSnapshot doc in snapshot.docs) {
      invitationsRef.doc(doc.id).delete();
    }
  }
}
