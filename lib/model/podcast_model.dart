// To parse this JSON data, do
//
//     final podcastModel = podcastModelFromJson(jsonString);

import 'dart:convert';

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
      this.podcastOwnerPhotoUrl,
      this.podcastImageUrl});

  String podcastId;
  String podcastTitle;
  String podcastOwner;
  String podcastDescription;
  String podcastLink;
  String podcastOwnerPhotoUrl;
  String podcastImageUrl;

  factory PodcastModel.fromJson(Map<String, dynamic> json) => PodcastModel(
      podcastId: json["podcastId"],
      podcastTitle: json["podcastTitle"],
      podcastOwner: json["podcastOwner"],
      podcastDescription: json["podcastDescription"],
      podcastLink: json["podcastLink"],
      podcastOwnerPhotoUrl: json["podcastOwnerPhotoUrl"],
      podcastImageUrl: json["podcastImageUrl"]);

  Map<String, dynamic> toJson() => {
        "podcastId": podcastId,
        "podcastTitle": podcastTitle,
        "podcastOwner": podcastOwner,
        "podcastDescription": podcastDescription,
        "podcastLink": podcastLink,
        "podcastOwnerPhotoUrl": podcastOwnerPhotoUrl,
        "podcastImageUrl": podcastImageUrl,
      };
}
