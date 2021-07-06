import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/general/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:provider/provider.dart';

class PostPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return FutureBuilder(
      future: postProvider.getTopPosts(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            print("Building");
            return Center(
              child: spinkit,
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            List<PostModel> _topPosts = snapshot.data;
            return GFItemsCarousel(
              rowCount: 2,
              children: _topPosts.map(
                (topPost) {
                  return PostCard(topPost);
                },
              ).toList(),
            );
        }
      },
    );
  }
}
