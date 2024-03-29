import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailInfoPart extends StatefulWidget {
  final PostModel post;

  PostDetailInfoPart({this.post});

  @override
  _PostDetailInfoPartState createState() => _PostDetailInfoPartState();
}

class _PostDetailInfoPartState extends BaseState<PostDetailInfoPart> {
  UserObject creator;
  bool isDodded;
  PostModel post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return buildInfoPart(post);
  }

  buildInfoPart(PostModel post) {
    if (post.ownerType == 'User') {
      return FutureBuilder(
        future: userProvider.getOtherUser(post.ownerId),
        builder: (context, snapshot) {
          UserObject user = snapshot.data;
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildTrailingPart(post),
                  GestureDetector(
                    onTap: () {
                      showOwnerProfile(post);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 32,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePictureURL),
                        radius: 30,
                      ),
                    ),
                  ),
                  // buildShareButton()
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return spinkit;
        },
      );
    } else if (post.ownerType == 'Group') {
      return FutureBuilder(
        future: Provider.of<GroupProvider>(context, listen: false)
            .getGroupDetail(post.ownerId),
        builder: (context, snapshot) {
          GroupModel group = snapshot.data;
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildTrailingPart(post),
                    GestureDetector(
                      onTap: () {
                        showOwnerProfile(post, group: group);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 32,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(group.groupProfilePicture),
                          radius: 30,
                        ),
                      ),
                    ),
                    // buildShareButton()
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return spinkit;
        },
      );
    }
  }

  Widget buildTrailingPart(PostModel post) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        if (post.ownerId == userProvider.currentUser.uid) {
          return Row(
            children: [
              Icon(
                Icons.flutter_dash_outlined,
                size: 24,
                color: Colors.black,
              ),
              SizedBox(width: 5),
              Center(
                  child: Text(
                "${provider.post.dodCounter}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )),
            ],
          );
        } else if (provider.postDodders != null) {
          bool liked = provider.postDodders.any(
              (element) => element.dodderId == userProvider.currentUser.uid);

          return Column(
            children: [
              Bounce(
                duration: Duration(milliseconds: 220),
                onPressed: () async {
                  if (liked) {
                    provider.undodPost(
                        post.postId, userProvider.currentUser.uid);
                  } else {
                    try {
                      provider.dodPost(
                          post.postId, userProvider.currentUser.uid);
                    } catch (e) {
                      CustomMethods.showSnackbar(context, "Bir hata oluştu.");
                    }
                  }
                },
                child: liked
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 28,
                      )
                    : Icon(
                        Icons.favorite_border,
                        size: 28,
                        color: Colors.black,
                      ),
              ),
              SizedBox(height: 4),
              Text("Dod")
            ],
          );
        } else {
          return Center(child: spinkit);
        }
      },
    );
  }

  buildShareButton() {
    return IconButton(
      onPressed: () {
        Share.share("Örnek paylaşım");
      },
      icon: Icon(FontAwesome5Regular.paper_plane, color: Colors.grey),
    );
  }

  Future<void> getCreatorData(
      BuildContext context, String ownerType, String creatorId) async {
    if (ownerType == 'User') {
      await Provider.of<UserProvider>(context, listen: false)
          .getOtherUser(creatorId);
    } else if (ownerType == 'Group') {
      await Provider.of<GroupProvider>(context, listen: false)
          .getGroupDetail(creatorId);
    }
  }

  void showOwnerProfile(PostModel post, {GroupModel group}) {
    if (post.ownerType == "User") {
      if (post.ownerId == authProvider.currentUser.uid) {
      } else {
        NavigationService.instance.navigate(k_ROUTE_OTHERS_PROFILE_PAGE,
            args: Provider.of<UserProvider>(context, listen: false).otherUser);
      }
    } else {
      NavigationService.instance.navigate(k_ROUTE_GROUP_DETAIL, args: group);
    }
  }
}
