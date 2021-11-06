import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/app_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  PostModel post;

  PostCard(this.post);
  String coverPhotoURL;

  @override
  Widget build(BuildContext context) {
    var contentURL = post.postContentType == "Ses"
        ? AppConstant.kAudioCardImage
        : post.postContentURL;

    coverPhotoURL = CommonMethods.createThumbnailURL(
        post.isLocatedInYoutube, contentURL,
        isAudio: false);

    return InkWell(
      onTap: () {
        NavigationService.instance.navigate(k_ROUTE_POST_DETAIL, args: post);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(imageUrl: coverPhotoURL, fit: BoxFit.cover),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
      ),
    );
  }
}
