// To parse this JSON data, do
//
//     final dodcoinModel = dodcoinModelFromJson(jsonString);

import 'dart:convert';

DodcoinModel dodcoinModelFromJson(String str) =>
    DodcoinModel.fromJson(json.decode(str));

String dodcoinModelToJson(DodcoinModel data) => json.encode(data.toJson());

class DodcoinModel {
  DodcoinModel({
    this.ownerId,
    this.totalDodcoin,
  });

  String ownerId;
  int totalDodcoin;

  factory DodcoinModel.fromJson(Map<String, dynamic> json) => DodcoinModel(
        ownerId: json["ownerId"],
        totalDodcoin: json["totalDodcoin"],
      );

  Map<String, dynamic> toJson() => {
        "ownerId": ownerId,
        "totalDodcoin": totalDodcoin,
      };
}
