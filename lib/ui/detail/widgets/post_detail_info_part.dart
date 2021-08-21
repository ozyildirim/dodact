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
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class PostDetailInfoPart extends StatefulWidget {
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
    fetchCreatorData();
  }

  Future<void> fetchCreatorData() async {
    var post = Provider.of<PostProvider>(context, listen: false).post;
    await Provider.of<UserProvider>(context, listen: false)
        .getOtherUser(post.ownerId);
  }

  bool checkIfDodded() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    if (postProvider.post == null) {
      return Center(child: spinkit);
    } else {
      var post = postProvider.post;

      if (userProvider.otherUser != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white60,
            child: ListTile(
                leading: InkWell(
                  onTap: () {
                    navigateToOwnerProfile(post);
                  },
                  child: CircleAvatar(
                    maxRadius: 40,
                    backgroundImage:
                        NetworkImage(userProvider.otherUser.profilePictureURL),
                  ),
                ),
                title: Center(
                  child: Text(
                    userProvider.otherUser.nameSurname != null
                        ? userProvider.otherUser.nameSurname
                        : userProvider.otherUser.username,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(post.postDate),
                  ),
                ),
                trailing: post.supportersId.length != null
                    ? post.ownerId != authProvider.currentUser.uid
                        ? Consumer<PostProvider>(
                            builder: (context, provider, child) {
                              bool liked = provider.post.supportersId
                                  .contains(authProvider.currentUser.uid);

                              return
                                  // LikeButton(
                                  //   size: 30,
                                  //   circleColor: CircleColor(
                                  //       start: Color(0xff00ddff),
                                  //       end: Color(0xff0099cc)),
                                  //   bubblesColor: BubblesColor(
                                  //     dotPrimaryColor: Color(0xff33b5e5),
                                  //     dotSecondaryColor: Color(0xff0099cc),
                                  //   ),
                                  //   likeBuilder: (bool isLiked) {
                                  //     return Icon(
                                  //       Icons.home,
                                  //       color: isLiked
                                  //           ? Colors.deepPurpleAccent
                                  //           : Colors.grey,
                                  //       size: 45,
                                  //     );
                                  //   },
                                  //   isLiked: liked,
                                  // );
                                  Bounce(
                                duration: Duration(milliseconds: 220),
                                onPressed: () async {
                                  await provider.changePostDoddedStatus(
                                      post.postId,
                                      authProvider.currentUser.uid,
                                      !liked);
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
                            },
                          )
                        : Text("${post.supportersId.length} Dod")
                    : null),
          ),
        );
      } else {
        return Center(child: spinkit);
      }
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
