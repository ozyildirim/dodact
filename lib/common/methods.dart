import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CommonMethods {
  static String createThumbnailURL(String youtubeVideoID) {
    String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
    String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    return thumbnailURL;
  }
}
