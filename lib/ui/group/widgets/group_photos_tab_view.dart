import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class GroupPhotosTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);

    if (provider.group.groupMedia.length == 0 ||
        provider.group.groupMedia == null) {
      return Padding(
        padding: const EdgeInsets.all(36.0),
        child: Container(
          height: 30,
          width: 30,
          child: SvgPicture.asset(
              "assets/images/app/situations/undraw_not_found_60pq.svg",
              semanticsLabel: 'A red up arrow'),
        ),
      );
    }
    return GFItemsCarousel(
      rowCount: 3,
      children: provider.group.groupMedia.map(
        (url) {
          return CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) {
                return InkWell(
                  onTap: () {
                    CommonMethods.showImagePreviewDialog(context,
                        imageProvider: imageProvider);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child:
                          Image.network(url, fit: BoxFit.cover, width: 1000.0),
                    ),
                  ),
                );
              });
        },
      ).toList(),
    );
  }
}
