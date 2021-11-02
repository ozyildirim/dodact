import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContributedPostListPage extends StatelessWidget {
  final String organizationName;

  ContributedPostListPage({Key key, this.organizationName});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PostProvider>(context);
    provider.getContributedPosts(organizationName);

    return Scaffold(
      appBar: AppBar(
        title: Text("Oluşturulan İçerikler"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        width: MediaQuery.of(context).size.width,
        child: provider.postList == null
            ? Center(child: CircularProgressIndicator())
            : provider.postList.isEmpty
                ? Text("Henüz içerik yok")
                : ListView.builder(
                    itemCount: provider.postList.length,
                    itemBuilder: (context, index) {
                      var post = provider.postList[index];

                      var thumbnail = CommonMethods.createThumbnailURL(
                          post.isLocatedInYoutube, post.postContentURL);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white60,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.cyanAccent,
                              backgroundImage: NetworkImage(thumbnail),
                              maxRadius: 50,
                            ),
                            onTap: () {
                              NavigationService.instance
                                  .navigate(k_ROUTE_POST_DETAIL, args: post);
                            },
                            title: Text(post.postTitle),
                            subtitle: Text(post.postCategory),
                          ),
                        ),
                      );
                    }),
      ),
    );
  }
}
