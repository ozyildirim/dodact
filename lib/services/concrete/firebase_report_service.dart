import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';

class FirebaseReportService {
  Future<void> reportUser(
      String reporterId, String reportedUserId, String reportReason) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "User",
      'reporterId': reporterId,
      'reportedObjectId': reportedUserId,
      'reportedTime': new DateTime.now(),
      'reason': reportReason
    });
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

  Future<void> reportEvent(
      String reporterId, String reportedEventId, String reportReason) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Event",
      'reporterId': reporterId,
      'reportedObjectId': reportedEventId,
      'reportedTime': new DateTime.now(),
      'reason': reportReason
    });
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
}
