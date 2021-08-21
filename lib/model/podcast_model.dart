// To parse this JSON data, do
//
//     final podcastModel = podcastModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PodcastModel podcastModelFromJson(String str) =>
    PodcastModel.fromJson(json.decode(str));

String podcastModelToJson(PodcastModel data) => json.encode(data.toJson());

class PodcastModel {
  PodcastModel(
      {this.podcastId,
      this.podcastTitle,
      this.podcastOwner,
      this.podcastDescription,
      this.podcastLink,
      this.podcastReleaseDate,
      this.podcastOwnerPhotoUrl,
      this.podcastImageUrl});

  String podcastId;
  String podcastTitle;
  String podcastOwner;
  String podcastDescription;
  String podcastLink;
  DateTime podcastReleaseDate;
  String podcastOwnerPhotoUrl;
  String podcastImageUrl;

  factory PodcastModel.fromJson(Map<String, dynamic> json) => PodcastModel(
      podcastId: json["podcastId"],
      podcastTitle: json["podcastTitle"],
      podcastOwner: json["podcastOwner"],
      podcastDescription: json["podcastDescription"],
      podcastLink: json["podcastLink"],
      podcastReleaseDate: (json["podcastReleaseDate"] as Timestamp).toDate(),
      podcastOwnerPhotoUrl: json["podcastOwnerPhotoUrl"],
      podcastImageUrl: json["podcastImageUrl"]);

  Map<String, dynamic> toJson() => {
        "podcastId": podcastId,
        "podcastTitle": podcastTitle,
        "podcastOwner": podcastOwner,
        "podcastDescription": podcastDescription,
        "podcastLink": podcastLink,
        "podcastReleaseDate": podcastReleaseDate,
        "podcastOwnerPhotoUrl": podcastOwnerPhotoUrl,
        "podcastImageUrl": podcastImageUrl,
      };
}
