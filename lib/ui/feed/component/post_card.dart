import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostCard extends StatefulWidget {
  PostModel post;

  PostCard({this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends BaseState<PostCard> {
  PostModel post;
  Future<UserObject> creatorUser;

  PostProvider postProvider;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postProvider = getProvider<PostProvider>();
    userProvider = getProvider<UserProvider>();

    creatorUser = getCreatorUser();
  }

  Future<UserObject> getCreatorUser() async {
    return await userProvider.getUserByID(post.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                sharingInfo(post),
                postPart(post),
                postInfo(post),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row sharingInfo(PostModel post) {
    var date = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("İbrahim Çırak"),
                Text("${date.difference(post.postDate).inDays} gün önce"),
              ],
            ),
          ],
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.bookmark_border)),
      ],
    );
  }

  Stack postPart(PostModel post) {
    return Stack(
      children: [
        postView(post),
        reactionColumn(post),
      ],
    );
  }

  Column reactionColumn(PostModel post) {
    return Column(
      children: [
        Container(
          height: 150,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            post.isVideo == true
                ? Icon(
                    Icons.play_circle_outline_outlined,
                    color: Colors.white,
                  )
                : Container(),
            SizedBox(width: 20),
            Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Container postView(PostModel post) {
    var thumbnailURL = createThumbnailURL(post.postContentURL);
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        height: 200,
        child: Stack(
          children: [],
        ),
        foregroundDecoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(thumbnailURL),
          ),
        ));
  }

  Row postInfo(PostModel post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.postTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(),
      ],
    );
  }

  String createThumbnailURL(String youtubeVideoID) {
    String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
    String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    return thumbnailURL;
  }

  String convertMonth(int month) {
    switch (month) {
      case 1:
        return "Ocak";
      case 2:
        return "Şubat";
      case 3:
        return "Mart";
      case 4:
        return "Nisan";
      case 5:
        return "Mayıs";
      case 6:
        return "Haziran";
      case 7:
        return "Temmuz";
      case 8:
        return "Ağustos";
      case 9:
        return "Eylül";
      case 10:
        return "Ekim";
      case 11:
        return "Kasım";
      case 12:
        return "Aralık";
    }
  }
}
