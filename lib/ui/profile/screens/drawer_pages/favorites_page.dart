import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
    List<PostModel> fetchedPosts = [];
    if (authProvider.currentUser.favoritedPosts.length > 0) {
      var favoritedPostIDs = authProvider.currentUser.favoritedPosts;

      for (var postID in favoritedPostIDs) {
        var post = await Provider.of<PostProvider>(context, listen: false)
            .getDetail(postID);
        fetchedPosts.add(post);
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
        child: posts == null
            ? Center(child: Text("Favorileriniz bulunamadı"))
            : (posts.isEmpty
                ? Center(child: Text("Favorilerim boş."))
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  NavigationService.instance.navigate(
                                      k_ROUTE_POST_DETAIL,
                                      args: element.postId);
                                },
                                leading: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(postPhoto),
                                ),
                                subtitle: Text(element.postCategory),
                                title: Text(element.postTitle),
                              ),
                            ),
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            actions: [
                              IconSlideAction(
                                caption: 'Favorilerimden Çıkar',
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
                    itemCount: authProvider.currentUser.favoritedPosts.length,
                  )),
      ),
    );
  }

  Future<void> _removeFavorite(String postId) async {
    await authProvider.removeFavoritePost(postId);
    setState(() {});
  }
}
