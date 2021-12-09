import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  String applicationId;
  String applicationType;
  DateTime applicationDate;
  String applicantId;
  Map<String, dynamic> answers;
  String status;
  String rejectionReason;

  ApplicationModel(
      {this.applicationId,
      this.applicationType,
      this.applicationDate,
      this.applicantId,
      this.answers,
      this.status,
      this.rejectionReason});

  ApplicationModel.fromJson(Map<String, dynamic> json)
      : applicationId = json['applicationId'],
        applicationDate = (json['applicationDate'] as Timestamp).toDate(),
        applicationType = json['applicationType'],
        applicantId = json['applicantId'],
        status = json['status'],
        answers = json['answers'],
        rejectionReason = json['rejectionReason'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicationId'] = this.applicationId;
    data['applicationDate'] =
        this.applicationDate ?? FieldValue.serverTimestamp();
    data['applicantId'] = this.applicantId;
    data['answers'] = this.answers;
    data['applicationType'] = this.applicationType;
    data['status'] = this.status;
    data['rejectionReason'] = this.rejectionReason;
    return data;
  }
}
