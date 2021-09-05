import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/post_card_for_grids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GroupPostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    return provider.groupPosts != null
        ? provider.groupPosts.isNotEmpty
            ? StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: provider.groupPosts.length,
                itemBuilder: (BuildContext context, int index) {
                  var postItem = provider.groupPosts[index];
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
              )
            : Center(
                child: Container(
                  color: Colors.white60,
                  child: Text("Bu grup henüz bir içerik paylaşmadı.",
                      style: TextStyle(fontSize: 22)),
                ),
              )
        : Center(child: spinkit);
  }

  navigatePost(String postId) {
    NavigationService.instance.navigate(k_ROUTE_POST_DETAIL, args: postId);
  }
}
