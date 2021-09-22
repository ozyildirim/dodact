import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImagePostHeader extends StatelessWidget {
  PostModel post;

  ImagePostHeader({this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      child: PinchZoom(
        child: CachedNetworkImage(
          imageUrl: post.postContentURL,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) =>
              Container(child: Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        onZoomStart: () {
          print('Start zooming');
        },
        onZoomEnd: () {
          print('Stop zooming');
        },
      ),
    );
  }
}
