// To parse this JSON data, do
//
//     final contributionModel = contributionModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SpinnerResultModel spinnerResultModelFromJson(String str) =>
    SpinnerResultModel.fromJson(json.decode(str));

String spinnerResultModelToJson(SpinnerResultModel data) =>
    json.encode(data.toJson());

class SpinnerResultModel {
  SpinnerResultModel(
      {this.resultId,
      this.userId,
      this.createdAt,
      this.rewardTitle,
      this.reward});

  String resultId;
  String userId;
  DateTime createdAt;
  String rewardTitle;
  String reward;

  factory SpinnerResultModel.fromJson(Map<String, dynamic> json) =>
      SpinnerResultModel(
          resultId: json["resultId"],
          userId: json["userId"],
          rewardTitle: json["rewardTitle"],
          createdAt: (json["createdAt"] as Timestamp).toDate(),
          reward: json["reward"]);

  Map<String, dynamic> toJson() => {
        "resultId": resultId,
        "userId": userId,
        "rewardTitle": rewardTitle,
        "reward": reward,
        "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      };
}
