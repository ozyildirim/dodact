import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImagePostHeader extends StatelessWidget {
  PostModel post;

  ImagePostHeader({this.post});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: post.postContentURL,
        imageBuilder: (context, imageProvider) => InkWell(
          onTap: () {
            CustomMethods.showImagePreviewDialog(context,
                imageProvider: imageProvider);
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
