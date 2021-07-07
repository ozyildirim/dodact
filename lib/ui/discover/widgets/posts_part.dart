import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/discover/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return SafeArea(
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
              return Column(
                children: [
                  // StoryContainer(),
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
        },
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