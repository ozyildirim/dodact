import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/post_card_for_grids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OthersProfilePostsTab extends StatefulWidget {
  @override
  _OthersProfilePostsTabState createState() => _OthersProfilePostsTabState();
}

class _OthersProfilePostsTabState extends State<OthersProfilePostsTab>
    with SingleTickerProviderStateMixin {
  UserProvider userProvider;
  PostProvider postProvider;

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    postProvider = Provider.of<PostProvider>(context, listen: false);
    Provider.of<PostProvider>(context, listen: false)
        .getOtherUserPosts(userProvider.otherUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (postProvider.otherUsersPosts != null) {
      if (postProvider.otherUsersPosts.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(36.0),
          child: SvgPicture.asset(
              "assets/images/app/situations/undraw_blank_canvas_3rbb.svg",
              semanticsLabel: 'A red up arrow'),
        );
      }

      return StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: postProvider.otherUsersPosts.length,
        itemBuilder: (BuildContext context, int index) {
          var postItem = postProvider.otherUsersPosts[index];
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
