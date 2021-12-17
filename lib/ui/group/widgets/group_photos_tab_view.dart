import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class GroupMediaTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);

    if (provider.group.groupMedia.length == 0 ||
        provider.group.groupMedia == null) {
      return Center(
        child: Container(
          color: Colors.white60,
          child: Text("Bu topluluk henüz bir medya dosyası eklemedi",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kPageCenteredTextSize)),
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
                    CustomMethods.showImagePreviewDialog(context,
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
