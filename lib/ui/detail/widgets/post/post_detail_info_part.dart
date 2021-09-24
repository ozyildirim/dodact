import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
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
  AuthProvider authProvider;
  UserObject creator;
  bool isDodded;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of(context, listen: false);
    getCreatorData(context, widget.post.ownerType, widget.post.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    var post = postProvider.post;

    return buildInfoPart(post);
  }

  Widget buildInfoPart(PostModel post) {
    if (post.ownerType == 'User') {
      return Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.otherUser != null) {
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
                        showOwnerProfile(post);
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(provider.otherUser.profilePictureURL),
                        radius: 30,
                      ),
                    ),
                    buildShareButton()
                  ],
                ),
              ),
            );
          }
          return Center(child: spinkit);
        },
      );
    } else {
      return Consumer<GroupProvider>(builder: (context, provider, child) {
        if (provider.group != null) {
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
                      showOwnerProfile(post, group: provider.group);
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(provider.group.groupProfilePicture),
                      radius: 30,
                    ),
                  ),
                  buildShareButton()
                ],
              ),
            ),
          );
        }
        return Center(child: spinkit);
      });
    }
  }

  Widget buildTrailingPart(PostModel post) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        if (post.ownerId == authProvider.currentUser.uid) {
          return Center(child: Text("${provider.post.dodCounter} Dod"));
        } else if (provider.postDodders != null) {
          bool liked = provider.postDodders.any(
              (element) => element.dodderId == authProvider.currentUser.uid);

          return Bounce(
            duration: Duration(milliseconds: 220),
            onPressed: () async {
              if (liked) {
                await provider.undodPost(
                    post.postId, authProvider.currentUser.uid);
              } else {
                await provider.dodPost(
                    post.postId, authProvider.currentUser.uid);
              }
            },
            child: liked
                ? Icon(
                    Icons.flutter_dash_outlined,
                    color: Colors.red,
                    size: 40,
                  )
                : Icon(
                    Icons.flutter_dash_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
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
