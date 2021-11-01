import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/post_card_for_grids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class OthersProfilePostsTab extends StatefulWidget {
  final UserObject user;

  const OthersProfilePostsTab({this.user});

  @override
  _OthersProfilePostsTabState createState() => _OthersProfilePostsTabState();
}

class _OthersProfilePostsTabState extends State<OthersProfilePostsTab>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var postProvider = Provider.of<PostProvider>(context, listen: false);

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: spinkit,
          );
        } else {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              List<PostModel> posts = snapshot.data;

              if (posts.isNotEmpty && posts != null) {
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
            return Center(
              child: spinkit,
            );
          }
        }
      },
      future: postProvider.getUserPosts(widget.user),
    );
  }
}
