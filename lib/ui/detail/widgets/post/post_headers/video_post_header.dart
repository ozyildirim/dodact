import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPostHeader extends StatelessWidget {
  PostModel post;

  VideoPostHeader({this.post});

  //TODO: Burası düzenlenmeli
  buildYoutubeController() {
    return YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(post.postContentURL), //Add videoID.
      flags: YoutubePlayerFlags(
        forceHD: true,
        hideControls: false,
        controlsVisibleAtStart: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        child: YoutubePlayer(
      controller: buildYoutubeController(),
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
    ));
  }
}
