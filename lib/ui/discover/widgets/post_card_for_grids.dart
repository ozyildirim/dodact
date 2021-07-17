import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostCardForGrid extends StatelessWidget {
  PostModel post;

  PostCardForGrid({this.post});

  @override
  Widget build(BuildContext context) {
    return postView(post);
  }

  Widget postView(PostModel post) {
    var thumbnailURL = CommonMethods.createThumbnailURL(
        post.isLocatedInYoutube, post.postContentURL);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          NavigationService.instance
              .navigate(k_ROUTE_POST_DETAIL, args: post.postId);
        },
        child: Container(
            padding: EdgeInsets.only(bottom: 10),
            foregroundDecoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(thumbnailURL),
              ),
            )),
      ),
    );
  }
}
