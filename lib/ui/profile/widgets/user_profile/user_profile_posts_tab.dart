import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/post_card_for_grids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class UserProfilePostsTab extends StatefulWidget {
  @override
  _UserProfilePostsTabState createState() => _UserProfilePostsTabState();
}

class _UserProfilePostsTabState extends BaseState<UserProfilePostsTab>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Provider.of<PostProvider>(context, listen: false)
        .getUserPosts(authProvider.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    if (postProvider.userPosts != null) {
      if (postProvider.userPosts.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(36.0),
          child: SvgPicture.asset(
              "assets/images/app/situations/undraw_blank_canvas_3rbb.svg",
              semanticsLabel: 'A red up arrow'),
        );
      }

      return StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: postProvider.userPosts.length,
        itemBuilder: (BuildContext context, int index) {
          var postItem = postProvider.userPosts[index];
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 200,
              child: PostCardForGrid(
                post: postItem,
              ),
            ),
          );
        },
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 4.0,
      );
    } else {
      return Center(child: spinkit);
    }
  }
}
