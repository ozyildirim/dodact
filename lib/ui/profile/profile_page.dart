import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/profile/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  PostProvider _postProvider;
  @override
  void initState() {
    super.initState();
    _postProvider = getProvider<PostProvider>();
    _postProvider.getUserPosts(authProvider.currentUser, isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: ProfileDrawer(
          sentUser: authProvider.currentUser,
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Header Part
              // headerPart(),
              Container(
                width: dynamicWidth(1),
                height: 250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/profileBg.png"))),
                child: Center(
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.transparent,
                    backgroundImage: authProvider
                                .currentUser.profilePictureURL ==
                            null
                        ? NetworkImage(
                            "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png")
                        : NetworkImage(
                            authProvider.currentUser.profilePictureURL),
                  ),
                ),
              ),

              //Information Part
              informationPart(),
              tabPart(),
              postsPart()
              // Posts Part,
            ],
          ),
        ),
      ),
    );
  }

  Container tabPart() {
    return Container(
      height: 60,
      color: Colors.white,
      width: dynamicWidth(1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () {},
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Color(0xFF8A56AC)),
                child: Center(
                  child: Text(
                    "İÇERİKLER",
                    style: TextStyle(
                        fontFamily: kFontFamily,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          FlatButton(
              onPressed: () {},
              child: Text(
                "ETKİNLİKLER",
                style: TextStyle(
                    fontFamily: kFontFamily,
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

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

  String createThumbnailURL(String youtubeVideoID) {
    String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
    String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
    return thumbnailURL;
  }

  String convertMonth(int month) {
    switch (month) {
      case 1:
        return "Ocak";
      case 2:
        return "Şubat";
      case 3:
        return "Mart";
      case 4:
        return "Nisan";
      case 5:
        return "Mayıs";
      case 6:
        return "Haziran";
      case 7:
        return "Temmuz";
      case 8:
        return "Ağustos";
      case 9:
        return "Eylül";
      case 10:
        return "Ekim";
      case 11:
        return "Kasım";
      case 12:
        return "Aralık";
    }
  }
}
