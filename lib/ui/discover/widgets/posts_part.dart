import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/discover/widgets/post_card_for_grids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class PostsPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StaggeredGridViewWidget();
}

class StaggeredGridViewWidget extends StatefulWidget {
  @override
  _StaggeredGridViewWidgetState createState() =>
      _StaggeredGridViewWidgetState();
}

class _StaggeredGridViewWidgetState extends State<StaggeredGridViewWidget> {
  ScrollController scrollController;
  PostProvider postProvider;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
    scrollController = ScrollController();
    postProvider.postsSnapshot.clear();
    scrollController.addListener(scrollListener);
    postProvider.fetchNextPosts();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      postProvider.fetchNextPosts();
      // if (widget.provider.hasNext) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PostProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: StaggeredGridView.countBuilder(
        controller: scrollController,
        crossAxisCount: 4,
        itemCount: postProvider.posts.length,
        itemBuilder: (BuildContext context, int index) {
          var postItem = postProvider.posts[index];
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
}
