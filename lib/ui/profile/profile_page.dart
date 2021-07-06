import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/profile/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
                            Positioned(
                              top: 80,
                              left: (dynamicWidth(1) - 330) / 2,
                              child: Container(
                                width: 330,
                                height: 220,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: const Offset(
                                          1.0,
                                          1.0,
                                        ),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      //BoxShadow
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                                provider
                                                    .user.profilePictureURL),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              provider.user.nameSurname,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "@${provider.user.username}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Gitar Tutkunu",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 40,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: oxfordBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Takip Et",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                                FontAwesome5Brands.twitter)),
                                        IconButton(
                                            icon: Icon(
                                                FontAwesome5Brands.youtube),
                                            onPressed: () {}),
                                        IconButton(
                                            icon: Icon(
                                                FontAwesome5Brands.instagram),
                                            onPressed: () {})
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 130,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Kazandığı Rozetler",
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
                      Container(
                        height: 150.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar2.jpg?alt=media&token=68b5edcd-30e5-436e-84a3-990156fcfae5"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                          ],
                        ),
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
                          child: ListUserPosts(),
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

/*
  Consumer<PostProvider> postsPart() {
    return Consumer<PostProvider>(
      builder: (_, provider, child) {
        if (provider.usersPosts != null) {
          if (provider.usersPosts.isNotEmpty) {
            print(provider.usersPosts.length);
            return Container(
              color: kBackgroundColor,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: provider.usersPosts.length,
                itemBuilder: (context, index) {
                  var postItem = provider.usersPosts[index];
                  var thumbnailURL =
                      createThumbnailURL(postItem.postContentURL);
                  return GestureDetector(
                    onTap: () {
                      NavigationService.instance
                          .navigate('/post', args: postItem);
                    },
                    child: Container(
                      width: dynamicWidth(1),
                      child: Column(
                        children: [
                          Container(
                            width: dynamicWidth(1),
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(thumbnailURL),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(60),
                                    topRight: Radius.circular(60))),
                            child: Center(
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 70,
                            width: dynamicWidth(1),
                            decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50))),
                            child: ListTile(
                              title: Text(
                                postItem.postTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text(
                                postItem.postDate.day.toString() +
                                    " " +
                                    convertMonth(postItem.postDate.month) +
                                    " " +
                                    postItem.postDate.year.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  );
                },
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: spinkit,
              ),
            );
          }
        } else {
          return Center(
            child: spinkit,
          );
        }
      },
    );
  }

  Container informationPart() {
    return Container(
      width: dynamicWidth(1),
      height: 110,
      decoration: BoxDecoration(
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey,
            //   blurRadius: 10.0,
            //   spreadRadius: 3.0,
            //   offset: Offset(10.0, 10.0),
            // ),
          ],
          color: kBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(100),
          )),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                authProvider.currentUser.nameSurname,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "@" + authProvider.currentUser.username,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: kFontFamily,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            )
          ],
        ),
      ),
    );
  }

 */
  String createThumbnailURL(String youtubeVideoID) {
    String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
    String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    return thumbnailURL;
  }

  Consumer<PostProvider> ListUserPosts() {
    return Consumer<PostProvider>(builder: (context, provider, child) {
      if (provider.isLoading == false) {
        if (provider.usersPosts != null) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: provider.usersPosts.map((e) {
              return CreateUserPostCard(e);
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

  Widget CreateUserPostCard(PostModel post) {
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
