import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/post_card_for_grids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GroupPostsTab extends StatelessWidget {
  final String groupId;

  GroupPostsTab({this.groupId});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context, listen: false);
    return FutureBuilder(
        future: provider.getGroupPosts(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                List<PostModel> posts = snapshot.data;

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    var postItem = posts[index];
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
                return Center(
                  child: Text("Bu topluluk henüz bir gönderi oluşturmadı.",
                      style: TextStyle(fontSize: kPageCenteredTextSize)),
                );
              }
            } else {
              return Center(
                child: Text(
                  "Bir hata oluştu.",
                  style: TextStyle(fontSize: kPageCenteredTextSize),
                ),
              );
            }
          } else {
            return Center(
              child: spinkit,
            );
          }
        });
  }

  navigatePost(PostModel post) {
    NavigationService.instance.navigate(k_ROUTE_POST_DETAIL, args: post);
  }
}
