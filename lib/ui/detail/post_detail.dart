import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostDetail extends StatefulWidget {
  final String postId;

  PostDetail({
    this.postId,
  });

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  String videoId;
  PostModel post;
  Future _postFuture;
  UserObject _creator;

  Future _obtainPostFuture(BuildContext context) {
    return Provider.of<PostProvider>(context, listen: false)
        .getDetail(widget.postId);
  }

  Future<void> _refreshPost(BuildContext context) async {
    await Provider.of<PostProvider>(context, listen: false)
        .getDetail(widget.postId);
  }

  Future<void> _getCreatorData(BuildContext context, String creatorId) async {
    await Provider.of<UserProvider>(context)
        .getUserByID(creatorId)
        .then((userInfo) {
      _creator = userInfo;
    });
  }

  @override
  void initState() {
    _postFuture = _obtainPostFuture(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Post Detay",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshPost(context),
        child: FutureBuilder(
          future: _postFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: spinkit);
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text("Hata oluştu."),
                );
              } else {
                post = snapshot.data;
                _getCreatorData(context, post.ownerId);
                return Container(
                  child: Column(
                    children: [
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: YoutubePlayer.convertUrlToId(
                              post.postContentURL), //Add videoID.
                          flags: YoutubePlayerFlags(
                            hideControls: false,
                            controlsVisibleAtStart: true,
                            autoPlay: false,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                      ),
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage: _creator != null
                                ? NetworkImage(_creator.profilePictureURL)
                                : null,
                          ),
                          title: Text(post.postTitle),
                          subtitle: _creator != null
                              ? Text(_creator.nameSurname)
                              : null,
                          trailing: post.supportersId.length != null
                              ? Text("${post.supportersId.length} Dod")
                              : null)
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
