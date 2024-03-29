import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupPostManagementPage extends StatefulWidget {
  @override
  State<GroupPostManagementPage> createState() =>
      _GroupPostManagementPageState();
}

class _GroupPostManagementPageState extends BaseState<GroupPostManagementPage> {
  GroupProvider groupProvider;

  @override
  Widget build(BuildContext context) {
    groupProvider = Provider.of<GroupProvider>(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Topluluk Gönderi Yönetimi"),
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
                    child: Text(
                  "Topluluğa ait paylaşım bulunmuyor.",
                  style: TextStyle(fontSize: kPageCenteredTextSize),
                ));
              } else {
                return GridView.builder(
                    itemCount: asyncSnapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: mediaQuery.size.width * 0.02,
                      mainAxisSpacing: mediaQuery.size.width * 0.02,
                    ),
                    itemBuilder: (context, index) {
                      var post = asyncSnapshot.data[index];
                      var postCoverPhoto = CustomMethods.createThumbnailURL(
                          post.isLocatedInYoutube, post.postContentURL,
                          isAudio:
                              post.postContentType == "Ses" ? true : false);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(postCoverPhoto),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: Colors.grey,
                                  child: ListTile(
                                    title: Text(
                                      post.postTitle,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      DateFormat("dd/MM/yyyy")
                                          .format(post.postDate),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.black),
                                        onPressed: () {
                                          showDeletePostDialog(post.postId);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

  showDeletePostDialog(String postId) async {
    CustomMethods.showCustomDialog(
        context: context,
        title: "Bu içeriği silmek istediğinden emin misin?",
        confirmButtonText: "Evet",
        confirmActions: () {
          deleteGroupPost(postId);
        });
  }

  Future<void> deleteGroupPost(String postId) async {
    try {
      await groupProvider.deleteGroupPost(postId);
      NavigationService.instance.pop();
      setState(() {});
      CustomMethods.showSnackbar(
          context, "Topluluk gönderisi başarıyla kaldırıldı.");
    } catch (e) {
      CustomMethods.showSnackbar(
          context, "Topluluk gönderisi kaldırılırken bir hata oluştu.");
    }
  }

  Future<List<PostModel>> getGroupPosts() async {
    return await groupProvider.getGroupPosts(groupProvider.group.groupId);
  }

  bool canUserManage() {
    return groupProvider.group.managerId == userProvider.currentUser.uid;
  }
}
