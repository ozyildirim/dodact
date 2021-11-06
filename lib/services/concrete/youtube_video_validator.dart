library youtube_video_validator;

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:dodact_v1/model/youtube_video_model.dart';
import 'package:http/http.dart' as http;

/// Youtube Video Validator
class YoutubeVideoValidator {
  static const String _uriVideoInfo = 'http://youtube.com/get_video_info';
  static final Map<String, String> _playabilityStatus = {
    'ok': 'OK',
    'login_required': 'LOGIN_REQUIRED',
    'unplayable': 'UNPLAYABLE',
    'error': 'ERROR',
  };
  static YoutubeVideo video = YoutubeVideo();

  /// Validate the specified Youtube video URL.
  static bool validateUrl(String url) {
    if (url == null) {
      throw ArgumentError('url');
    }

    if (url.isEmpty) {
      return false;
    }

    final RegExp pattern = RegExp(
        r'^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$');
    final bool match = pattern.hasMatch(url);

    return match;
  }

  /// Validate the specified Youtube video ID.
  static Future<bool> validateID(String videoID,
      {bool loadData = false}) async {
    if (videoID == null) {
      throw ArgumentError('videoID');
    }

    if (videoID.isEmpty || videoID.length != 11) {
      return false;
    }

    final String url = '$_uriVideoInfo?video_id=$videoID';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return false;
    }

    final List<String> options = (response.body).split('&');
    options.retainWhere((value) => value.contains('player_response='));

    if (options[0].startsWith('player_response=')) {
      final Map<String, dynamic> videoJson = jsonDecode(
          Uri.decodeFull(options[0].substring('player_response='.length)));

      final bool isRealVideo = (videoJson['playabilityStatus']['status'] ==
                  _playabilityStatus['ok'] ||
              videoJson['playabilityStatus']['status'] ==
                  _playabilityStatus['login_required'])
          ? true
          : false;

      if (loadData && isRealVideo) {
        video.fromJson(videoJson['videoDetails']);
      }

      return isRealVideo;
    } else {
      return false;
    }
  }
}
