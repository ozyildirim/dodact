import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CommonMethods {
  static String createThumbnailURL(bool isLocatedInYoutube, String videoURL) {
    String thumbnailURL;
    if (isLocatedInYoutube) {
      String videoID = YoutubePlayer.convertUrlToId(videoURL);
      thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    } else {
      thumbnailURL = videoURL;
      //TODO: Videolar için thumbnail fonksiyonu yazılmalı
    }

    return thumbnailURL;
  }

//TODO: Uygulamadaki diğer progress indicatorları da buradan kullan.
  void showLoaderDialog(BuildContext context, String message) {
    CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: CoolAlertType.loading,
      text: message,
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    CoolAlert.show(
      barrierDismissible: true,
      context: context,
      type: CoolAlertType.error,
      text: message,
    );
  }

  void showInfoDialog(BuildContext context, String message, String title) {
    CoolAlert.show(
      barrierDismissible: true,
      context: context,
      type: CoolAlertType.info,
      text: message,
      title: title,
    );
  }

  static void launchURL(String requestedUrl) async {
    if (requestedUrl != null) {
      if (await canLaunch(requestedUrl)) {
        await launch(requestedUrl);
      } else {
        throw new Exception("Cannot open URL: " + requestedUrl);
      }
    } else {
      print("URL mevcut değil");
    }
  }

  static void launchEmail(String email, String subject, String message) async {
    launch("mailto:$email?subject=$subject&body=$message%20plugin");
  }
}
