import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/podcast_model.dart';
import 'package:dodact_v1/provider/podcast_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class PodcastPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);

    return FutureBuilder(
      future: podcastProvider.getPodcastList(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: spinkit);

          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Hata!");
            }
            List<PodcastModel> podcasts = snapshot.data;
            if (podcasts.isEmpty) {
              return Text("Boş");
            }

            return GFItemsCarousel(
              itemHeight: 208,
              rowCount: 2,
              children: podcasts.map((podcast) {
                return InkWell(
                  onTap: () {
                    NavigationService.instance
                        .navigate(k_ROUTE_PODCAST_DETAIL, args: podcast);
                  },
                  child: Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(podcast.podcastImageUrl),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}



/**
 * 
 * return GFItemsCarousel(
      itemHeight: 208,
      rowCount: 2,
      children: [
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        )
      ],
    );
 * 
 * */