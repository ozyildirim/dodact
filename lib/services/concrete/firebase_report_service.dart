import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';

class FirebaseReportService {
  static Future<void> reportUser(
      String reporterId, String reportedUserId, String reportReason) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "User",
      'reporterId': reporterId,
      'reportedObjectId': reportedUserId,
      'reportedTime': new DateTime.now(),
      'reason': reportReason
    });

    // throw Exception("Not implemented");
  }

  static Future<bool> checkUserHasSameReporter(
      {String reportedUserId, String reporterId}) async {
    //raporları kontrol eder, bildiren kişi daha önce bildirdiyse, rapor eklenmez.
    QuerySnapshot querySnapshot = await reportsRef
        .where('reportedObjectId', isEqualTo: reportedUserId)
        .where('reporterId', isEqualTo: reporterId)
        .get();

    if (querySnapshot.docs != null && querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> reportGroup(
      String reporterId, String reportedGroupId, String reportReason) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Group",
      'reporterId': reporterId,
      'reportedObjectId': reportedGroupId,
      'reportedTime': new DateTime.now(),
      'reason': reportReason
    });
  }

  static Future<bool> checkGroupHasSameReporter(
      {String reportedGroupId, String reporterId}) async {
    //raporları kontrol eder, bildiren kişi daha önce bildirdiyse, rapor eklenmez.
    QuerySnapshot querySnapshot = await reportsRef
        .where('reportedObjectId', isEqualTo: reportedGroupId)
        .where('reporterId', isEqualTo: reporterId)
        .get();

    if (querySnapshot.docs != null && querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<void> reportEvent(
      String reporterId, String reportedEventId, String reportReason) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Event",
      'reporterId': reporterId,
      'reportedObjectId': reportedEventId,
      'reportedTime': new DateTime.now(),
      'reason': reportReason
    });
  }

  static Future<bool> checkEventHasSameReporter(
      {String reportedEventId, String reporterId}) async {
    //raporları kontrol eder, bildiren kişi daha önce bildirdiyse, rapor eklenmez.
    QuerySnapshot querySnapshot = await reportsRef
        .where('reportedObjectId', isEqualTo: reportedEventId)
        .where('reporterId', isEqualTo: reporterId)
        .get();

    if (querySnapshot.docs != null && querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> reportPost(
      String reporterId, String reportedPostId, String reportReason) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Post",
      'reporterId': reporterId,
      'reportedObjectId': reportedPostId,
      'reportedTime': new DateTime.now(),
      'reason': reportReason
    });
  }

  static Future<bool> checkPostHasSameReporter(
      {String reportedPostId, String reporterId}) async {
    //raporları kontrol eder, bildiren kişi daha önce bildirdiyse, rapor eklenmez.
    QuerySnapshot querySnapshot = await reportsRef
        .where('reportedObjectId', isEqualTo: reportedPostId)
        .where('reporterId', isEqualTo: reporterId)
        .get();

    if (querySnapshot.docs != null && querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<void> reportComment(String reporterId, String reportedCommentId,
      String parentObjectId) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Comment",
      'reporterId': reporterId,
      'reportedObjectId': reportedCommentId,
      'parentObjectId': parentObjectId,
      'reportedTime': new DateTime.now()
    });
  }

  static Future<bool> checkCommentHasSameReporter(
      {String reportedCommentId, String reporterId}) async {
    //raporları kontrol eder, bildiren kişi daha önce bildirdiyse, rapor eklenmez.
    QuerySnapshot querySnapshot = await reportsRef
        .where('reportedObjectId', isEqualTo: reportedCommentId)
        .where('reporterId', isEqualTo: reporterId)
        .get();

    if (querySnapshot.docs != null && querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> reporMessage(String reporterId, String roomId, String messageId,
      String message) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Message",
      'reporterId': roomId,
      'reportedObjectId': messageId,
      'reportedObjectContent': message,
      'parentObjectId': roomId,
      'reportedTime': new DateTime.now()
    });
  }

  static Future<bool> checkPrivateMessageHasSameReporter(
      {String reportedPrivateMessageId, String reporterId}) async {
    //raporları kontrol eder, bildiren kişi daha önce bildirdiyse, rapor eklenmez.
    QuerySnapshot querySnapshot = await reportsRef
        .where('reportedObjectId', isEqualTo: reportedPrivateMessageId)
        .where('reporterId', isEqualTo: reporterId)
        .get();

    if (querySnapshot.docs != null && querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }
}
