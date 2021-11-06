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
    final postProvider = Provider.of<PostProvider>(context);

    if (postProvider.topPosts != null) {
      List<PostModel> _topPosts = postProvider.topPosts;
      return GFItemsCarousel(
        rowCount: 2,
        children: _topPosts.map(
          (topPost) {
            return PostCard(topPost);
          },
        ).toList(),
      );
    } else {
      return Center(
        child: spinkit,
      );
    }
  }
}
