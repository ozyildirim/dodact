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
        itemHeight: 170,
        rowCount: 2,
        children: podcastProvider.podcastList.map((podcast) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                NavigationService.instance
                    .navigate(k_ROUTE_PODCAST_DETAIL, args: podcast);
              },
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: podcast.podcastImageUrl,
                  imageBuilder: (context, imageProvider) {
                    return buildPodcastCard(imageProvider);
                  }),
            ),
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

  buildPodcastCard(ImageProvider imageProvider) {
    return Container(
      height: 150,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: imageProvider,
        ),
      ),
    );
  }
}
