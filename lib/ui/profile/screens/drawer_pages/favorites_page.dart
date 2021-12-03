import 'package:dodact_v1/ui/common/methods/methods.dart';
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
    if (userProvider.currentUser.favoritedPosts.length > 0) {
      var favoritedPostIDs = userProvider.currentUser.favoritedPosts;

      for (var postID in favoritedPostIDs) {
        var post = await Provider.of<PostProvider>(context, listen: false)
            .getDetail(postID);

        //Null ise favorilerden sildirecek bir şey yapmak lazım.

        if (post != null) {
          fetchedPosts.add(post);
        } else {
          userProvider.removeFavoritePost(postID);
        }
      }
      setState(() {
        posts = fetchedPosts;
      });
      return fetchedPosts;
    } else {
      print("fav post yok");
      setState(() {
        posts = fetchedPosts;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("favs" + userProvider.currentUser.favoritedPosts.toString());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backwardsCompatibility: true,
        title: Text('Favoriler'),
        elevation: 8,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: posts == null
            ? Center(
                child: spinkit,
              )
            : (posts.isEmpty
                ? Center(
                    child: Text("Henüz bir gönderiyi favorilere eklemedin",
                        style: TextStyle(fontSize: 20)),
                  )
                : posts.isNotEmpty
                    ? ListView.builder(
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
                                child: GFListTile(
                                  onTap: () {
                                    NavigationService.instance.navigate(
                                        k_ROUTE_POST_DETAIL,
                                        args: element);
                                  },
                                  avatar: GFAvatar(
                                    backgroundImage: NetworkImage(postPhoto),
                                    radius: 50,
                                  ),
                                  titleText: element.postTitle,
                                  subTitleText: element.postCategory,
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
                      )
                    : Center(
                        child: spinkit,
                      )),
      ),
    );
  }

  Future<void> _removeFavorite(String postId) async {
    await userProvider.removeFavoritePost(postId);
    setState(() {});
  }
}
