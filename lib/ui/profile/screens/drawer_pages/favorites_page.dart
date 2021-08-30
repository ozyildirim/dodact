import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';

import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends BaseState<FavoritesPage> {
  List<PostModel> posts;

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future<void> getPosts() async {
    //TODO: Favorilerdeki postlardan herhangi birisi silindiğinde bunun favorilerden de silinmesi lazım.
    List<PostModel> fetchedPosts = [];
    if (authProvider.currentUser.favoritedPosts.length > 0) {
      var favoritedPostIDs = authProvider.currentUser.favoritedPosts;

      for (var postID in favoritedPostIDs) {
        var post = await Provider.of<PostProvider>(context, listen: false)
            .getDetail(postID);

        if (post != null) {
          fetchedPosts.add(post);
        }
      }
      setState(() {
        posts = fetchedPosts;
      });
      return fetchedPosts;
    } else {
      print("fav post yok");
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        title: Text('Favorilerim'),
        elevation: 8,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: posts == null
            ? Center(
                child: Text(
                "Favorileriniz bulunamadı",
                style: TextStyle(fontSize: 22),
              ))
            : (posts.isEmpty
                ? Center(
                    child: Container(
                      color: Colors.white70,
                      child: Text("Henüz favorilere eklenmiş bir paylaşım yok.",
                          style: TextStyle(fontSize: 18)),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      var postPhoto;
                      var element = posts[index];
                      element.isLocatedInYoutube == true
                          ? postPhoto = CommonMethods.createThumbnailURL(
                              true, element.postContentURL)
                          : postPhoto = element.postContentURL;

                      return Column(
                        children: [
                          Slidable(
                            child: Container(
                              color: Colors.white70,
                              child: GFListTile(
                                onTap: () {
                                  NavigationService.instance.navigate(
                                      k_ROUTE_POST_DETAIL,
                                      args: element.postId);
                                },
                                avatar: GFAvatar(
                                  backgroundImage: NetworkImage(postPhoto),
                                  radius: 50,
                                ),
                                titleText: element.postTitle,
                                subTitleText: element.postCategory,
                              ),
                            ),
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            actions: [
                              IconSlideAction(
                                caption: 'Kaldır',
                                color: Colors.red,
                                icon: FontAwesome5Solid.trash,
                                onTap: () async =>
                                    await _removeFavorite(element.postId),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.8,
                          )
                        ],
                      );
                    },
                    itemCount: posts.length,
                  )),
      ),
    );
  }

  Future<void> _removeFavorite(String postId) async {
    await authProvider.removeFavoritePost(postId);
    setState(() {});
  }
}
