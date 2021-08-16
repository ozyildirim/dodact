import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/constants/app_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CommonMethods {
  static String createThumbnailURL(bool isLocatedInYoutube, String videoURL,
      {bool isAudio}) {
    String thumbnailURL;

    if (isAudio != null && isAudio == true) {
      return kAudioCardImage;
    }

    if (isLocatedInYoutube) {
      String videoID = YoutubePlayer.convertUrlToId(videoURL);
      thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    } else {
      thumbnailURL = videoURL;
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

  Future<void> showSuccessDialog(BuildContext context, String message,
      {String title}) async {
    await CoolAlert.show(
        context: context,
        barrierDismissible: false,
        type: CoolAlertType.success,
        text: message,
        confirmBtnText: "Tamam",
        title: title ?? "İşlem Başarılı");
  }

  Future<void> showErrorDialog(BuildContext context, String message,
      {String title = "Hata"}) async {
    await CoolAlert.show(
      confirmBtnText: "Tamam",
      title: title,
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

  void hideDialog() {
    NavigationService.instance.pop();
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
