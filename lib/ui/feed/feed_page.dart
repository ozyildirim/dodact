import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends BaseState<FeedPage> {
  PostProvider _postProvider;

  @override
  void initState() {
    super.initState();
    _postProvider = getProvider<PostProvider>();
    _postProvider.getList(isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kBackgroundColor),
      child: postsPart(),
    );
  }

  Consumer<PostProvider> postsPart() {
    return Consumer<PostProvider>(
      builder: (_, provider, child) {
        if (provider.postList != null) {
          if (provider.postList.isNotEmpty) {
            print(provider.postList.length);
            return SafeArea(
              child: Container(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: provider.postList.length,
                  itemBuilder: (context, index) {
                    var postItem = provider.postList[index];
                    var thumbnailURL =
                        createThumbnailURL(postItem.postContentURL);
                    // UserObject ownerObject =
                    //     await UserProvider().getUserByID(postItem.ownerId);
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
                                      fit: BoxFit.cover),
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
                                  color: Colors.tealAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/90E78C2B-D798-480E-8534-5A2751ACAB1F.jpg?alt=media&token=e7715a69-e2eb-4d28-be8f-ae724eefe439'),
                                ),
                                title: Text(
                                  postItem.postTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
              ),
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
      },
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
