import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailInfoPart extends StatefulWidget {
  @override
  _PostDetailInfoPartState createState() => _PostDetailInfoPartState();
}

class _PostDetailInfoPartState extends BaseState<PostDetailInfoPart> {
  AuthProvider authProvider;
  UserObject creator;

  @override
  void initState() {
    super.initState();
    fetchCreatorData();
  }

  Future<void> fetchCreatorData() async {
    var post = Provider.of<PostProvider>(context, listen: false).post;
    await Provider.of<UserProvider>(context, listen: false)
        .getOtherUser(post.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    if (postProvider.post == null) {
      return Center(child: spinkit);
    } else {
      var post = postProvider.post;
      return ListTile(
          leading: InkWell(
            onTap: () {
              navigateToOwnerProfile(post);
            },
            child: CircleAvatar(
              backgroundImage: userProvider.otherUser != null
                  ? NetworkImage(userProvider.otherUser.profilePictureURL)
                  : null,
            ),
          ),
          title: Center(child: Text(post.postTitle)),
          subtitle: userProvider.otherUser != null
              ? Center(child: Text(userProvider.otherUser.nameSurname))
              : null,
          trailing: post.supportersId.length != null
              ? Text("${post.supportersId.length} Dod")
              : null);
    }
  }

  void navigateToOwnerProfile(PostModel post) {
    if (post.ownerType == "User") {
      if (post.ownerId == authProvider.currentUser.uid) {
        return null;
      } else {
        NavigationService.instance
            .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: post.ownerId);
      }
    } else {
      NavigationService.instance
          .navigate(k_ROUTE_GROUP_DETAIL, args: post.ownerId);
    }
  }
}
