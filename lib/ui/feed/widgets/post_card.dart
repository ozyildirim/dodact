import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostCard extends StatefulWidget {
  PostModel post;

  PostCard({this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends BaseState<PostCard> {
  PostModel post;
  UserObject creatorUser;

  PostProvider postProvider;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postProvider = getProvider<PostProvider>();
    userProvider = getProvider<UserProvider>();

    userProvider.getOtherUser(post.ownerId, isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
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

  Consumer<UserProvider> sharingInfo(PostModel post) {
    var date = DateTime.now();
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading == false) {
          if (provider.otherUser != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigationService.instance
                            .navigate('/others_profile', args: post.ownerId);
                      },
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              provider.otherUser.profilePictureURL)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.otherUser.nameSurname,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "${date.difference(post.postDate).inDays} gün önce"),
                      ],
                    ),
                  ],
                ),

                //TODO: Şikayet etme özelliğini de buraya eklemeliyiz.
                Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {},
                    )),
              ],
            );
          } else {
            return Center(
              child: Text("Kullanıcı bulunamadı"),
            );
          }
        } else {
          return Center(
            child: spinkit,
          );
        }
      },
    );
  }

  Stack postPart(PostModel post) {
    return Stack(
      children: [
        postView(post),
        // reactionRow(post),
      ],
    );
  }

  Container reactionRow(PostModel post) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 190,
          ),
          Container(
            width: 130,
            decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesome.handshake_o,
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
          ),
        ],
      ),
    );
  }

  Container postView(PostModel post) {
    var thumbnailURL = createThumbnailURL(post.postContentURL);
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        height: 200,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesome.heart_o),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesome.comment_o),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              post.postTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              post.postDescription,
              overflow: TextOverflow.fade,
            )
          ],
        ),
      ],
    );
  }

  String createThumbnailURL(String youtubeVideoID) {
    String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
    String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    return thumbnailURL;
  }
}
