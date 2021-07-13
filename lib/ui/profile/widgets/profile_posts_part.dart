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

class _ProfilePostsPartState extends BaseState<ProfilePostsPart> {
  @override
  void initState() {
    super.initState();
  }

  //TODO: Postlar için filtreli görünüm eklenecek.

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

            return ListView(
              scrollDirection: Axis.horizontal,
              children: _userPosts != null
                  ? _userPosts.map((e) => _buildUserPostCard(e)).toList()
                  : [
                      Center(
                        child: Text("Paylaşım Yok :("),
                      )
                    ],
            );
        }
      },
      future: provider.getUserPosts(authProvider.currentUser),
    );
  }
}

// return ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemCount: _filteredPosts.length,
//     itemBuilder: (context, index) {
//       if (_filteredPosts[index] != null) {
//         // return _buildUserPostCard(_filteredPosts[index]);
//         return Container(height: 50, width: 50, color: Colors.green);
//       }
//     });

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
