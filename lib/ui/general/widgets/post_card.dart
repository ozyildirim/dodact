import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/app_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  PostModel post;

  PostCard(this.post);
  String coverPhotoURL;

  @override
  Widget build(BuildContext context) {
    var contentURL =
        post.postContentType == "Ses" ? kAudioCardImage : post.postContentURL;

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
        margin: EdgeInsets.all(10),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(8),
    //     child: InkWell(
    //       onTap: () {
    //         NavigationService.instance
    //             .navigate(k_ROUTE_POST_DETAIL, args: post);
    //       },
    //       child: Container(
    //         color: kBackgroundColor,
    //         height: 240,
    //         width: 200,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Expanded(
    //               child: CachedNetworkImage(
    //                 height: 200,
    //                 fit: BoxFit.cover,
    //                 placeholder: (context, url) => Container(
    //                   child: Center(child: spinkit),
    //                 ),
    //                 imageUrl: coverPhotoURL,
    //                 imageBuilder: (context, imageProvider) {
    //                   return Container(
    //                     decoration: BoxDecoration(
    //                       image: DecorationImage(
    //                           image: imageProvider, fit: BoxFit.cover),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Container(
    //                 height: 20,
    //                 child: Text(
    //                   post.postTitle,
    //                   overflow: TextOverflow.ellipsis,
    //                   style:
    //                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
