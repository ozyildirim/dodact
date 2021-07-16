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
  Future _postsFuture;

  Future _refreshPostsFuture() {
    return Provider.of<PostProvider>(context, listen: false).getList();
  }

  Future<void> _refreshPosts() async {
    await Provider.of<PostProvider>(context, listen: false).getList();
  }

  @override
  void initState() {
    _postsFuture = _refreshPostsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _refreshPosts(),
        child: FutureBuilder(
          future: _postsFuture,
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
                  padding: const EdgeInsets.all(8.0),
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
              // return Column(
              //   children: [
              //     // StoryContainer(),
              //     Expanded(
              //       child: ListView.builder(
              //         padding: EdgeInsets.zero,
              //         primary: false,
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         itemCount: posts.length,
              //         itemBuilder: (context, index) {
              //           // provider.postList.shuffle();
              //           var postItem = posts[index];
              // return Container(
              //   height: 400,
              //   child: Padding(
              //     padding: const EdgeInsets.all(5.0),
              //     child: PostCard(
              //       post: postItem,
              //     ),
              //   ),
              // );
              //         },
              //       ),
              //     ),
              //   ],
              // );
            }
          },
        ),
      ),
    );
  }
}

/*
(BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: spinkit);
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text("Error"),
              );
            } else {
              return Column(
                children: [
                  StoryContainer(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        // provider.postList.shuffle();
                        var postItem = posts[index];
                        return Container(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: PostCard(
                              post: postItem,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
        },

*/