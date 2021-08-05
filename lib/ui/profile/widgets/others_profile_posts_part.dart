import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OthersProfilePostsPart extends StatefulWidget {
  @override
  _OthersProfilePostsPartState createState() => _OthersProfilePostsPartState();
}

class _OthersProfilePostsPartState extends State<OthersProfilePostsPart>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  UserProvider userProvider;

  @override
  void initState() {
    tabController = new TabController(length: 4, vsync: this);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    Provider.of<PostProvider>(context, listen: false)
        .getOtherUserPosts(userProvider.otherUser);
    super.initState();
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
            controller: tabController,
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
            child: TabBarView(controller: tabController, children: [
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
  }

  Widget _buildPostListView(String category) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        if (provider.otherUsersPosts == null) {
          return Center(child: spinkit);
        } else {
          List<PostModel> posts = provider.otherUsersPosts;
          print("Toplam içerik sayısı: ${posts.length}");
          if (provider.otherUsersPosts.isNotEmpty) {
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
          NavigationService.instance
              .navigate(k_ROUTE_POST_DETAIL, args: post.postId);
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
}
