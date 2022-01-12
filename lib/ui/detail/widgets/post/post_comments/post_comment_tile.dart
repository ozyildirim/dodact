import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCommentTile extends StatefulWidget {
  CommentModel comment;
  String postOwnerId;
  String postId;

  PostCommentTile({this.comment, this.postOwnerId, this.postId});

  @override
  _PostCommentTileState createState() => _PostCommentTileState();
}

class _PostCommentTileState extends BaseState<PostCommentTile> {
  CommentModel comment;
  UserProvider userProvider;
  UserObject authorUser;

  initState() {
    super.initState();
    comment = widget.comment;
    Provider.of<UserProvider>(context, listen: false)
        .getUserByID(comment.authorId)
        .then((value) {
      setState(() {
        authorUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<CommentProvider>(context);
    return Container(
        child: authorUser != null
            ? ListTile(
                onLongPress: () {
                  print(comment.commentId);
                },
                leading: InkWell(
                  onTap: () => navigateAuthorProfile(),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(authorUser.profilePictureURL),
                    maxRadius: 30,
                  ),
                ),
                title: Text(
                  comment.comment,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  "@" + authorUser.username,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                trailing: Column(
                  children: [
                    Text(
                      DateFormat("dd.MM.yyyy HH:mm", "tr_TR")
                          .format(comment.commentDate),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            : null);
  }

  navigateAuthorProfile() {
    Get.toNamed(k_ROUTE_OTHERS_PROFILE_PAGE, arguments: authorUser);
  }
}
