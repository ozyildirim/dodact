import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePostsPart extends StatefulWidget {
  String type;

  ProfilePostsPart({this.type});

  @override
  _ProfilePostsPartState createState() => _ProfilePostsPartState();
}

class _ProfilePostsPartState extends BaseState<ProfilePostsPart>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context, listen: false);
    return FutureBuilder(
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: spinkit);
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            List<PostModel> _userPosts = snapshot.data;
            int i = 1;
            _userPosts.forEach((element) {
              print("$i ${element.isVideo}");
              i++;
            });

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  child: TabBar(
                    labelColor: Colors.black,
                    controller: _controller,
                    tabs: const [
                      const Tab(text: "Müzik"),
                      const Tab(text: "Resim"),
                      const Tab(text: "Tiyatro"),
                    ],
                  ),
                ),
                Container(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(controller: _controller, children: [
                      _buildListView(_userPosts, "Müzik"),
                      _buildListView(_userPosts, "Resim"),
                      _buildListView(_userPosts, "Tiyatro"),
                    ]),
                  ),
                ),
              ],
            );
        }
      },
      future: provider.getUserPosts(authProvider.currentUser),
    );
  }
}

Widget _buildListView(List<PostModel> _userPosts, String category) {
  List<PostModel> _filteredPosts = _userPosts.map((e) {
    if (e.postCategory == category) {
      print(e.postTitle);
      // return e;
    }
  }).toList();

  return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _filteredPosts.length,
      itemBuilder: (context, index) {
        if (_filteredPosts[index] != null) {
          return _buildUserPostCard(_filteredPosts[index]);
        }
      });
}

// Consumer<PostProvider>(builder: (context, provider, child) {
//       if (provider.isLoading == false) {
//         if (provider.usersPosts != null) {
//           return ListView(
//             scrollDirection: Axis.horizontal,
//             children: provider.usersPosts.map((e) {
//               return _buildUserPostCard(e);
//             }).toList(),
//           );
//         } else {
//           return Center(child: spinkit);
//         }
//       } else {
//         return Center(child: spinkit);
//       }
//     });

Widget _buildUserPostCard(PostModel post) {
  String coverPhotoURL;
  if (post.isVideo == true) {
    coverPhotoURL = CommonMethods.createThumbnailURL(post.postContentURL);
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
          child: Center(
            child: Icon(
              Icons.play_circle_fill,
              size: 50,
              color: Colors.white,
            ),
          ),
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
