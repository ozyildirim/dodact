import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/story_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_story_service.dart';
import 'package:dodact_v1/ui/feed/component/story_components/story_page_view.dart';
import 'package:flutter/material.dart';

class StoryContainer extends StatefulWidget {
  @override
  _StoryContainerState createState() => _StoryContainerState();
}

class _StoryContainerState extends BaseState<StoryContainer> {
  UserProvider userProvider;
  Topic storyTopic;

  List<StoryModel> stories = [];

  @override
  void initState() {
    super.initState();
    userProvider = getProvider<UserProvider>();

    getStories().then((value) => stories = value);
  }

  Future getStories() async {
    return await FirebaseStoryService().getStoryList();
  }

  List<StoryContainerItem> storyAvatars = [
    StoryContainerItem(
        "Müzik",
        "https://digitalage.com.tr/wp-content/uploads/2020/06/Pandemi-doneminde-degisen-muzik-dinleme-egilimleri.jpg",
        Topic.Muzik),
    StoryContainerItem(
        "Resim",
        "https://klasiksanatlar.com/img/sayfalar/b/1_1598452306_resim.png",
        Topic.Resim),
    StoryContainerItem(
        "Tiyatro",
        "https://im.haberturk.com/2020/09/13/ver1599997191/2802222_1920x1080.jpg",
        Topic.Tiyatro),
    StoryContainerItem(
        "Dans",
        "https://img-s2.onedio.com/id-5e0e1424a181be44523430d9/rev-0/w-635/listing/f-jpg-webp/s-0fdfcc94be25ec0766c3b7daf8bfa2a948e9f4b9.webp",
        Topic.Dans)
  ];

  @override
  Widget build(BuildContext context) {
    FirebaseStoryService().getStoryList();
    return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.only(left: 10),
        height: 120,
        child: Center(
          child: FutureBuilder(
            future: getStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Center(child: spinkit);
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: storyAvatars.length,
                    itemBuilder: (BuildContext context, int index) {
                      var storyItem = storyAvatars[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoryPageView(
                                            topic: storyItem.topic,
                                            stories: stories)));
                              },
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(storyItem.coverPhoto),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(storyItem.name)
                          ],
                        ),
                      );
                    });
              }
            },
          ),
        ));
  }
}

enum Topic { Resim, Tiyatro, Dans, Muzik }

class StoryContainerItem {
  String name;
  String coverPhoto;
  Topic topic;

  StoryContainerItem(this.name, this.coverPhoto, this.topic);
}
