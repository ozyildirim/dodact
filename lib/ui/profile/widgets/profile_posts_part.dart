import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePostsPart extends StatefulWidget {
  @override
  _ProfilePostsPartState createState() => _ProfilePostsPartState();
}

class _ProfilePostsPartState extends BaseState<ProfilePostsPart>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(length: 4, vsync: this);
    super.initState();
    Provider.of<PostProvider>(context, listen: false)
        .getUserPosts(authProvider.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          child: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16),
            controller: _controller,
            tabs: const [
              const Tab(text: "Müzik"),
              const Tab(text: "Resim"),
              const Tab(text: "Tiyatro"),
              const Tab(text: "Dans"),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(controller: _controller, children: [
              Container(
                child: _buildPostListView("Müzik"),
              ),
              Container(
                child: _buildPostListView("Resim"),
              ),
              Container(
                child: _buildPostListView("Tiyatro"),
              ),
              Container(
                child: _buildPostListView("Dans"),
              ),
            ]),
          ),
        ),
      ],
    );

    // return FutureBuilder(
    //   // ignore: missing_return
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.none:
    //       case ConnectionState.active:
    //       case ConnectionState.waiting:
    //         return Center(child: spinkit);
    //       case ConnectionState.done:
    //         if (snapshot.hasError) {
    //           return Text("Error: ${snapshot.error}");
    //         }
    //         List<PostModel> _userPosts =
    //             (snapshot.data as List<PostModel>).map((post) {
    //           if (post.approved == true) {
    //             return post;
    //           }
    //         }).toList();

    //         if (_userPosts.isEmpty) {
    //           return Center(
    //             child: Container(
    //                 color: Colors.pink, child: Text("Paylaşım Yok :(")),
    //           );
    //         } else {
    //           return ListView(
    //             scrollDirection: Axis.horizontal,
    //             children: _userPosts.map((post) {
    //               _buildUserPostCard(post);
    //             }).toList(),
    //           );
    //         }
    //     }
    //   },
    //   future: provider.getUserPosts(authProvider.currentUser),
    // );
  }

  Widget _buildPostListView(String category) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        if (provider.userPosts == null) {
          return Center(child: spinkit);
        } else {
          List<PostModel> posts = provider.userPosts;
          print("Toplam içerik sayısı: ${posts.length}");
          if (provider.userPosts.isNotEmpty) {
            posts = posts
                .where((post) =>
                    (post.postCategory == category) && (post.approved == true))
                .toList();
            print(posts.length);
          }

          if (posts.isEmpty) {
            return Center(
              child: Text("Bu kategoride paylaşım bulunmamakta"),
            );
          } else {
            return Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return _buildUserPostCard(posts[index]);
                },
              ),
            );
          }
        }
      },
    );
  }
}

Widget _buildUserPostCard(PostModel post) {
  String coverPhotoURL;
  if (post.isVideo == true) {
    coverPhotoURL = CommonMethods.createThumbnailURL(
        post.isLocatedInYoutube, post.postContentURL);
  } else {
    coverPhotoURL = post.postContentURL;
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        NavigationService.instance.navigate('/post', args: post.postId);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          child: post.isVideo
              ? Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 50,
                    color: Colors.white,
                  ),
                )
              : null,
          width: 250.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(coverPhotoURL), fit: BoxFit.cover),
          ),
        ),
      ),
    ),
  );
}
