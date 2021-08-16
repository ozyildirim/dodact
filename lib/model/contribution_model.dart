// To parse this JSON data, do
//
//     final contributionModel = contributionModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ContributionModel contributionModelFromJson(String str) =>
    ContributionModel.fromJson(json.decode(str));

String contributionModelToJson(ContributionModel data) =>
    json.encode(data.toJson());

class ContributionModel {
  ContributionModel({
    this.contributionId,
    this.contributorId,
    this.contributorAccountType,
    this.objectType,
    this.objectId,
    this.creationDate,
    this.contributedCompany,
  });

  String contributionId;
  String contributorId;
  String contributorAccountType;
  String objectType;
  String objectId;
  DateTime creationDate;
  String contributedCompany;

  factory ContributionModel.fromJson(Map<String, dynamic> json) =>
      ContributionModel(
        contributionId: json["contributionId"],
        contributorId: json["contributorId"],
        contributorAccountType: json["contributorAccountType"],
        objectType: json["objectType"],
        objectId: json["objectId"],
        creationDate: (json["creationDate"] as Timestamp).toDate(),
        contributedCompany: json["contributedCompany"],
      );

  Map<String, dynamic> toJson() => {
        "contributionId": contributionId,
        "contributorId": contributorId,
        "contributorAccountType": contributorAccountType,
        "objectType": objectType,
        "objectId": objectId,
        "creationDate": creationDate ?? FieldValue.serverTimestamp(),
        "contributedCompany": contributedCompany,
      };
}
