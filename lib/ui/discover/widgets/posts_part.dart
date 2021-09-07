import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/discover/widgets/post_card_for_grids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class PostsPart extends StatefulWidget {
  @override
  _PostsPartState createState() => _PostsPartState();
}

class _PostsPartState extends State<PostsPart> {
  Future<void> _refreshPosts(BuildContext context) async {
    await Provider.of<PostProvider>(context, listen: false).getList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () => _refreshPosts(context),
      child: FutureBuilder(
        future: postProvider.getList(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: spinkit,
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              List<PostModel> posts = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    var postItem = posts[index];
                    return Container(
                      height: 400,
                      child: PostCardForGrid(
                        post: postItem,
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
              );
          }
        },
      ),
    );
  }
}
