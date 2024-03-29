import 'package:flutter/widgets.dart';

class AppConstant {
  static const kAppUniqueCode = "dodact2021surum";

  static const kAudioCardImage =
      "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/app%2Faudio-cover-photo.jpeg?alt=media&token=a28b9082-113e-46ab-ba15-b7d3a5353879";

  static const kDefaultUserProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/app%2Fdefault-user-pp.png?alt=media&token=f58f8c9c-f495-4361-972b-9949fe559a67";

  static const TR_LOCALE = Locale("tr", "TR");
  static const EN_LOCALE = Locale("en", "US");
  static const ES_LOCALE = Locale("es", "ES");
  static const DE_LOCALE = Locale("de", "DE");
  static const LANG_PATH = "assets/lang";

  static const SUPPORTED_LOCALE = [
    AppConstant.EN_LOCALE,
    AppConstant.TR_LOCALE,
    AppConstant.DE_LOCALE,
    AppConstant.ES_LOCALE,
  ];
}
