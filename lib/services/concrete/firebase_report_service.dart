import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';

class FirebaseReportService {
  Future<void> reportUser(String reporterId, String reportedUserId) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "User",
      'reporterId': reporterId,
      'reportedObjectId': reportedUserId,
      'reportedTime': new DateTime.now()
    });
  }

  Future<void> reportGroup(String reporterId, String reportedGroupId) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Group",
      'reporterId': reporterId,
      'reportedObjectId': reportedGroupId,
      'reportedTime': new DateTime.now()
    });
  }

  Future<void> reportPost(String reporterId, String reportedPostId) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Post",
      'reporterId': reporterId,
      'reportedObjectId': reportedPostId,
      'reportedTime': new DateTime.now()
    });
  }

  Future<void> reportComment(
      String reporterId, String reportedCommentId) async {
    DocumentReference reference = await reportsRef.add({
      'reportedObjectType': "Comment",
      'reporterId': reporterId,
      'reportedObjectId': reportedCommentId,
      'reportedTime': new DateTime.now()
    });
  }
}
