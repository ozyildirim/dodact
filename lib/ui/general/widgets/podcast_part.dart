import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class PodcastPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GFItemsCarousel(
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
  }
}
