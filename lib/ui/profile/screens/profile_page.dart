import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/profile/screens/others_profile_page.dart';

import 'package:dodact_v1/ui/profile/widgets/drawer.dart';
import 'package:dodact_v1/ui/profile/widgets/profile_info_part.dart'
    as ProfileInfo;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  PostProvider _postProvider;
  UserProvider _userProvider;
  @override
  void initState() {
    _postProvider = getProvider<PostProvider>();
    _userProvider = getProvider<UserProvider>();
    _userProvider.getCurrentUser();
    _postProvider.getUserPosts(_userProvider.user, isNotify: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserProvider>(
        builder: (_, provider, child) {
          if (provider.isLoading == false) {
            if (provider.user != null) {
              return Scaffold(
                backgroundColor: Colors.white,
                extendBodyBehindAppBar: true,
                endDrawer: ProfileDrawer(),
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                          // ignore: deprecated_member_use
                          overflow: Overflow.visible,
                          fit: StackFit.passthrough,
                          children: [
                            Container(
                              height: 206,
                              decoration: BoxDecoration(
                                  color: oxfordBlue,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50))),
                            ),
                            ProfileInfo.ProfileInfoPart()
                          ]),
                      SizedBox(
                        height: 130,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Popüler Paylaşımlar",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                          width: dynamicWidth(0.90),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 250.0,
                          child: _buildUserPostList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Katıldığı Etkinlikler",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                          width: dynamicWidth(0.90),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 150.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 160.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2F3.jpg?alt=media&token=c8f8ba1e-c1f2-4425-8780-12f58b744d1f"))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 160.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2F3.jpg?alt=media&token=c8f8ba1e-c1f2-4425-8780-12f58b744d1f"))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: spinkit,
              );
            }
          } else {
            return Center(child: spinkit);
          }
        },
      ),
    );
  }

  Consumer<PostProvider> _buildUserPostList() {
    return Consumer<PostProvider>(builder: (context, provider, child) {
      if (provider.isLoading == false) {
        if (provider.usersPosts != null) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: provider.usersPosts.map((e) {
              return _buildUserPostCard(e);
            }).toList(),
          );
        } else {
          return Center(child: spinkit);
        }
      } else {
        return Center(child: spinkit);
      }
    });
  }

  Widget _buildUserPostCard(PostModel post) {
    String coverPhotoURL;
    if (post.isVideo == true) {
      coverPhotoURL = createThumbnailURL(post.postContentURL);
    } else {
      coverPhotoURL = post.postContentURL;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          NavigationService.instance.navigate('/post', args: post);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 50,
                color: Colors.white,
              ),
            ),
            width: 160.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(coverPhotoURL), fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}
