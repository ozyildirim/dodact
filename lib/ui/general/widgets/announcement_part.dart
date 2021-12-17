import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/announcement_model.dart';
import 'package:dodact_v1/provider/announcement_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:provider/provider.dart';

class AnnouncementPart extends StatefulWidget {
  @override
  _AnnouncementPartState createState() => _AnnouncementPartState();
}

class _AnnouncementPartState extends State<AnnouncementPart> {
  AnnouncementProvider announcementProvider;
  List<AnnouncementModel> announcements;

  @override
  initState() {
    super.initState();
    announcementProvider =
        Provider.of<AnnouncementProvider>(context, listen: false);
    getList();
  }

  getList() {
    if (announcementProvider.announcementList == null) {
      announcementProvider.getList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AnnouncementProvider>(context);
    if (announcementProvider.announcementList != null) {
      return GFCarousel(
        autoPlay: true,
        activeIndicator: Colors.black,
        passiveIndicator: Colors.grey,
        items: announcementProvider.announcementList.map(
          (announcement) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: InkWell(
                  onTap: () {
                    if (announcement.isReference) {
                      CustomMethods.launchURL(announcement.referenceURL);
                    } else {
                      CustomMethods.showImagePreviewDialog(
                        context,
                        imageProvider: CachedNetworkImageProvider(
                            announcement.announcementImage),
                      );
                    }
                  },
                  child: CachedNetworkImage(
                    imageUrl: announcement.announcementImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ).toList(),
        onPageChanged: (index) {
          setState(() {});
        },
      );
    } else {
      return Center(child: spinkit);
    }
  }
}
