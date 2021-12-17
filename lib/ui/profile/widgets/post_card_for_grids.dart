import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
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
    var thumbnailURL = CustomMethods.createThumbnailURL(
        post.isLocatedInYoutube, post.postContentURL,
        isAudio: post.postContentType == "Ses" ? true : false);

    return CachedNetworkImage(
      imageUrl: thumbnailURL,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => NavigationService.instance
              .navigate(k_ROUTE_POST_DETAIL, args: post),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: spinkit),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
