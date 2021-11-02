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
  var postProvider;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
    scrollController = ScrollController();

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
    // return StaggeredGridView(
    //     controller: scrollController,
    //     padding: EdgeInsets.all(8),
    //     shrinkWrap: true,
    //     addAutomaticKeepAlives: true,
    //     addRepaintBoundaries: true,
    //     gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 4,
    //       // staggeredTileCount: 4,
    //       staggeredTileBuilder: (int index) =>
    //           StaggeredTile.count(2, index.isEven ? 2 : 1),
    //       mainAxisSpacing: 4.0,
    //       crossAxisSpacing: 4.0,
    //     ),
    //     children: [
    //       ...widget.provider.posts
    //           .map((post) => PostCardForGrid(post: post))
    //           .toList(),
    //       if (widget.provider.hasNext)
    //         Container(
    //           child: Center(
    //             child: GestureDetector(
    //               onTap: widget.provider.fetchNextPosts,
    //               child: Container(
    //                 child: CircularProgressIndicator(),
    //                 width: 25,
    //                 height: 25,
    //               ),
    //             ),
    //           ),
    //         )
    //     ]);
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

    //   return ListView(
    //     controller: scrollController,
    //     children: [
    //       ...widget.provider.posts.map((e) => Text(e.postTitle)).toList(),
    //       if (widget.provider.hasNext)
    //         Center(
    //           child: GestureDetector(
    //             onTap: widget.provider.fetchNextPosts,
    //             child: Container(
    //               child: CircularProgressIndicator(),
    //               width: 25,
    //               height: 25,
    //             ),
    //           ),
    //         )
    //     ],
    //   );
    // }
    //
    // @override
    //   Widget build(BuildContext context) => ListView(
    //         controller: scrollController,
    //         padding: EdgeInsets.all(12),
    //         children: [
    //           ...widget.provider.posts
    //               .map((post) => ListTile(
    //                     title: Text(post.postTitle),
    //                   ))
    //               .toList(),
    //           if (widget.provider.hasNext)
    //             Center(
    //               child: GestureDetector(
    //                 onTap: widget.provider.fetchNextPosts,
    //                 child: Container(
    //                   height: 25,
    //                   width: 25,
    //                   child: CircularProgressIndicator(),
    //                 ),
    //               ),
    //             ),
    //         ],
    //       );
    // }
  }
}
