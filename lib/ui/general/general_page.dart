import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/config/navigation/navigator_route_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GeneralPage extends StatefulWidget {
  @override
  _GeneralPageState createState() => _GeneralPageState();
}

class _GeneralPageState extends BaseState<GeneralPage> {
  PostProvider _postProvider;
  List<PostModel> topPosts;

  @override
  void initState() {
    super.initState();
    _postProvider = getProvider<PostProvider>();
    _postProvider.getTopPosts(isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnnouncementSlider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Haftanın Öne Çıkan Paylaşımları",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                TopPostsSlider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Podcast Önerileri",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                PodcastSlider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Bu Etkinlikleri Kaçırma!",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                EventSlider()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: Haftanın kullanıcıları, En hit paylaşımlar, yeni gruplar

  Padding AnnouncementSlider() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GFCarousel(
        autoPlay: true,
        activeIndicator: Colors.black,
        passiveIndicator: Colors.grey,
        items: imageList.map(
          (url) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.asset(url, fit: BoxFit.cover, width: 1000.0),
              ),
            );
          },
        ).toList(),
        onPageChanged: (index) {
          setState(() {});
        },
      ),
    );
  }

  Consumer<PostProvider> TopPostsSlider() {
    return Consumer<PostProvider>(builder: (_, provider, child) {
      if (provider.topPostList != null) {
        if (provider.topPostList.isNotEmpty) {
          return GFItemsCarousel(
            rowCount: 2,
            children: provider.topPostList.map((topPost) {
              return CustomPostCard(topPost);
            }).toList(),
          );
        } else {
          return Center(
            child: spinkit,
          );
        }
      } else {
        return Center(
          child: spinkit,
        );
      }
    });
  }

  List<Widget> createTopPostCards(List<PostModel> list) {
    return list.map((e) => CustomCard()).toList();
  }

  GFItemsCarousel PodcastSlider() {
    return GFItemsCarousel(
      itemHeight: 208,
      rowCount: 2,
      children: [
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/podcast.jpg'),
        )
      ],
    );
  }

  GFItemsCarousel EventSlider() {
    return GFItemsCarousel(
      rowCount: 2,
      children: [
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 1",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 2",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 3",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 4",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  final List<String> imageList = [
    "assets/images/soylesi3.png",
    "assets/images/soylesi3.png",
    "assets/images/soylesi3.png",
  ];
}

Widget CustomCard() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 240,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                      image: AssetImage('assets/images/drawerBg.jpg'),
                      fit: BoxFit.cover)),
            )),
            Text(
              "Başlık",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Altbaşlık",
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    ),
  );
}

Widget CustomPostCard(PostModel post) {
  String coverPhotoURL;
  if (post.isVideo == true) {
    coverPhotoURL = createThumbnailURL(post.postContentURL);
  } else {
    coverPhotoURL = post.postContentURL;
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          NavigationService.instance
              .navigate(k_ROUTE_POST_DETAIL, args: post.postId);
        },
        child: Container(
          height: 240,
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(coverPhotoURL), fit: BoxFit.cover)),
              )),
              Text(
                post.postTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                post.postDescription,
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

String createThumbnailURL(String youtubeVideoID) {
  String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
  String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
  return thumbnailURL;
}
