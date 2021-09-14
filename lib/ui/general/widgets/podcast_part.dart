import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/podcast_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class PodcastPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final podcastProvider = Provider.of<PodcastProvider>(context);

    if (podcastProvider.podcastList != null) {
      return GFItemsCarousel(
        itemHeight: 208,
        rowCount: 1,
        children: podcastProvider.podcastList.map((podcast) {
          return InkWell(
            onTap: () {
              NavigationService.instance
                  .navigate(k_ROUTE_PODCAST_DETAIL, args: podcast);
            },
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 100,
                imageUrl: podcast.podcastImageUrl,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(podcast.podcastImageUrl),
                      ),
                    ),
                  );
                }),
          );
        }).toList(),
      );
    } else {
      return Container(
        child: Center(
          child: spinkit,
        ),
      );
    }
  }
}
