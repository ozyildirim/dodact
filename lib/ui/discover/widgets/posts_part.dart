import 'package:dodact_v1/config/constants/theme_constants.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    if (postProvider.postsSnapshot.isEmpty) {
      postProvider.fetchNextPosts();
    }
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

  Future<void> refreshPostPage() {
    setState(() {
      isLoading = true;
    });
    return Future(() async {
      postProvider.postsSnapshot.clear();
      await postProvider.fetchNextPosts();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PostProvider>(context);

    if (isLoading || provider.postsSnapshot.isEmpty) {
      return Center(
        child: spinkit,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: RefreshIndicator(
          onRefresh: refreshPostPage,
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
        ),
      );
    }
  }
}
