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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                child: ListTile(
                    leading: InkWell(
                      onTap: () {
                        navigateOwnerProfile(
                          post,
                        );
                      },
                      child: CircleAvatar(
                        maxRadius: 25,
                        backgroundImage:
                            NetworkImage(provider.otherUser.profilePictureURL),
                      ),
                    ),
                    title: Center(
                      child: Text(
                        provider.otherUser.nameSurname != null
                            ? provider.otherUser.nameSurname
                            : provider.otherUser.username,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    subtitle: Center(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(post.postDate),
                      ),
                    ),
                    trailing: buildTrailingPart(post)),
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
              child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      navigateOwnerProfile(
                        post,
                        group: provider.group,
                      );
                    },
                    child: CircleAvatar(
                      maxRadius: 25,
                      backgroundImage:
                          NetworkImage(provider.group.groupProfilePicture),
                    ),
                  ),
                  title: Center(
                    child: Text(
                      provider.group.groupName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  subtitle: Center(
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(post.postDate),
                    ),
                  ),
                  trailing: buildTrailingPart(post)),
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
          return Text("${provider.post.dodCounter} Dod");
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
                    size: 45,
                  )
                : Icon(
                    Icons.flutter_dash_outlined,
                    size: 45,
                  ),
          );
        } else {
          return Center(child: spinkit);
        }
      },
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

  void navigateOwnerProfile(PostModel post, {GroupModel group}) {
    if (post.ownerType == "User") {
      if (post.ownerId == authProvider.currentUser.uid) {
      } else {
        NavigationService.instance
            .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: post.ownerId);
      }
    } else {
      NavigationService.instance.navigate(k_ROUTE_GROUP_DETAIL, args: group);
    }
  }
}
