import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_headers/audio_player/audio_player_widget.dart';
import 'package:flutter/material.dart';

class AudioPostHeader extends StatelessWidget {
  PostModel post;
  AudioPostHeader({this.post});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: double.infinity,
      child: AudioPlayerWidget(
        contentURL: post.postContentURL,
      ),
    );
  }
}
