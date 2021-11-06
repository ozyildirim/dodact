// To parse this JSON data, do
//
//     final notification = notificationFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

DodderModel dodderFromMap(String str) => DodderModel.fromMap(json.decode(str));

String dodderToMap(DodderModel data) => json.encode(data.toMap());

class DodderModel {
  DodderModel({
    this.dodderId,
    this.date,
  });

  String dodderId;
  DateTime date;

  factory DodderModel.fromMap(Map<String, dynamic> json) => DodderModel(
        dodderId: json["dodderId"],
        date: (json['date'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        "dodderId": dodderId,
        "date": date ?? FieldValue.serverTimestamp(),
      };
}
