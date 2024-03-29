import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/constants/app_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomMethods {
  var logger = new Logger();
  static String createThumbnailURL(bool isLocatedInYoutube, String videoURL,
      {bool isAudio}) {
    try {
      String thumbnailURL;

      if (isAudio != null && isAudio == true) {
        return AppConstant.kAudioCardImage;
      }

      if (isLocatedInYoutube) {
        String videoID = YoutubePlayer.convertUrlToId(videoURL);
        thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
      } else {
        thumbnailURL = videoURL;
      }
      return thumbnailURL;
    } catch (e) {
      Logger().e("CreateThumbnailURL error: $e");
    }
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
      {String title, Function okButtonTap}) async {
    await CoolAlert.show(
        context: context,
        barrierDismissible: false,
        type: CoolAlertType.success,
        text: message,
        onConfirmBtnTap: okButtonTap,
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

  static showImagePreviewDialog(BuildContext context,
      {ImageProvider imageProvider, String url}) {
    var size = MediaQuery.of(context).size;
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              // width: size.width * 0.8,
              // height: size.height * 0.5,
              child: PhotoView(
                imageProvider: imageProvider ?? NetworkImage(url),
                tightMode: true,
              ),
            ),
          );
        });
  }

  void hideDialog() {
    NavigationService.instance.pop();
  }

  static void launchURL(BuildContext context, String requestedUrl) async {
    if (requestedUrl != null) {
      if (await canLaunch(requestedUrl)) {
        await launch(requestedUrl);
      } else {
        showSnackbar(context, "Geçersiz bağlantı.");
      }
    } else {
      print("URL mevcut değil");
    }
  }

  static void launchEmail(String email, String subject, String message) async {
    launch("mailto:$email?subject=$subject&body=$message%20plugin");
  }

  static showCustomDialog({
    @required BuildContext context,
    @required String title,
    @required String confirmButtonText,
    @required Function confirmActions,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.all(4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Vazgeç"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(confirmButtonText,
                      style: TextStyle(color: Colors.white)),
                  color: kNavbarColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  onPressed: confirmActions),
            ],
          );
        });
  }

  static showSnackbar(BuildContext context, String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }
}
