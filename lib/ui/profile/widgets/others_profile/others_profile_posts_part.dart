import 'package:dodact_v1/config/constants/theme_constants.dart';
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
      if (postProvider.otherUsersPosts.isNotEmpty) {
        List<PostModel> approvedPosts =
            getApprovedPosts(postProvider.otherUsersPosts);

        if (approvedPosts.isNotEmpty && approvedPosts != null) {
          return StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: approvedPosts.length,
            itemBuilder: (BuildContext context, int index) {
              var postItem = approvedPosts[index];
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
            child: Text(
              "Herhangi bir içerik oluşturulmamış.",
              style: TextStyle(fontSize: 22),
            ),
          );
        }
      } else {
        return Center(
          child: Text(
            "Herhangi bir içerik oluşturulmamış.",
            style: TextStyle(fontSize: 22),
          ),
        );
      }
    } else {
      return Center(child: spinkit);
    }
  }

  List<PostModel> getApprovedPosts(List<PostModel> posts) {
    List<PostModel> userPosts = posts;
    List<PostModel> approvedPosts = [];

    approvedPosts =
        userPosts.where((element) => element.approved == true).toList();

    return approvedPosts;
  }
}
