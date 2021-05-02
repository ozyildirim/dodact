import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class OthersProfilePage extends StatefulWidget {
  String otherUserID;

  OthersProfilePage({this.otherUserID});

  @override
  _OthersProfilePageState createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends BaseState<OthersProfilePage> {
  PostProvider postProvider;
  UserProvider userProvider;
  EventProvider eventProvider;

  String otherUserID;
  UserObject otherUser;
  List<PostModel> otherUserPosts;
  List<EventModel> otherUserEvents;

  @override
  void initState() {
    otherUserID = widget.otherUserID;
    postProvider = getProvider<PostProvider>();
    userProvider = getProvider<UserProvider>();
    eventProvider = getProvider<EventProvider>();
    super.initState();

    getUserProfile();

    postProvider.getUserPosts(otherUser, false, isNotify: false);
  }

  Future getUserProfile() async {
    return await userProvider.getUserByID(otherUserID).then((value) {
      otherUser = value;
    });
  }

  Future getUserPosts() async {
    return await postProvider
        .getUserPosts(otherUser, false, isNotify: false)
        .then((value) => otherUserPosts = value);
  }

  Future getUserEvents() async {
    return await eventProvider
        .getUserEvents(otherUser, isNotify: false)
        .then((value) => otherUserEvents = value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                              //TODO: BoxShadow u değiştir.
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
                        child: ProfileInfoPart(),
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                            "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar2.jpg?alt=media&token=68b5edcd-30e5-436e-84a3-990156fcfae5"),
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
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Popüler Paylaşımlar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                child: ListUserEvents(),
              )
            ],
          ),
        ),
      ),
    );
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 160.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(coverPhotoURL), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  String createThumbnailURL(String youtubeVideoID) {
    String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
    String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    return thumbnailURL;
  }

  FutureBuilder ListUserPosts() {
    return FutureBuilder(
        future: getUserPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView(
                scrollDirection: Axis.horizontal,
                children: otherUserPosts.map((e) {
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

  FutureBuilder ListUserEvents() {
    return FutureBuilder(
      future: getUserEvents(),
      builder: (context, snapshot) {
        otherUserEvents = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Container(
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
            );
          } else {
            return Center(
              child: Text("Henüz etkinlik kaydı yok."),
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

  FutureBuilder ProfileInfoPart() {
    return FutureBuilder(
      future: getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          otherUser = snapshot.data;
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          NetworkImage(otherUser.profilePictureURL),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        otherUser.nameSurname,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "@${otherUser.username}",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Gitarist",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: oxfordBlue,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Takip Et",
                              style: TextStyle(color: Colors.white),
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
                      icon: Icon(FontAwesome5Brands.twitter), onPressed: () {}),
                  IconButton(
                      icon: Icon(FontAwesome5Brands.youtube), onPressed: () {}),
                  IconButton(
                      icon: Icon(FontAwesome5Brands.instagram),
                      onPressed: () {})
                ],
              )
            ],
          );
        } else {
          return Center(
            child: spinkit,
          );
        }
      },
    );
  }
}
