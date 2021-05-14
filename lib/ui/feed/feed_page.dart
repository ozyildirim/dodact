import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/feed/component/post_card.dart';
import 'package:dodact_v1/ui/feed/component/story_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends BaseState<FeedPage> {
  PostProvider _postProvider;
  UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _postProvider = getProvider<PostProvider>();
    _postProvider.getList(isNotify: false);
    _userProvider = getProvider<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    print(dynamicHeight(1));
    print(dynamicWidth(1));
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: kBackgroundColor),
        child: postsPart(),
      ),
    );
  }

  Consumer<PostProvider> postsPart() {
    return Consumer<PostProvider>(
      builder: (_, provider, child) {
        if (provider.postList != null) {
          if (provider.postList.isNotEmpty) {
            print(provider.postList.length);
            return SafeArea(
              child: Column(
                children: [
                  StoryContainer(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: provider.postList.length,
                      itemBuilder: (context, index) {
                        // provider.postList.shuffle();
                        var postItem = provider.postList[index];
                        return Container(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: PostCard(
                              post: postItem,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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

  // GestureDetector yedek() {
  //   return GestureDetector(
  //     onTap: () {
  //       NavigationService.instance.navigate('/post', args: postItem);
  //     },
  //     child: Container(
  //       width: dynamicWidth(1),
  //       child: Column(
  //         children: [
  //           Container(
  //             width: dynamicWidth(1),
  //             height: 200,
  //             decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                     image: NetworkImage(thumbnailURL), fit: BoxFit.cover),
  //                 borderRadius: BorderRadius.only(
  //                     bottomRight: Radius.circular(60),
  //                     topRight: Radius.circular(60))),
  //             child: Center(
  //               child: CircleAvatar(
  //                 child: Icon(
  //                   Icons.play_arrow,
  //                   color: Colors.black,
  //                 ),
  //                 backgroundColor: Colors.white,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             height: 70,
  //             width: dynamicWidth(1),
  //             decoration: BoxDecoration(
  //                 color: Colors.tealAccent,
  //                 borderRadius: BorderRadius.all(Radius.circular(50))),
  //             child: ListTile(
  //               leading: CircleAvatar(
  //                 backgroundImage: NetworkImage(
  //                     'https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/90E78C2B-D798-480E-8534-5A2751ACAB1F.jpg?alt=media&token=e7715a69-e2eb-4d28-be8f-ae724eefe439'),
  //               ),
  //               title: Text(
  //                 postItem.postTitle,
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //               ),
  //               subtitle: Text(
  //                 postItem.postDate.day.toString() +
  //                     " " +
  //                     convertMonth(postItem.postDate.month) +
  //                     " " +
  //                     postItem.postDate.year.toString(),
  //                 style: TextStyle(fontSize: 12),
  //               ),
  //               trailing: Icon(Icons.arrow_forward),
  //             ),
  //           )
  //         ],
  //       ),
  //       padding: EdgeInsets.all(10),
  //     ),
  //   );
  // }

}

String createThumbnailURL(String youtubeVideoID) {
  String videoID = YoutubePlayer.convertUrlToId(youtubeVideoID);
  String thumbnailURL = "https://img.youtube.com/vi/" + videoID + "/0.jpg";
  return thumbnailURL;
}
