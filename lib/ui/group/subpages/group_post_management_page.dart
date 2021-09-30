import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupPostManagementPage extends StatelessWidget {
  GroupProvider groupProvider;
  @override
  Widget build(BuildContext context) {
    groupProvider = Provider.of(context, listen: false);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Grup Paylaşım Yönetimi"),
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
        child: FutureBuilder(
          future: getGroupPosts(),
          builder: (context, AsyncSnapshot<List<PostModel>> asyncSnapshot) {
            if (asyncSnapshot.connectionState != ConnectionState.done) {
              return Center(
                child: spinkit,
              );
            } else {
              if (asyncSnapshot.data.length == 0) {
                return Center(
                  child: Text("Grup Paylaşımı Bulunmamakta."),
                );
              } else {
                return ListView.builder(
                    itemCount: asyncSnapshot.data.length,
                    itemBuilder: (context, index) {
                      var post = asyncSnapshot.data[index];
                      var postCoverPhoto = CommonMethods.createThumbnailURL(
                          post.isLocatedInYoutube, post.postContentURL,
                          isAudio:
                              post.postContentType == "Ses" ? true : false);
                      print(postCoverPhoto);

                      return Container(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Container(
                              // height: mediaQuery.size.height * 0.5,
                              width: mediaQuery.size.width * 0.3,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(postCoverPhoto),
                                  )),
                            ),
                            radius: 60,
                          ),
                          title: Text(
                            post.postTitle,
                            style: TextStyle(fontSize: 22),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.postCategory),
                              Text(DateFormat("dd/MM/yyyy")
                                  .format(post.postDate))
                            ],
                          ),
                        ),
                      );
                    });
              }
            }
            // return main screen here
          },
        ),
      ),
    );
  }

  Future<List<PostModel>> getGroupPosts() async {
    return await groupProvider.getGroupPosts(groupProvider.group.groupId);
  }
}
