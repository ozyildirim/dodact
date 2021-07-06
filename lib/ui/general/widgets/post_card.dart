import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  PostCard(this.post);
  String coverPhotoURL;

  String createThumbnailURL(String youtubeVideoID) {
    String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
    String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    return thumbnailURL;
  }

  @override
  Widget build(BuildContext context) {
    if (post.isVideo == true) {
      coverPhotoURL = createThumbnailURL(post.postContentURL);
    } else {
      coverPhotoURL = post.postContentURL;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            NavigationService.instance
                .navigate(k_ROUTE_POST_DETAIL, args: post.postId);
          },
          child: Container(
            height: 240,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(coverPhotoURL),
                          fit: BoxFit.cover)),
                )),
                Text(
                  post.postTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  post.postDescription,
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
