import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class GroupPhotosTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);

    return GFItemsCarousel(
      rowCount: 3,
      children: provider.group.groupPhotos.map(
        (url) {
          return CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Image.network(url, fit: BoxFit.cover, width: 1000.0),
                  ),
                );
              });
        },
      ).toList(),
    );
  }
}
