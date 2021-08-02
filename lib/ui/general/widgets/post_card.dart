import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  PostCard(this.post);
  String coverPhotoURL;

  @override
  Widget build(BuildContext context) {
    if (post.isVideo == true) {
      coverPhotoURL = CommonMethods.createThumbnailURL(
          post.isLocatedInYoutube, post.postContentURL);
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
            // color: Colors.amberAccent,
            height: 240,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Image.network(
                  coverPhotoURL,
                  fit: BoxFit.cover,
                )),
                Text(
                  post.postTitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
